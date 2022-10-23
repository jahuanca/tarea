import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/create_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/delete_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/get_all_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasClasificacionController extends GetxController {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PreTareaEsparragoDetalleEntity> personalSeleccionado = [];
  int indexTarea;
  int indexFormato;
  int keyCaja;
  /* PreTareaEsparragoEntity preTarea; */
  List<PreTareaEsparragoDetalleEntity> detalles;
  List<PreTareaEsparragoFormatoEntity> otrasCajas = [];

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];

  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetActividadsUseCase _getActividadsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;

  final GetAllCajaDetalleUseCase _getAllCajaDetalleUseCase;
  final CreateCajaDetalleUseCase _createCajaDetalleUseCase;
  final DeleteCajaDetalleUseCase _deleteCajaDetalleUseCase;
  

  bool validando = false;
  bool editando = false;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasClasificacionController(
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getActividadsUseCase,
      this._getLaborsUseCase,
      this._createCajaDetalleUseCase,
      this._deleteCajaDetalleUseCase,
      this._getAllCajaDetalleUseCase,
  );

  Future<void> getDetalles()async{
    personalSeleccionado=await _getAllCajaDetalleUseCase.execute('caja_detalle_$keyCaja');
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    actividades = await _getActividadsUseCase.execute();
    labores = await _getLaborsUseCase.execute();

    if (Get.arguments != null) {
      if (Get.arguments['index'] != null) {
        editando = true;
        indexTarea = Get.arguments['index'] as int;
      }

      if (Get.arguments['index_formato'] != null) {
        editando = true;
        indexFormato = Get.arguments['index_formato'] as int;
      }

      if (Get.arguments['otras'] != null) {
        otrasCajas =
            Get.arguments['otras'] as List<PreTareaEsparragoFormatoEntity>;
      }
      if (Get.arguments['key_caja'] != null) {
        keyCaja = Get.arguments['key_caja'] as int;
        await getDetalles();
      }

      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        validando = true;
        update(['validando']);
        personal = await _getPersonalsEmpresaBySubdivisionUseCase
            .execute(PreferenciasUsuario().idSede);

        validando = false;
        update(['validando']);
      }
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
    /* honeywellScannerClasificacion.startScanner(); */
    sunmiBarcodePlugin = SunmiBarcodePlugin();
    if (await sunmiBarcodePlugin.isScannerAvailable()) {
      initPlatformState();
      print('es valido');
      sunmiBarcodePlugin.onBarcodeScanned().listen((event) async {
        await setCodeBar(event, true);
      });
    } else {
      print('no es valido SUNMI');
      initHoneyScanner();
    }
  }

  Future<void> initPlatformState() async {
    String modelVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      modelVersion = (await sunmiBarcodePlugin.getScannerModel()).toString();
      print(modelVersion);
    } on PlatformException {
      modelVersion = 'Failed to get model version.';
    }
  }

  void initHoneyScanner() {
    List<CodeFormat> codeFormats = [];
    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);

  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _showNotification(bool success, String mensaje) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    false;

    await flutterLocalNotificationsPlugin?.show(
      2,
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
    Get.back(result: personalSeleccionado.length);
    return true;
  }

  Future<void> changeOptionsGlobal(dynamic index) async {
    switch (index) {
      case 1:
        seleccionados.clear();
        for (var i = 0; i < personalSeleccionado.length; i++) {
          seleccionados.add(i);
        }
        update(['seleccionados', 'personal_seleccionado']);
        break;
      case 2:
        seleccionados.clear();
        update(['seleccionados', 'personal_seleccionado']);
        break;
      default:
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

  void goEliminar(int key) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta eliminar el personal?',
      'Si',
      'No',
      () async {
        Get.back();
        personalSeleccionado.removeWhere((element) => element.key == key);
        await _deleteCajaDetalleUseCase.execute('caja_detalle_$keyCaja', key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      () => Get.back(),
    );
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancelar", false, ScanMode.DEFAULT)
        .listen((barcode) async {
      await setCodeBar(barcode);
    });
  }

  bool buscando = false;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando == false) {
      buscando = true;

      int indexEncontrado = personalSeleccionado
          .indexWhere((e) => e.codigotk == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando = false;
        update(['personal_seleccionado']);
        return;
      }

      List<String> valores = barcode.toString().split('_');

      if (valores.length < 4) {
        buscando = false;
        return;
      }

      int index = personal.indexWhere((e) => e.codigoempresa == valores[0]);
      if (index != -1) {
        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.parse(valores[2]));

        PreTareaEsparragoDetalleEntity d=PreTareaEsparragoDetalleEntity(
          personal: personal[index],
          codigoempresa: personal[index].codigoempresa,
          fecha: DateTime.now(),
          hora: DateTime.now(),
          imei: PreferenciasUsuario().imei ?? '',
          idestado: 1,
          idlabor: labores[indexLabor].idlabor,
          idactividad: labores[indexLabor].idactividad,
          labor: labores[indexLabor],
          linea: int.parse(valores[3]),
          correlativo: int.parse(valores[4]),
          codigotk: barcode.toString(),
          idusuario: PreferenciasUsuario().idUsuario,
        );

        
        int key=await _createCajaDetalleUseCase.execute('caja_detalle_$keyCaja', d);
        d.key=key;
        personalSeleccionado.add(d);

        byLector
            ? toastExito('Éxito', 'Registrado con exito')
            : await _showNotification(true, 'Registrado con exito');
        buscando = false;
        update(['personal_seleccionado']);
        return;
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : await _showNotification(false, 'No se encuentra en la lista');
        buscando = false;
        update(['personal_seleccionado']);
        return;
      }
    }
  }
}
