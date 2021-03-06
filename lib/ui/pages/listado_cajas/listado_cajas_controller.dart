import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/di/listado_personas_clasificacion_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/update_clasificacion_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_controller.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
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
  final UpdateClasificacionUseCase _updateClasificacionUseCase;
  final GetActividadsUseCase _getActividadsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  bool validando = false;
  bool editando = false;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  int qrCaja = -1;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoCajasController(this._getClientesUseCase, this._getActividadsUseCase,
      this._getLaborsUseCase, this._updateClasificacionUseCase);

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
        personalSeleccionado = preTarea.detalles;
        print(personalSeleccionado.length);
        update(['personal_seleccionado']);
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
      sunmiBarcodePlugin.onBarcodeScanned().listen((event) async{
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
  void onClose() async{
    if(await honeywellScanner?.isSupported() ?? false){
      honeywellScanner.stopScanner();
    }
    super.onClose();
    
  }

  @override
  void onDecoded(String result) async{
    if (qrCaja != -1) {
      await Get.find<ListadoPersonasClasificacionController>()
          .setCodeBar(result, true);
    } else {
      await setCodeBar(result, true);
    }
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
    Get.back(result: personalSeleccionado);
    return true;
  }

  Future<void> goListadoDetalles(int index) async {
    print(index);
    List<PreTareaEsparragoFormatoEntity> otras = [];
    qrCaja = index;
    otras.addAll(preTarea.detalles);
    otras.removeAt(index);
    //honeywellScanner.pauseScanner();
    ListadoPersonasClasificacionBinding().dependencies();
    final resultados = await Get.to<List<PreTareaEsparragoDetalleEntity>>(
        () => ListadoPersonasClasificacionPage(),
        arguments: {
          'otras': otras,
          //'tarea': clasificados[index],
          'tarea': preTarea,
          'index': indexTarea,
          'index_formato': index,
        });

    //honeywellScanner.resumeScanner();
    qrCaja = -1;
    Get.find<ListadoPersonasClasificacionController>().refresh();
    if (resultados != null && resultados.isNotEmpty) {
      Get.delete<ListadoPersonasClasificacionController>();
      preTarea.detalles[index].detalles = resultados;
      await _updateClasificacionUseCase.execute(preTarea, preTarea.key);
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

  Future<void> changeOptions(dynamic index, String key) async {
    switch (index) {
      case 2:
        goEliminar(key);

        break;
      default:
        break;
    }
  }

  void goEliminar(String key) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '??Esta eliminar la caja?',
      'Si',
      'No',
      () async {
        Get.back();
        personalSeleccionado.removeWhere((e) => e.key == key);
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
      await setCodeBar(barcode.toString().trim());
    });
  }

  bool buscando=false;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando==false) {
      buscando=true;
      for (var element in otrasPreTareas) {
        int indexOtra = element.detalles.indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != -1) {
          byLector
              ? toastError('Error', 'Se encuentra en otra tarea')
              : await _showNotification(false, 'Se encuentra en otra tarea');
          buscando=false;
          return;
        }
      }

      int indexEncontrado = personalSeleccionado.indexWhere(
          (e) => e.codigotk.toString().trim() == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando=false;
        update(['personal_seleccionado']);
        return;
      }

      List<String> valores = barcode.toString().split('_');
      int index =
          clientes.indexWhere((e) => e.idcliente == int.parse(valores[0]));
      if (index != -1) {

        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.parse(valores[1]));

        personalSeleccionado.insert(
            0,
            PreTareaEsparragoFormatoEntity(
              cliente: clientes[index],
              idcliente: clientes[index].idcliente,
              fecha: DateTime.now(),
              hora: DateTime.now(),
              imei: PreferenciasUsuario().imei ?? '',
              key: key.v4(),
              idestado: 1,
              linea: 1,
              idlabor: labores[indexLabor].idlabor,
              idactividad: labores[indexLabor].idactividad,
              labor: labores[indexLabor],
              correlativo: int.parse(valores[2]),
              codigotk: barcode.toString().toString(),
              idusuario: PreferenciasUsuario().idUsuario,
            ));
        update(['personal_seleccionado']);
        preTarea.detalles = personalSeleccionado;
        await _updateClasificacionUseCase.execute(preTarea, preTarea.key);
        byLector
            ? toastExito('??xito', 'Registrado con exito')
            : await _showNotification(true, 'Registrado con exito');
        buscando=false;        
        return;
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : await _showNotification(false, 'No se encuentra en la lista');
        buscando=false;
        return;
      }
    }
  }
}
