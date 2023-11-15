import 'dart:developer';

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
import 'package:flutter_tareo/ui/control_asistencia/utils/contants.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
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
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    registrosSeleccionados =
        await _getAllAsistenciaRegistroUseCase.execute(asistencia.getId);
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['asistencia'] != null) {
        asistencia = Get.arguments['asistencia'] as AsistenciaFechaTurnoEntity;
      }
      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        await _getAll();
        print(personal.first.nrodocumento);
        print(personal.last.nrodocumento);
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
        await setCodeBar(event, BOOLEAN_TRUE_VALUE);
      });
    } else {
      initHoneyScanner();
    }
  }

  Future<void> _getAll() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    registrosSeleccionados =
        await _getAllAsistenciaRegistroUseCase.execute(asistencia.getId);
    personal = await _getPersonalsEmpresaBySubdivisionUseCase
        .execute(PreferenciasUsuario().idSede);
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    update(['personal_seleccionado']);
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
    toast(type: TypeToast.ERROR, message: error.toString());
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
      context: Get.overlayContext,
      message: '¿Desea eliminar el registro?',
      onPressed: () async {
        Get.back();
        registrosSeleccionados.removeWhere((e) => e.getId == key);
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        await _deleteAsistenciaRegistroUseCase.execute(asistencia.getId, key);
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
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

      int indexEncontrado = registrosSeleccionados.lastIndexWhere((e) =>
          e.personal.nrodocumento.toString().trim() ==
          barcode.toString().trim());

      if (indexEncontrado != -1 &&
          registrosSeleccionados[indexEncontrado].tipomovimiento == 'I') {
        AsistenciaRegistroPersonalEntity newDetalle =
            AsistenciaRegistroPersonalEntity.fromJson(
                registrosSeleccionados[indexEncontrado].toJson());
        if (!newDetalle.horaentrada
            .add(WAITING_INTERVAL)
            .isBefore(DateTime.now())) {
          buscando = BOOLEAN_FALSE_VALUE;
          byLector
              ? toast(type: TypeToast.ERROR, message: 'Debe esperar 5 minutos.')
              : await _showNotification(
                  BOOLEAN_FALSE_VALUE, 'Debe esperar 5 minutos.');
          return;
        }
        newDetalle.horasalida = DateTime.now();
        newDetalle.fechasalida = DateTime.now();
        newDetalle.fechamod = DateTime.now();
        newDetalle.tipomovimiento = 'S';
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        await _updateAsistenciaRegistroUseCase.execute(
          asistencia.getId,
          newDetalle.getId,
          newDetalle,
        );
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        registrosSeleccionados[indexEncontrado] = newDetalle;
        buscando = BOOLEAN_FALSE_VALUE;
        update([LISTADO_ASISTENCIA_REGISTRO_ID, CONTADOR_ID]);
        byLector
            ? toast(type: TypeToast.SUCCESS, message: 'Registro cerrado.')
            : await _showNotification(BOOLEAN_TRUE_VALUE, 'Registro cerrado.');
        return;
      }

      int index = personal.indexWhere(
          (e) => e.nrodocumento.trim() == barcode.toString().trim());
      if (index != -1) {
        AsistenciaRegistroPersonalEntity d = AsistenciaRegistroPersonalEntity(
          personal: personal[index],
          codigoempresa: personal[index].codigoempresa,
          fechaentrada: DateTime.now(),
          horaentrada: DateTime.now(),
          fechamod: DateTime.now(),
          fechaturno: asistencia.fecha,
          idturno: asistencia.idturno,
          idubicacionentrada: asistencia.idubicacion,
          idubicacionsalida: asistencia.idubicacion,
          idasistenciaturno: asistencia?.idasistenciaturno,
          tipomovimiento: 'I',
          idusuario: PreferenciasUsuario().idUsuario,
        );
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        int key =
            await _createAsistenciaRegistroUseCase.execute(asistencia.getId, d);
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        d.setId = key;
        registrosSeleccionados.insert(ZERO_INT_VALUE, d);
        update([LISTADO_ASISTENCIA_REGISTRO_ID, CONTADOR_ID]);
        byLector
            ? toast(type: TypeToast.SUCCESS, message: 'Registrado con exito')
            : await _showNotification(true, 'Registrado con exito');
        buscando = false;
        return;
      } else {
        byLector
            ? toast(
                type: TypeToast.ERROR, message: 'No se encuentra en la lista')
            : await _showNotification(false, 'No se encuentra en la lista');
        buscando = false;
        return;
      }
    }
  }
}
