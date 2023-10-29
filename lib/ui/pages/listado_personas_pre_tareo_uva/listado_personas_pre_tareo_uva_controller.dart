import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/tarea.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/create_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/delete_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/get_all_uva_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/update_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasPreTareoUvaController extends GetxController
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
  final UpdateUvaDetalleUseCase _updateUvaDetalleUseCase;
  final DeleteUvaDetalleUseCase _deleteUvaDetalleUseCase;
  final GetAllUvaDetallesUseCase _getAllUvaDetallesUseCase;
  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasPreTareoUvaController(
    this._getLaborsUseCase,
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._createUvaDetalleUseCase,
    this._updateUvaDetalleUseCase,
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
        print(preTarea.key);
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
    sunmiBarcodePlugin = SunmiBarcodePlugin();
    await getLabores();
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
    //setValues();
  }

  Future<void> setValues() async {
    Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();

    var tareas1 =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>('detalles');
    await tareas1.deleteFromDisk();
    PreTareoProcesoUvaEntity data =
        new PreTareoProcesoUvaEntity.fromJson(TAREAJSON);
    for (var i = 0; i < data.detalles.length; i++) {
      var d = data.detalles[i];
      if (preTarea.detalles == null) {
        preTarea.detalles = [];
      }
      preTarea.detalles.add(d);
      /* await _updatePreTareoProcesoUvaUseCase.execute(preTarea, preTarea.key); */

      var tareas =
          await Hive.openBox<PreTareoProcesoUvaDetalleEntity>('detalles');
      int key = await tareas.add(d);
      d.itempretareoprocesouvadetalle = key;
      await tareas.put(key, d);
      await tareas.close();

      /* d.itempretareoprocesouvadetalle=key;
      await tareas.put(key, d); */
      if (i % 100 == 0) {
        update(['seleccionados', 'personal_seleccionado']);
        print(i);
        print('Demora ' + (stopwatch.elapsedMilliseconds / 1000).toString());
      }
    }
    stopwatch.stop();
    print('Demora ' + (stopwatch.elapsedMilliseconds / 1000).toString());
//    await tareas.close();
    return;
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
    personalSeleccionado.forEach((e) {
      if (e.hora == null) {
        toastError('Error',
            'Existe un personal con datos vacios. Por favor, ingreselos.');
        return false;
      }
    });
    Get.back(result: personalSeleccionado.length);
    return true;
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
          if (index != -1) personalSeleccionado[index] = result;
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
      Get.overlayContext,
      'Alerta',
      '¿Esta eliminar el personal?',
      'Si',
      'No',
      () async {
        Get.back();

        personalSeleccionado?.removeWhere((e) => e.key == key);
        await _deleteUvaDetalleUseCase.execute(
            'uva_detalle_${preTarea.key}', key);
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
      for (var element in otrasPreTareas) {
        int indexOtra = element.detalles.indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != -1) {
          byLector
              ? toastError('Error', 'Se encuentra en otra tarea')
              : _showNotification(false, 'Se encuentra en otra tarea');
          buscando = false;
          return;
        }
      }

      int indexEncontrado = personalSeleccionado
          .indexWhere((e) => e.codigotk.trim() == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando = false;
        return;
      }
      List<String> valores = barcode.toString().split('_');
      int index = personal.indexWhere((e) => e.codigoempresa == valores[0]);
      if (index != -1) {
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
