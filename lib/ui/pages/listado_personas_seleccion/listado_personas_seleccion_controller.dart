import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/update_seleccion_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';

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
  final UpdateSeleccionUseCase _updateSeleccionUseCase;
  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasSeleccionController(
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._updateSeleccionUseCase);

  @override
  void onInit() async {
    List<CodeFormat> codeFormats = [];
    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
    Map<String, dynamic> properties = {
      ...CodeFormatUtils.getAsPropertiesComplement(
          codeFormats), //CodeFormatUtils.getAsPropertiesComplement(...) this function converts a list of CodeFormat enums to its corresponding properties representation.
      'DEC_CODABAR_START_STOP_TRANSMIT':
          true, //This is the Codabar start/stop digit specific property
      'DEC_EAN13_CHECK_DIGIT_TRANSMIT':
          true, //This is the EAN13 check digit specific property
    };

    honeywellScanner = HoneywellScanner();
    honeywellScanner.setScannerCallBack(this);
    honeywellScanner.setProperties(properties);
    super.onInit();
    if (Get.arguments != null) {
      /* if(Get.arguments['otras'] != null){
        otrasPreTareas= Get.arguments['otras'] as List<PreTareaEsparragoGrupoEntity>;
      } */
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoGrupoEntity;
        personalSeleccionado = preTarea.detalles;
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
        /* personal = await _getPersonalsEmpresaBySubdivisionUseCase.execute(
            (Get.arguments['sede'] as SubdivisionEntity).idsubdivision); */
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
    honeywellScanner.startScanner();
  }

  @override
  void onClose() {
    honeywellScanner.stopScanner();
    super.onClose();
  }

  @override
  void onDecoded(String result) {
    setCodeBar(result, true);
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
    final isSuccess = true;

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
    Get.back(result: personalSeleccionado);
    return true;
  }

  /* void goNuevoPersonaTareaProceso() async {
    AgregarPersonaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoDetalleEntity>(
        () => AgregarPersonaPage(),
        arguments: {'personal': personal, 'tarea': preTarea});
    if (result != null) {
      personalSeleccionado.add(result);
      update(['personal_seleccionado']);
      seleccionados.clear();
      update(['listado']);
    }
  } */

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
      /* case 3:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<List<PreTareoProcesoDetalleEntity>>(
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
        break; */
      default:
    }
  }

  Future<void> changeOptions(dynamic index, int position) async {
    switch (index) {
      /* case 1:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<PreTareoProcesoDetalleEntity>(
            () => AgregarPersonaPage(),
            arguments: {
              'tarea': preTarea,
              'cantidad': seleccionados.length,
              'personal': personal
            });
        if (result != null) {
          personalSeleccionado[position] = result;
          update(['personal_seleccionado']);
        }
        break; */
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
        personalSeleccionado.removeAt(index);
        await _updateSeleccionUseCase.execute(preTarea, preTarea.key);
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

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != -1) {

      /* for (var element in otrasPreTareas) {
        int indexOtra= element.detalles.indexWhere((e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if(indexOtra != -1){
          byLector
            ? toastError('Error', 'Se encuentra en otra tarea')
            : _showNotification(false, 'Se encuentra en otra tarea');
          return;
        }
      } */

      int indexEncontrado = personalSeleccionado
          .indexWhere((e) => e.codigotk == barcode.toString());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : _showNotification(false, 'Ya se encuentra registrado');
        return;
      }
      print(barcode);
      List<String> valores = barcode.toString().split('_');
      int index = personal.indexWhere((e) => e.codigoempresa == barcode.toString());
      if (index != -1) {
        byLector
            ? toastExito('Éxito', 'Registrado con exito')
            : _showNotification(true, 'Registrado con exito');
        /* int lasItem = (personalSeleccionado.isEmpty)
            ? 0
            : personalSeleccionado.last.numcaja; */
        personalSeleccionado.add(PreTareaEsparragoDetalleGrupoEntity(
            personal: personal[index],
            codigoempresa: personal[index].codigoempresa,
            fecha: DateTime.now(),
            hora: DateTime.now(),
            imei: '1256',
            idestado: 1,
            codigotk: barcode.toString(),
            idusuario: PreferenciasUsuario().idUsuario,
            itempretareaesparragogrupo: preTarea.itempretareaesparragosgrupo));
        update(['personal_seleccionado']);
        preTarea.detalles=personalSeleccionado;
        await _updateSeleccionUseCase.execute(preTarea, indexTarea);
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : _showNotification(false, 'No se encuentra en la lista');
      }
    }
  }
}
