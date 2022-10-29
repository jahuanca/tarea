import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/create_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/delete_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/get_all_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/update_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PersonalTareaProcesoEntity> personalSeleccionado = [];
  int indexTarea;
  TareaProcesoEntity tarea;
  GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  GetPersonalsEmpresaUseCase _getPersonalEmpresaUseCase;
  UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  bool validando = false;
  bool editando = false;
  final GetAllPersonalTareaProcesoUseCase _getAllPersonalTareaProcesoUseCase;
  final CreatePersonalTareaProcesoUseCase _createPersonalTareaProcesoUseCase;
  final UpdatePersonalTareaProcesoUseCase _updatePersonalTareaProcesoUseCase;
  final DeletePersonalTareaProcesoUseCase _deletePersonalTareaProcesoUseCase;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  ListadoPersonasController(
    this._getAllPersonalTareaProcesoUseCase,
    this._createPersonalTareaProcesoUseCase,
    this._updatePersonalTareaProcesoUseCase,
    this._deletePersonalTareaProcesoUseCase,
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getPersonalEmpresaUseCase,
    this._updateTareaProcesoUseCase,
  );

  Future<void> getPersonal() async {
    personalSeleccionado = await _getAllPersonalTareaProcesoUseCase
        .execute('personal_tarea_proceso_${tarea.key}');
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        tarea = Get.arguments['tarea'] as TareaProcesoEntity;
        await getPersonal();
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
        personal = await _getPersonalEmpresaUseCase.execute();
        /* personal = await _getPersonalsEmpresaBySubdivisionUseCase.execute(
            (Get.arguments['sede'] as SubdivisionEntity).idsubdivision); */
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
    var sunmiBarcodePlugin = SunmiBarcodePlugin();
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
    await setCodeBar(result);
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
    double cantidadAvance = 0;
    personalSeleccionado.forEach((e) {
      if (e.horainicio == null || e.horafin == null) {
        toastError('Error',
            'Existe un personal con datos vacios. Por favor, ingreselos.');
        return false;
      }

      if (tarea.esrendimiento) {
        cantidadAvance = cantidadAvance + (e.cantidadrendimiento ?? 0);
      }

      if (tarea.esjornal) {
        cantidadAvance = cantidadAvance + (e.cantidadavance ?? 0);
      }
    });

    Get.back(result: [personalSeleccionado.length, cantidadAvance]);
    print('retornado');
    return true;
  }

  void goNuevoPersonaTareaProceso() async {
    AgregarPersonaBinding().dependencies();
    final result = await Get.to<PersonalTareaProcesoEntity>(
        () => AgregarPersonaPage(),
        arguments: {'personal': personal, 'tarea': tarea});
    if (result != null) {
      int key = await _createPersonalTareaProcesoUseCase.execute(
          'personal_tarea_proceso_${tarea.key}', result);
      result.key = key;
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
        final result = await Get.to<List<PersonalTareaProcesoEntity>>(
            () => AgregarPersonaPage(),
            arguments: {
              'cantidad': seleccionados.length,
              'personal': personal
            });
        if (result != null) {
          for (int i = 0; i < seleccionados.length; i++) {
            int key = personalSeleccionado[seleccionados[i]].key;
            personalSeleccionado[seleccionados[i]] = result[i];
            result[i].key = key;
            await _updatePersonalTareaProcesoUseCase.execute(
                'personal_tarea_proceso_${tarea.key}', key, result[i]);
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
    int position =
        personalSeleccionado.indexWhere((element) => element.key == key);
    switch (index) {
      case 1:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<PersonalTareaProcesoEntity>(
            () => AgregarPersonaPage(),
            arguments: {
              'tarea': tarea,
              'personal_tarea_proceso': personalSeleccionado[position],
              'personal': personal
            });
        if (result != null) {
          int key = personalSeleccionado[position].key;
          personalSeleccionado[position] = result;
          result.key = key;
          await _updatePersonalTareaProcesoUseCase.execute(
              'personal_tarea_proceso_${tarea.key}', key, result);
          update(['personal_seleccionado']);
        }
        break;
      case 2:
        goEliminar(position);

        break;
      default:
        break;
    }
  }

  void goEliminar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta eliminar el personal?',
      'Si',
      'No',
      () async {
        Get.back();
        await _deletePersonalTareaProcesoUseCase.execute(
            'personal_tarea_proceso_${tarea.key}',
            personalSeleccionado[index].key);
        personalSeleccionado.removeAt(index);
        update(['personal_seleccionado']);
      },
      () => Get.back(),
    );
  }

  Future<void> goLectorCode() async {
    if (tarea?.estadoLocal == 'P') {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancelar", false, ScanMode.DEFAULT)
          .listen((barcode) async {
        
        await setCodeBar(barcode);
      });
    }
  }

  bool buscando = false;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando == false) {
      buscando = true;
      int indexEncontrado = personalSeleccionado
          .indexWhere((e) => e.personal.nrodocumento == barcode.toString());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        update(['personal_seleccionado']);
        buscando = false;
        return;
      }
      int index =
          personal.indexWhere((e) => e.nrodocumento == barcode.toString());
      if (index != -1) {
        PersonalTareaProcesoEntity p = PersonalTareaProcesoEntity(
          idusuario: PreferenciasUsuario().idUsuario,
          personal: personal[index],
          horainicio: tarea.horainicio,
          horafin: tarea.horafin,
          pausainicio: tarea.pausainicio,
          turno: tarea.turnotareo,
          pausafin: tarea.pausafin,
          codigoempresa: personal[index].codigoempresa,
          esjornal: tarea.esjornal,
          esrendimiento: tarea.esrendimiento,
          diasiguiente: tarea.diasiguiente,
        );
        int key = await _createPersonalTareaProcesoUseCase.execute(
            'personal_tarea_proceso_${tarea.key}', p);
        p.key = key;
        personalSeleccionado.add(p);
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
