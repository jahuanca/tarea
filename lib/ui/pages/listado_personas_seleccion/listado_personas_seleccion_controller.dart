import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/create_seleccion_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/delete_seleccion_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/get_all_seleccion_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasSeleccionController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PreTareaEsparragoDetalleGrupoEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareaEsparragoGrupoEntity preTarea;
  /* List<PreTareaEsparragoGrupoEntity> otrasPreTareas=[]; */

  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetAllSeleccionDetallesUseCase _getAllSeleccionDetallesUseCase;
  final CreateSeleccionDetalleUseCase _createSeleccionDetalleUseCase;
  final DeleteSeleccionDetalleUseCase _deleteSeleccionDetalleUseCase;
  /* final UpdateSeleccionUseCase _updateSeleccionUseCase; */
  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  ListadoPersonasSeleccionController(
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getAllSeleccionDetallesUseCase,
    this._createSeleccionDetalleUseCase,
    this._deleteSeleccionDetalleUseCase,
    /* this._updateSeleccionUseCase */
  );

  String dni;

  void changePlaca(String value) {
    dni = value;
    update(['placa']);
  }

  Future<void> addVehiculo() async {
    if (dni?.length != 8) {
      toast(type: TypeToast.ERROR, message: 'Dimension minima 8 digitos.');
      return;
    }

    await setCodeBar(dni.toString());
    dni = null;
    Get.back();
  }

  Future<void> getDetalles() async {
    personalSeleccionado = await _getAllSeleccionDetallesUseCase
        .execute('seleccion_detalles_${preTarea.key}');
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      /* if(Get.arguments['otras'] != null){
        otrasPreTareas= Get.arguments['otras'] as List<PreTareaEsparragoGrupoEntity>;
      } */
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoGrupoEntity;
        await getDetalles();
      }

      if (Get.arguments['index'] != null) {
        editando = true;
        indexTarea = Get.arguments['index'] as int;
      }

      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        validando = true;
        update(['validando']);
        personal = await _getPersonalsEmpresaBySubdivisionUseCase
            .execute(PreferenciasUsuario().idSede);
        validando = BOOLEAN_FALSE_VALUE;
        update(['validando']);
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
    /* personalSeleccionado.forEach((e) {
      if (e.hora == null) {
        toastError('Error',
            'Existe un personal con datos vacios. Por favor, ingreselos.');
        return false;
      }
    }); */
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

  void goEliminar(int key) {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Desea eliminar el personal?',
      onPressed: () async {
        Get.back();
        personalSeleccionado.removeWhere((e) => e.key == key);
        await _deleteSeleccionDetalleUseCase.execute(
            'seleccion_detalles_${preTarea.key}', key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
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
      int indexEncontrado = personalSeleccionado.indexWhere(
          (e) => e.codigotk.toString().trim() == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toast(
                type: TypeToast.ERROR, message: 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando = false;
        return;
      }

      int index = personal.indexWhere(
          (e) => e.nrodocumento.trim() == barcode.toString().trim());
      if (index != -1) {
        PreTareaEsparragoDetalleGrupoEntity d =
            PreTareaEsparragoDetalleGrupoEntity(
                personal: personal[index],
                codigoempresa: personal[index].codigoempresa,
                fecha: DateTime.now(),
                hora: DateTime.now(),
                imei: PreferenciasUsuario().imei ?? '',
                idestado: 1,
                codigotk: barcode.toString().trim(),
                idusuario: PreferenciasUsuario().idUsuario,
                itempretareaesparragogrupo:
                    preTarea.itempretareaesparragogrupo);
        int key = await _createSeleccionDetalleUseCase.execute(
            'seleccion_detalles_${preTarea.key}', d);
        d.key = key;
        personalSeleccionado.add(d);
        update(['personal_seleccionado']);
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
