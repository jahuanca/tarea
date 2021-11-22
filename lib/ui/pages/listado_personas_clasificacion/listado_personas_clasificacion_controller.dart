import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/update_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';

class ListadoPersonasClasificacionController extends GetxController
    {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PreTareaEsparragoDetalleEntity> personalSeleccionado = [];
  int indexTarea;
  int indexFormato;
  PreTareaEsparragoEntity preTarea;
  List<PreTareaEsparragoDetalleEntity> detalles;
  List<PreTareaEsparragoFormatoEntity> otrasCajas = [];

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];

  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final UpdateClasificacionUseCase _updateClasificacionUseCase;
  final GetActividadsUseCase _getActividadsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  bool validando = false;
  bool editando = false;
  /* HoneywellScanner honeywellScannerClasificacion; */

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasClasificacionController(
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getActividadsUseCase,
      this._getLaborsUseCase,
      this._updateClasificacionUseCase);

  @override
  void onInit() async {
    super.onInit();
    actividades = await _getActividadsUseCase.execute();
    labores = await _getLaborsUseCase.execute();
    List<CodeFormat> codeFormats = [];
    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
    Map<String, dynamic> properties = {
      ...CodeFormatUtils.getAsPropertiesComplement(
          codeFormats),
      'DEC_CODABAR_START_STOP_TRANSMIT':
          true,
      'DEC_EAN13_CHECK_DIGIT_TRANSMIT':
          true,
    };

    /* honeywellScannerClasificacion = HoneywellScanner();
    honeywellScannerClasificacion.setScannerCallBack(this);
    honeywellScannerClasificacion.setProperties(properties); */
    

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
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoEntity;
        personalSeleccionado = preTarea.detalles[indexFormato].detalles;
        if (personalSeleccionado == null) personalSeleccionado = [];
        update(['personal_seleccionado']);
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
  }

  @override
  void onClose() {
    super.onClose();
    /* honeywellScannerClasificacion.stopScanner(); */
  }



  /* @override
  void onDecoded(String result) {
    setCodeBar(result, true);
  }

  @override
  void onError(Exception error) {
    toastError('Error', error.toString());
  } */

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
        await _updateClasificacionUseCase.execute(preTarea, preTarea.key);
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
      /* for (var element in otrasCajas) {
        if(element.detalles==null) continue;
        int indexOtra = element.detalles.indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != -1) {
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

      List<String> valores = barcode.toString().split('_');
      int index = personal.indexWhere((e) => e.codigoempresa == valores[0]);
      if (index != -1) {
        byLector
            ? toastExito('Éxito', 'Registrado con exito')
            : _showNotification(true, 'Registrado con exito');
        /* int lasItem = (personalSeleccionado.isEmpty)
            ? 0
            : personalSeleccionado.last.numcaja; */
        //TODO: VERIFICAR ESTRUCTURA QR:
        //TODO:codigosap_idcliente_idlabor_linea_correlativo
        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.parse(valores[2]));

        personalSeleccionado.add(PreTareaEsparragoDetalleEntity(
          personal: personal[index],
          codigoempresa: personal[index].codigoempresa,
          fecha: DateTime.now(),
          hora: DateTime.now(),
          imei: '1256',
          idestado: 1,
          idlabor: labores[indexLabor].idlabor,
          idactividad: labores[indexLabor].idactividad,
          labor: labores[indexLabor],
          linea: int.parse(valores[3]),
          correlativo: int.parse(valores[4]),
          codigotk: barcode.toString(),
          idusuario: PreferenciasUsuario().idUsuario,
        ));
        update(['personal_seleccionado']);
        if (preTarea.detalles == null) {
          preTarea.detalles = [];
        }
        if (preTarea.detalles[indexFormato].detalles == null) {
          preTarea.detalles[indexFormato].detalles = [];
        }
        preTarea.detalles[indexFormato].detalles = personalSeleccionado;
        await _updateClasificacionUseCase.execute(preTarea, preTarea.key);
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : _showNotification(false, 'No se encuentra en la lista');
      }
    }
  }
}
