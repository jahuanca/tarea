import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/create_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/delete_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/get_all_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/update_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoAsistenciaRegistroController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<AsistenciaRegistroPersonalEntity> registrosSeleccionados = [];
  AsistenciaFechaTurnoEntity asistencia;

  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetAllAsistenciaRegistroUseCase _getAllAsistenciaRegistroUseCase;
  final CreateAsistenciaRegistroUseCase _createAsistenciaRegistroUseCase;
  final UpdateAsistenciaRegistroUseCase _updateAsistenciaRegistroUseCase;
  final DeleteAsistenciaRegistroUseCase _deleteAsistenciaRegistroUseCase;

  bool validando = BOOLEAN_FALSE_VALUE;
  bool editando = BOOLEAN_FALSE_VALUE;
  HoneywellScanner honeywellScanner;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  ListadoAsistenciaRegistroController(
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getAllAsistenciaRegistroUseCase,
    this._createAsistenciaRegistroUseCase,
    this._updateAsistenciaRegistroUseCase,
    this._deleteAsistenciaRegistroUseCase,
  );

  Future<void> getDetalles() async {
    registrosSeleccionados =
        await _getAllAsistenciaRegistroUseCase.execute(asistencia.key);
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['asistencia'] != null) {
        asistencia = Get.arguments['asistencia'] as AsistenciaFechaTurnoEntity;
        print(asistencia.toJson());
        await getDetalles();
      }

      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        validando = true;
        update([VALIDANDO_ID]);
        personal = await _getPersonalsEmpresaBySubdivisionUseCase
            .execute(PreferenciasUsuario().idSede);
        validando = false;
        update([VALIDANDO_ID]);
      }
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    sunmiBarcodePlugin = SunmiBarcodePlugin();
    if (await sunmiBarcodePlugin.isScannerAvailable()) {
      initPlatformState();
      sunmiBarcodePlugin.onBarcodeScanned().listen((event) async {
        await setCodeBar(event, true);
      });
    } else {
      initHoneyScanner();
    }
  }

  Future<void> initPlatformState() async {
    try {
      await sunmiBarcodePlugin.getScannerModel();
    } on PlatformException {
      print('Failed to get model version.');
    }
  }

  void initHoneyScanner() {
    List<CodeFormat> codeFormats = [];
    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
    Map<String, dynamic> properties = {
      ...CodeFormatUtils.getAsPropertiesComplement(codeFormats),
      'DEC_CODABAR_START_STOP_TRANSMIT': true,
      'DEC_EAN13_CHECK_DIGIT_TRANSMIT': true,
    };

    honeywellScanner = HoneywellScanner();
    honeywellScanner.setScannerCallBack(this);
    honeywellScanner.setProperties(properties);
    honeywellScanner.startScanner();
  }

  @override
  void onClose() async {
    if (await honeywellScanner?.isSupported() ?? false) {
      honeywellScanner.stopScanner();
    }
    super.onClose();
  }

  @override
  void onDecoded(String result) async {
    await setCodeBar(result, true);
  }

  @override
  void onError(Exception error) {
    toastError('Error', error.toString());
  }

  Future<void> _showNotification(bool success, String mensaje) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    false;

    await flutterLocalNotificationsPlugin.show(
      0,
      success ? 'Exito' : 'Error',
      mensaje,
      platform,
      payload: '',
    );
  }

  Future<dynamic> _onSelectNotification(String json) async {
    return;
  }

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<bool> onWillPop() async {
    Get.back(result: registrosSeleccionados.length);
    return true;
  }

  Future<void> changeOptionsGlobal(dynamic index) async {
    switch (index) {
      case 1:
        seleccionados.clear();
        for (var i = 0; i < registrosSeleccionados.length; i++) {
          seleccionados.add(i);
        }
        update(['seleccionados', 'personal_seleccionado']);
        break;
      case 2:
        seleccionados.clear();
        update(['seleccionados', 'personal_seleccionado']);
        break;
      default:
        break;
    }
  }

  Future<void> changeOptions(dynamic index, int key) async {
    switch (index) {
      case 2:
        goEliminar(key);
        break;
      default:
        break;
    }
  }

  Future<void> goEliminar(int key) async {
    basicDialog(
      Get.overlayContext,
      ALERT_STRING,
      '¿Desea eliminar el registro?',
      YES_STRING,
      NO_STRING,
      () async {
        Get.back();
        registrosSeleccionados.removeWhere((e) => e.key == key);
        await _deleteAsistenciaRegistroUseCase.execute(asistencia.key, key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      () => Get.back(),
    );
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", CANCEL_STRING, BOOLEAN_FALSE_VALUE, ScanMode.DEFAULT)
        .listen((barcode) async {
      await setCodeBar(barcode);
    });
  }

  bool buscando = BOOLEAN_FALSE_VALUE;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando == false) {
      buscando = BOOLEAN_TRUE_VALUE;

      int indexEncontrado = registrosSeleccionados.indexWhere((e) =>
          e.personal.nrodocumento.toString().trim() ==
          barcode.toString().trim());
      if (indexEncontrado != -1) {
        AsistenciaRegistroPersonalEntity newDetalle =
            AsistenciaRegistroPersonalEntity.fromJson(
                registrosSeleccionados[indexEncontrado].toJson());
        if (!newDetalle.horaentrada
            .add(Duration(minutes: 5))
            .isBefore(DateTime.now())) {
          byLector
              ? toastError('Error', 'Debe esperar 5 minutos.')
              : await _showNotification(
                  BOOLEAN_FALSE_VALUE, 'Debe esperar 5 minutos.');
          return;
        }
        newDetalle.horasalida = DateTime.now();
        await _updateAsistenciaRegistroUseCase.execute(
          asistencia.key,
          newDetalle.key,
          newDetalle,
        );
        byLector
            ? toastExito('Exito', 'Registro cerrado.')
            : await _showNotification(BOOLEAN_TRUE_VALUE, 'Registro cerrado.');
        update(['${LISTADO_ASISTENCIA_REGISTRO_ID}_${newDetalle.key}']);
        return;
      }
      /*if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando = false;
        return;
      }*/

      int index = personal.indexWhere(
          (e) => e.nrodocumento.trim() == barcode.toString().trim());
      if (index != -1) {
        AsistenciaRegistroPersonalEntity d = AsistenciaRegistroPersonalEntity(
          personal: personal[index],
          codigoempresa: personal[index].codigoempresa,
          fechaentrada: DateTime.now(),
          horaentrada: DateTime.now(),
          idusuario: PreferenciasUsuario().idUsuario,
        );
        int key =
            await _createAsistenciaRegistroUseCase.execute(asistencia.key, d);
        d.key = key;
        registrosSeleccionados.add(d);
        update(['personal_seleccionado']);
        byLector
            ? toastExito('Éxito', 'Registrado con exito')
            : await _showNotification(true, 'Registrado con exito');
        buscando = false;
        return;
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : await _showNotification(false, 'No se encuentra en la lista');
        buscando = false;
        return;
      }
    }
  }
}
