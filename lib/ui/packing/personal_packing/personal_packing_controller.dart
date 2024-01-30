import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/create_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/delete_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/get_all_uva_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class PersonalPackingController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<LaborEntity> labores = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PreTareoProcesoUvaDetalleEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareoProcesoUvaEntity preTarea;
  List<PreTareoProcesoUvaEntity> otrasPreTareas = [];
  final GetLaborsUseCase _getLaborsUseCase;
  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final CreateUvaDetalleUseCase _createUvaDetalleUseCase;
  final DeleteUvaDetalleUseCase _deleteUvaDetalleUseCase;
  final GetAllUvaDetallesUseCase _getAllUvaDetallesUseCase;
  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  PersonalPackingController(
    this._getLaborsUseCase,
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._createUvaDetalleUseCase,
    this._deleteUvaDetalleUseCase,
    this._getAllUvaDetallesUseCase,
  );

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['otras'] != null) {
        otrasPreTareas =
            Get.arguments['otras'] as List<PreTareoProcesoUvaEntity>;
      }

      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareoProcesoUvaEntity;
        personalSeleccionado = [];
        update(['personal_seleccionado']);
      }

      if (Get.arguments['index'] != null) {
        editando = true;
        indexTarea = Get.arguments['index'] as int;
      }

      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        personal = await _getPersonalsEmpresaBySubdivisionUseCase
            .execute(PreferenciasUsuario().idSede);

        validando = BOOLEAN_FALSE_VALUE;
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
    await getLabores();
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
    } on PlatformException {}
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
  void onReady() async {
    super.onReady();
    personalSeleccionado =
        await _getAllUvaDetallesUseCase.execute('uva_detalle_${preTarea.key}');
    for (var i = 0; i < otrasPreTareas.length; i++) {
      if (otrasPreTareas[i].detalles == null) otrasPreTareas[i].detalles = [];
      otrasPreTareas[i].detalles = await _getAllUvaDetallesUseCase
          .execute('uva_detalle_${otrasPreTareas[i].key}');
    }
    update(['personal_seleccionado']);
  }

  Future<void> getLabores() async {
    labores = await _getLaborsUseCase.execute();
    update(['labores']);
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
    if (i == ELEMENT_NOT_FOUND) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<bool> onWillPop() async {
    personalSeleccionado.forEach((e) {
      if (e.hora == null) {
        toast(
            type: TypeToast.ERROR,
            message:
                'Existe un personal con datos vacios. Por favor, ingreselos.');
        return BOOLEAN_FALSE_VALUE;
      }
    });
    Get.back(result: personalSeleccionado.length);
    return BOOLEAN_TRUE_VALUE;
  }

  void goNuevoPersonaTareaProceso() async {
    AgregarPersonaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoUvaDetalleEntity>(
        () => AgregarPersonaPage(),
        arguments: {'personal': personal, 'tarea': preTarea});
    if (result != null) {
      personalSeleccionado.add(result);
      update(['personal_seleccionado']);
      seleccionados.clear();
      update(['listado']);
    }
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
      case 3:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<List<PreTareoProcesoUvaDetalleEntity>>(
            () => AgregarPersonaPage(),
            arguments: {
              'cantidad': seleccionados.length,
              'personal': personal
            });
        if (result != null) {
          for (int i = 0; i < seleccionados.length; i++) {
            personalSeleccionado[seleccionados[i]] = result[i];
          }
          update(['personal_seleccionado']);
          seleccionados.clear();
          update(['seleccionados']);
        }
        break;
      default:
    }
  }

  Future<void> changeOptions(dynamic index, int key) async {
    switch (index) {
      case 1:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<PreTareoProcesoUvaDetalleEntity>(
            () => AgregarPersonaPage(),
            arguments: {
              'tarea': preTarea,
              'cantidad': seleccionados.length,
              'personal': personal
            });
        if (result != null) {
          int index = personalSeleccionado.indexWhere((e) => e.key == key);
          if (index != ELEMENT_NOT_FOUND) personalSeleccionado[index] = result;
          update(['personal_seleccionado']);
        }
        break;
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
      message: '¿Esta eliminar el personal?',
      onPressed: () async {
        Get.back();

        personalSeleccionado?.removeWhere((e) => e.key == key);
        await _deleteUvaDetalleUseCase.execute(
            'uva_detalle_${preTarea.key}', key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", CANCEL_STRING, BOOLEAN_FALSE_VALUE, ScanMode.QR)
        .listen((barcode) async {
      await setCodeBar(barcode);
    });
  }

  bool buscando = BOOLEAN_FALSE_VALUE;

  Future<void> setCodeBar(dynamic barcode,
      [bool byLector = BOOLEAN_FALSE_VALUE]) async {
    if (barcode != null && barcode != '-1' && buscando == BOOLEAN_FALSE_VALUE) {
      buscando = BOOLEAN_TRUE_VALUE;
      for (var element in otrasPreTareas) {
        int indexOtra = element.detalles.indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != ELEMENT_NOT_FOUND) {
          byLector
              ? toast(
                  type: TypeToast.ERROR, message: 'Se encuentra en otra tarea')
              : _showNotification(
                  BOOLEAN_FALSE_VALUE, 'Se encuentra en otra tarea');
          buscando = BOOLEAN_FALSE_VALUE;
          return;
        }
      }

      int indexEncontrado = personalSeleccionado
          .indexWhere((e) => e.codigotk.trim() == barcode.toString().trim());
      if (indexEncontrado != ELEMENT_NOT_FOUND) {
        byLector
            ? toast(
                type: TypeToast.ERROR, message: 'Ya se encuentra registrado')
            : await _showNotification(
                BOOLEAN_FALSE_VALUE, 'Ya se encuentra registrado');
        buscando = BOOLEAN_FALSE_VALUE;
        return;
      }
      List<String> valores = barcode.toString().split('_');
      int index = personal.indexWhere((e) => e.codigoempresa == valores[0]);
      if (index != ELEMENT_NOT_FOUND) {
        LaborEntity labor =
            labores?.firstWhere((e) => e.idlabor == int.parse(valores[1]));

        int lasItem = (personalSeleccionado.isEmpty)
            ? 0
            : personalSeleccionado.last.numcaja;
        PreTareoProcesoUvaDetalleEntity d = PreTareoProcesoUvaDetalleEntity(
            idlabor: labor.idlabor,
            personal: personal[index],
            labor: labor,
            actividad: labor.actividad,
            idactividad: labor.idactividad,
            numcaja: lasItem + 1,
            codigoempresa: valores[0],
            fecha: DateTime.now(),
            hora: DateTime.now(),
            imei: PreferenciasUsuario().imei ?? '',
            idestado: 1,
            codigotk: barcode.toString().trim(),
            idusuario: PreferenciasUsuario().idUsuario,
            itempretareaprocesouva: preTarea.itempretareaprocesouva);
        int key = await _createUvaDetalleUseCase.execute(
            'uva_detalle_${preTarea.key}', d);
        d.key = key;
        personalSeleccionado.add(d);
        update(['personal_seleccionado']);
        byLector
            ? toast(type: TypeToast.SUCCESS, message: 'Registrado con exito')
            : await _showNotification(
                BOOLEAN_TRUE_VALUE, 'Registrado con exito');
        buscando = BOOLEAN_FALSE_VALUE;
        return;
      } else {
        byLector
            ? toast(
                type: TypeToast.ERROR, message: 'No se encuentra en la lista')
            : await _showNotification(
                BOOLEAN_FALSE_VALUE, 'No se encuentra en la lista');
        buscando = BOOLEAN_FALSE_VALUE;
        return;
      }
    }
  }
}
