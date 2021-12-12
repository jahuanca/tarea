import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/create_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/delete_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/get_all_pesado_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/update_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

class ListadoPersonasPesadoController extends GetxController
    implements ScannerCallBack {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<ClienteEntity> clientes = [];
  List<PreTareaEsparragoDetalleVariosEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareaEsparragoVariosEntity preTarea;
  List<PreTareaEsparragoVariosEntity> otrasPreTareas = [];

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];

  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;
  final GetActividadsUseCase _getActividadsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  final GetClientesUseCase _getClientesUseCase;

  final GetAllPesadoDetallesUseCase _getAllPesadoDetallesUseCase;
  final CreatePesadoDetalleUseCase _createPesadoDetalleUseCase;
  final UpdatePesadoDetalleUseCase _updatePesadoDetalleUseCase;
  final DeletePesadoDetalleUseCase _deletePesadoDetalleUseCase;
  bool validando = false;
  bool editando = false;
  int sizeDetailsCaja = 0;
  int sizeDetailsPersona = 0;
  HoneywellScanner honeywellScanner;
  SunmiBarcodePlugin sunmiBarcodePlugin;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasPesadoController(
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getActividadsUseCase,
    this._getLaborsUseCase,
    this._getClientesUseCase,
    this._updatePesadoUseCase,
    this._getAllPesadoDetallesUseCase,
    this._createPesadoDetalleUseCase,
    this._updatePesadoDetalleUseCase,
    this._deletePesadoDetalleUseCase,
  );

  @override
  void onInit() async {
    actividades = await _getActividadsUseCase.execute();
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
        sizeDetailsCaja = preTarea.sizeTipoCaja ?? 0;
        sizeDetailsPersona = preTarea.sizeTipoPersona ?? 0;
        personalSeleccionado = await _getAllPesadoDetallesUseCase
            .execute('pesado_detalles_${preTarea.key}');

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
    sunmiBarcodePlugin = SunmiBarcodePlugin();
    if (await sunmiBarcodePlugin.isScannerAvailable()) {
      initPlatformState();
      print('es valido');
      sunmiBarcodePlugin.onBarcodeScanned().listen((event) async {
        await setCodeBar(event, true);
      });
    } else {
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
    Get.back(result: [
      personalSeleccionado.length,
      preTarea.sizeTipoCaja,
      preTarea.sizeTipoPersona
    ]);
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
        int index =
            personalSeleccionado.indexWhere((element) => element.key == key);
        goEliminar(index);

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
        PreTareaEsparragoDetalleVariosEntity item =
            personalSeleccionado.removeAt(index);
        item.esCaja
            ? sizeDetailsCaja = sizeDetailsCaja - 1
            : sizeDetailsPersona = sizeDetailsPersona - 1;

        preTarea.sizeTipoCaja = sizeDetailsCaja;
        preTarea.sizeDetails = personalSeleccionado.length;
        preTarea.sizeTipoPersona = sizeDetailsPersona;
        await _updatePesadoUseCase.execute(preTarea, preTarea.key);

        await _deletePesadoDetalleUseCase.execute(
            'pesado_detalles_${preTarea.key}', item.key);
        update(['seleccionados', 'personal_seleccionado']);
      },
      () => Get.back(),
    );
  }

  Future<void> goLectorCode() async {
    await FlutterBarcodeScanner.getBarcodeStreamReceiver(
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
        Box<PreTareaEsparragoDetalleVariosEntity> detalles =
            await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
                'pesado_detalles_${element.key}');
        int indexOtra = detalles.values.toList().indexWhere(
            (e) => e.codigotk.toString().trim() == barcode.toString().trim());
        if (indexOtra != -1) {
          byLector
              ? toastError('Error', 'Se encuentra en otra tarea')
              : await _showNotification(false, 'Se encuentra en otra tarea');
          await detalles.close();
          buscando = false;
          return;
        }
        await detalles.close();
      }

      int indexEncontrado = personalSeleccionado.indexWhere(
          (e) => e.codigotk.toString().trim() == barcode.toString().trim());
      if (indexEncontrado != -1) {
        byLector
            ? toastError('Error', 'Ya se encuentra registrado')
            : await _showNotification(false, 'Ya se encuentra registrado');
        buscando = false;
        update(['personal_seleccionado']);
        return;
      }

      List<String> valores = barcode.toString().split('_');
      if (valores.length < 3) {
        buscando = false;
        return;
      }
      bool esCaja = (valores.length == 3) ? true : false;
      int index = 0;
      if (!esCaja) {
        index = personal.indexWhere((e) => e.codigoempresa == valores[0]);
      }
      int indexCliente = clientes
          .indexWhere((e) => e.idcliente == int.parse(valores[esCaja ? 0 : 1]));
      if (indexCliente == -1) {
        byLector
            ? toastError('Error', 'No se encontro al cliente.')
            : await _showNotification(false, 'No se encontro al cliente.');
        buscando = false;
        update(['personal_seleccionado']);
        return;
      }
      if (index != -1) {
        int indexLabor = await labores
            .indexWhere((e) => e.idlabor == int.parse(valores[esCaja ? 1 : 2]));
        PreTareaEsparragoDetalleVariosEntity d =
            PreTareaEsparragoDetalleVariosEntity(
                personal: esCaja ? null : personal[index],
                codigoempresa: esCaja ? null : personal[index].codigoempresa,
                fecha: DateTime.now(),
                hora: DateTime.now(),
                imei: PreferenciasUsuario().imei ?? '',
                idestado: 1,
                linea: esCaja ? 0 : 3,
                esCaja: esCaja,
                cliente: clientes[indexCliente],
                idcliente: clientes[indexCliente].idcliente,
                idactividad: labores[indexLabor].idactividad,
                idlabor: labores[indexLabor].idlabor,
                labor: labores[indexLabor],
                correlativo: int.parse(valores[esCaja ? 2 : 4]),
                codigotk: barcode.toString().trim(),
                idusuario: PreferenciasUsuario().idUsuario,
                itemtipotk: esCaja ? 1 : 2,
                itempretareaesparragovarios:
                    preTarea.itempretareaesparragosvarios);
        update(['personal_seleccionado']);

        esCaja
            ? sizeDetailsCaja = sizeDetailsCaja + 1
            : sizeDetailsPersona = sizeDetailsPersona + 1;

        int key = await _createPesadoDetalleUseCase.execute(
            'pesado_detalles_${preTarea.key}', d);
        d.key = key;
        personalSeleccionado.add(d);
        preTarea.sizeTipoCaja = sizeDetailsCaja;
        preTarea.sizeDetails = personalSeleccionado.length;
        preTarea.sizeTipoPersona = sizeDetailsPersona;
        await _updatePesadoUseCase.execute(preTarea, preTarea.key);

        byLector
            ? toastExito('Éxito', 'Registrado con exito')
            : await _showNotification(true, 'Registrado con exito');
        buscando = false;
        return;
      } else {
        byLector
            ? toastError('Error', 'No se encuentra en la lista')
            : _showNotification(false, 'No se encuentra en la lista');
        buscando = false;
        return;
      }
    }
  }
}
