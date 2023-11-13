import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/listado_personas_clasificacion_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/create_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/delete_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/get_all_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/update_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_controller.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:uuid/uuid.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoCajasController extends GetxController implements ScannerCallBack {
  Uuid key = new Uuid();
  List<int> seleccionados = [];
  List<ClienteEntity> clientes = [];
  List<PreTareaEsparragoFormatoEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareaEsparragoEntity preTarea;
  List<PreTareaEsparragoEntity> otrasPreTareas = [];

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];

  final GetClientesUseCase _getClientesUseCase;
  final GetActividadsUseCase _getActividadsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;

  final GetAllClasificadoCajasUseCase _getAllClasificadoCajasUseCase;
  final CreateClasificadoCajaUseCase _createClasificadoCajaUseCase;
  final UpdateClasificadoCajaUseCase _updateClasificadoCajaUseCase;
  final DeleteClasificadoCajaUseCase _deleteClasificadoCajaUseCase;

  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  int qrCaja = -1;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoCajasController(
    this._getClientesUseCase,
    this._getActividadsUseCase,
    this._getLaborsUseCase,
    this._createClasificadoCajaUseCase,
    this._updateClasificadoCajaUseCase,
    this._deleteClasificadoCajaUseCase,
    this._getAllClasificadoCajasUseCase,
  );

  Future<void> getCajas() async {
    personalSeleccionado = await _getAllClasificadoCajasUseCase
        .execute('clasificado_caja_${preTarea.key}');
    update(['personal_seleccionado']);
  }

  @override
  void onInit() async {
    super.onInit();
    actividades = await _getActividadsUseCase.execute();
    clientes = await _getClientesUseCase.execute();
    labores = await _getLaborsUseCase.execute();

    if (Get.arguments != null) {
      if (Get.arguments['otras'] != null) {
        otrasPreTareas =
            Get.arguments['otras'] as List<PreTareaEsparragoEntity>;
      }
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoEntity;
        await getCajas();
      }

      if (Get.arguments['index'] != null) {
        editando = true;
        indexTarea = Get.arguments['index'] as int;
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
    if (qrCaja != -1) {
      await Get.find<ListadoPersonasClasificacionController>()
          .setCodeBar(result, true);
    } else {
      await setCodeBar(result, true);
    }
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

  Future<void> goListadoDetalles(int index) async {
    print(index);
    List<PreTareaEsparragoFormatoEntity> otras = [];
    qrCaja = index;
    otras.addAll(personalSeleccionado.toList());
    otras.removeAt(index);
    ListadoPersonasClasificacionBinding().dependencies();
    final resultado =
        await Get.to<int>(() => ListadoPersonasClasificacionPage(), arguments: {
      'otras': otras,
      'tarea': personalSeleccionado[index],
      'index': indexTarea,
      'key_caja': personalSeleccionado[index].key,
      'index_formato': index,
    });

    qrCaja = -1;
    Get.find<ListadoPersonasClasificacionController>().refresh();
    if (resultado != null) {
      Get.delete<ListadoPersonasClasificacionController>();
      personalSeleccionado[index].sizeDetails = resultado;
      await _updateClasificadoCajaUseCase.execute(
          'clasificado_caja_${preTarea.key}',
          personalSeleccionado[index].key,
          personalSeleccionado[index]);
      update(['item_$index']);
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
      context: Get.overlayContext,
      message: '¿Esta eliminar la caja?',
      onPressed: () async {
        Get.back();
        personalSeleccionado.removeWhere((e) => e.key == key);
        await _deleteClasificadoCajaUseCase.execute(
            'clasificado_caja_${preTarea.key}', key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancelar", false, ScanMode.DEFAULT)
        .listen((barcode) async {
      await setCodeBar(barcode.toString().trim());
    });
  }

  bool buscando = false;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando == false) {
      buscando = true;
      for (var element in otrasPreTareas) {
        List<PreTareaEsparragoFormatoEntity> detalles =
            await _getAllClasificadoCajasUseCase
                .execute('clasificado_caja_${element.key}');
        int indexOtra = detalles.indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != -1) {
          byLector
              ? toast(
                  type: TypeToast.ERROR, message: 'Se encuentra en otra tarea')
              : await _showNotification(
                  BOOLEAN_FALSE_VALUE, 'Se encuentra en otra tarea');
          buscando = false;
          return;
        }
      }

      int indexEncontrado = personalSeleccionado.indexWhere(
          (e) => e.codigotk.toString().trim() == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toast(
                type: TypeToast.ERROR, message: 'Ya se encuentra registrado')
            : await _showNotification(
                BOOLEAN_FALSE_VALUE, 'Ya se encuentra registrado');
        buscando = BOOLEAN_FALSE_VALUE;
        update(['personal_seleccionado']);
        return;
      }

      List<String> valores = barcode.toString().split('_');
      int index =
          clientes.indexWhere((e) => e.idcliente == int.parse(valores[0]));
      if (index != -1) {
        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.parse(valores[1]));
        PreTareaEsparragoFormatoEntity p = PreTareaEsparragoFormatoEntity(
          cliente: clientes[index],
          idcliente: clientes[index].idcliente,
          fecha: DateTime.now(),
          hora: DateTime.now(),
          imei: PreferenciasUsuario().imei ?? '',
          idestado: 1,
          linea: 1,
          idlabor: labores[indexLabor].idlabor,
          idactividad: labores[indexLabor].idactividad,
          labor: labores[indexLabor],
          correlativo: int.parse(valores[2]),
          codigotk: barcode.toString().trim(),
          idusuario: PreferenciasUsuario().idUsuario,
        );

        int key = await _createClasificadoCajaUseCase.execute(
            'clasificado_caja_${preTarea.key}', p);
        p.key = key;
        personalSeleccionado.insert(0, p);
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
            : await _showNotification(
                BOOLEAN_FALSE_VALUE, 'No se encuentra en la lista');
        buscando = false;
        return;
      }
    }
  }
}
