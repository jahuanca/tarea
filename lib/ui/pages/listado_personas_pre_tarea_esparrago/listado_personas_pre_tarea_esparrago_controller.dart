import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/delete_peersonal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/update_personal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/create_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/get_all_personal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasPreTareaEsparragoController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<EsparragoAgrupaPersonalEntity> grupos = [];
  List<ClienteEntity> clientes = [];
  List<PersonalPreTareaEsparragoEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareaEsparragoVariosEntity preTarea;
  List<PreTareaEsparragoVariosEntity> otrasPreTareas = [];

  List<CalibreEntity> calibres = [];
  List<ViaEnvioEntity> viasEnvio = [];
  List<LaborEntity> labores = [];

  final GetCalibresUseCase _getCalibresUseCase;

  final GetViaEnviosUseCase _getViaEnviosUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  final GetClientesUseCase _getClientesUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;

  final GetAllPersonalPreTareaEsparragoUseCase
      _getAllPersonalPreTareaEsparragoUseCase;
  final CreatePersonalPreTareaEsparragoUseCase
      _createPersonalPreTareaEsparragoUseCase;
  final UpdatePersonalPreTareaEsparragoUseCase
      _updatePersonalPreTareaEsparragoUseCase;
  final DeletePersonalPreTareaEsparragoUseCase
      _deletePersonalPreTareaEsparragoUseCase;
  bool validando = false;
  bool editando = false;
  int sizeDetailsCaja = 0;
  int sizeDetailsPersona = 0;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasPreTareaEsparragoController(
    this._updatePesadoUseCase,
    this._getCalibresUseCase,
    this._getViaEnviosUseCase,
    this._getLaborsUseCase,
    this._getClientesUseCase,
    this._getAllPersonalPreTareaEsparragoUseCase,
    this._createPersonalPreTareaEsparragoUseCase,
    this._updatePersonalPreTareaEsparragoUseCase,
    this._deletePersonalPreTareaEsparragoUseCase,
  );

  @override
  void onInit() async {
    validando = true;
    update(['validando']);
    calibres = await _getCalibresUseCase.execute();
    viasEnvio = await _getViaEnviosUseCase.execute();
    labores = await _getLaborsUseCase.execute();
    clientes = await _getClientesUseCase.execute();

    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['otras'] != null) {
        otrasPreTareas =
            Get.arguments['otras'] as List<PreTareaEsparragoVariosEntity>;
      }
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoVariosEntity;
        personalSeleccionado = await _getAllPersonalPreTareaEsparragoUseCase
            .execute('personal_pre_tarea_esparrago_${preTarea.key}');

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
    sunmiBarcodePlugin = SunmiBarcodePlugin();
    if (await sunmiBarcodePlugin.isScannerAvailable()) {
      initPlatformState();
      print('es valido');
      sunmiBarcodePlugin.onBarcodeScanned().listen((event) async {
        if (preTarea?.estadoLocal != 'A') {
          await setCodeBar(event, true);
        }
      });
    } else {
      initHoneyScanner();
    }
    validando = false;
    update(['validando']);
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
    if (preTarea?.estadoLocal != 'A') {
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
    if (esperandoCierre) {
      toast(type: TypeToast.ERROR, message: 'Termine o cierre la etiqueta.');
      return;
    }
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<bool> onWillPop() async {
    Get.back(
      result: esperandoCierre
          ? personalSeleccionado.length - 1
          : personalSeleccionado.length,
    );
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
        int index = personalSeleccionado.indexWhere((e) => e.key == key);
        if (index != -1) goEliminar(index);

        break;
      default:
        break;
    }
  }

  void goEliminar(int index) {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de eliminar el registro?',
      onPressed: () async {
        Get.back();
        PersonalPreTareaEsparragoEntity item =
            personalSeleccionado.removeAt(index);

        preTarea.sizeDetails = esperandoCierre
            ? personalSeleccionado.length - 1
            : personalSeleccionado.length;
        await _updatePesadoUseCase.execute(preTarea, preTarea.key);

        await _deletePersonalPreTareaEsparragoUseCase.execute(
            'personal_pre_tarea_esparrago_${preTarea.key}', item.key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> goLectorCode() async {
    if (preTarea?.estadoLocal != 'A') {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", false, ScanMode.BARCODE);
      await setCodeBar(barcode);
    }
  }

  bool buscando = false;
  bool esperandoCierre = false;

  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1') {
      List<String> codigos = barcode.toString().trim().split('_');
      if (barcode.toString().trim().toUpperCase()[0] == 'A') {
        print('Es apertura');

        if (codigos.length < 6) {
          toast(
              type: TypeToast.ERROR,
              message: 'Etiqueta de apertura, con datos incompletos.');
          return;
        }

        /*int index=personalSeleccionado.indexWhere((e) => e.codigotkcaja == barcode.toString().trim());

        if(index != -1){
          toast(type: TypeToast.ERROR, message: 'Esta etiqueta ya ha sido registrada.');
          return;
        }

        for (PreTareaEsparragoVariosEntity otra in otrasPreTareas) {

          List<PersonalPreTareaEsparragoEntity> otroPersonal=await _getAllPersonalPreTareaEsparragoUseCase.execute('personal_pre_tarea_esparrago_${otra.key}');

          int indexROtra=otroPersonal.indexWhere(
            (e) => '${e.codigotkcaja}'== '${barcode.toString().trim()}');

          if(indexROtra!=-1){
            toast(type: TypeToast.ERROR, message: 'Esta etiqueta ya esta en otra pretarea.');
            return;
          } 
        }*/

        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.tryParse(codigos[1]));

        if (indexLabor == -1) {
          toast(
              type: TypeToast.ERROR, message: 'No se pudo encontrar la labor');
          return;
        }

        int indexCliente =
            clientes.indexWhere((e) => e.idcliente == int.tryParse(codigos[2]));

        if (indexCliente == -1) {
          toast(
              type: TypeToast.ERROR,
              message: 'No se pudo encontrar el cliente');
          return;
        }

        int indexCalibre =
            calibres.indexWhere((e) => e.idcalibre == int.tryParse(codigos[3]));

        if (indexCalibre == -1) {
          toast(
              type: TypeToast.ERROR,
              message: 'No se pudo encontrar el calibre');
          return;
        }

        int indexViaEnvio =
            viasEnvio.indexWhere((e) => e.idvia == int.tryParse(codigos[4]));

        if (indexViaEnvio == -1) {
          toast(
              type: TypeToast.ERROR,
              message: 'No se pudo encontrar la vía de envío.');
          return;
        }

        esperandoCierre = true;
        personalSeleccionado.insert(
            0,
            new PersonalPreTareaEsparragoEntity(
              idcliente: clientes[indexCliente].idcliente,
              cliente: clientes[indexCliente],
              idlabor: labores[indexLabor].idlabor,
              labor: labores[indexLabor],
              idvia: viasEnvio[indexViaEnvio].idvia,
              viaEnvio: viasEnvio[indexViaEnvio],
              correlativocaja: int.tryParse(codigos[5]),
              codigotkcaja: barcode.toString().trim(),
              idcalibre: calibres[indexCalibre].idcalibre,
              calibre: calibres[indexCalibre],
              esperandoCierre: esperandoCierre,
              idSQLitePreTareaEsparrago: preTarea.idSQLite,
            ));
      }
      if (barcode.toString().trim().toUpperCase()[0] == 'C') {
        if (!esperandoCierre) {
          toast(
              type: TypeToast.ERROR,
              message: 'Se esta esperando una etiqueta de apertura.');
          return;
        }

        if (codigos.length < 4) {
          toast(
              type: TypeToast.ERROR,
              message: 'Etiqueta de cierre, con datos incompletos.');
          return;
        }

        print('Es cierre');

        int index =
            personalSeleccionado.indexWhere((e) => e.esperandoCierre == true);

        if (index == -1) {
          toast(
              type: TypeToast.ERROR,
              message: 'No existe etiqueta que espera ser cerrada.');
          return;
        }

        int indexR = personalSeleccionado.indexWhere(
            (e) => '${e.codigotkmesa}' == '${barcode.toString().trim()}');

        if (indexR != -1) {
          toast(
              type: TypeToast.ERROR,
              message: 'Esta etiqueta de cierre ya ha sido registrada.');
          return;
        }

        for (PreTareaEsparragoVariosEntity otra in otrasPreTareas) {
          List<PersonalPreTareaEsparragoEntity> otroPersonal =
              await _getAllPersonalPreTareaEsparragoUseCase
                  .execute('personal_pre_tarea_esparrago_${otra.key}');

          int indexROtra = otroPersonal.indexWhere(
              (e) => '${e.codigotkmesa}' == '${barcode.toString().trim()}');

          if (indexROtra != -1) {
            toast(
                type: TypeToast.ERROR,
                message: 'Esta etiqueta ya esta en otra pretarea.');
            return;
          }
        }

        if (index != -1) {
          personalSeleccionado[index].codigotkmesa = barcode.toString().trim();
          personalSeleccionado[index].esperandoCierre = false;
          personalSeleccionado[index].mesa = codigos[1];
          personalSeleccionado[index].linea = codigos[2];
          personalSeleccionado[index].correlativomesa =
              int.tryParse(codigos[3]) ?? 0;

          personalSeleccionado[index].idusuario =
              PreferenciasUsuario().idUsuario;
          personalSeleccionado[index].fecha = new DateTime.now();
          personalSeleccionado[index].hora = new DateTime.now();

          int key = await _createPersonalPreTareaEsparragoUseCase.execute(
              'personal_pre_tarea_esparrago_${preTarea.key}',
              personalSeleccionado[index]);
          personalSeleccionado[index].key = key;
          await _updatePersonalPreTareaEsparragoUseCase.execute(
              'personal_pre_tarea_esparrago_${preTarea.key}',
              key,
              personalSeleccionado[index]);
          preTarea.sizeDetails = personalSeleccionado.length;
          await _updatePesadoUseCase.execute(preTarea, preTarea.key);
          esperandoCierre = false;
        }
      }
      update(['seleccionados', 'personal_seleccionado']);
    }
  }

  Future<void> goCancelarEsperando(int index) async {
    bool resultado = await basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de cancelar este registro?',
      onPressed: () async => Get.back(result: true),
      onCancel: () async => Get.back(result: false),
    );
    if (resultado != null && resultado) {
      esperandoCierre = false;
      personalSeleccionado.removeAt(index);
      update(['seleccionados', 'personal_seleccionado']);
    }
  }
}
