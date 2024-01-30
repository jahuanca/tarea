import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/create_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/delete_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/get_all_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/update_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/GetxScannerController.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';

class PersonalEsparragoPesadoController extends GetxScannerController {
  List<int> seleccionados = [];
  List<EsparragoAgrupaPersonalEntity> grupos = [];
  List<ClienteEntity> clientes = [];
  List<PersonalPreTareaEsparragoEntity> personalSeleccionado = [];
  int indexTarea;
  PreTareaEsparragoVariosEntity preTarea;
  EsparragoAgrupaPersonalEntity mesaSelected;
  List<PreTareaEsparragoVariosEntity> otrasPreTareas = [];

  List<CalibreEntity> calibres = [];
  List<ViaEnvioEntity> viasEnvio = [];
  List<LaborEntity> labores = [];

  final GetCalibresUseCase _getCalibresUseCase;

  final GetViaEnviosUseCase _getViaEnviosUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  final GetClientesUseCase _getClientesUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;

  final GetAllPersonalEsparragoPesadoUseCase
      _getAllPersonalEsparragoPesadoUseCase;
  final CreatePersonalEsparragoPesadoUseCase
      _createPersonalEsparragoPesadoUseCase;
  final UpdatePersonalEsparragoPesadoUseCase
      _updatePersonalEsparragoPesadoUseCase;
  final DeletePersonalEsparragoPesadoUseCase
      _deletePersonalEsparragoPesadoUseCase;
  bool validando = BOOLEAN_FALSE_VALUE;
  bool editando = BOOLEAN_FALSE_VALUE;
  int sizeDetailsCaja = ZERO_INT_VALUE;
  int sizeDetailsPersona = ZERO_INT_VALUE;

  PersonalEsparragoPesadoController(
    this._updatePesadoUseCase,
    this._getCalibresUseCase,
    this._getViaEnviosUseCase,
    this._getLaborsUseCase,
    this._getClientesUseCase,
    this._getAllPersonalEsparragoPesadoUseCase,
    this._createPersonalEsparragoPesadoUseCase,
    this._updatePersonalEsparragoPesadoUseCase,
    this._deletePersonalEsparragoPesadoUseCase,
  );

  @override
  void onInit() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    calibres = await _getCalibresUseCase.execute();
    viasEnvio = await _getViaEnviosUseCase.execute();
    labores = await _getLaborsUseCase.execute();
    clientes = await _getClientesUseCase.execute();

    if (Get.arguments != null) {
      if (Get.arguments['otras'] != null) {
        otrasPreTareas =
            Get.arguments['otras'] as List<PreTareaEsparragoVariosEntity>;
        print('llego valor');
      }
      if (Get.arguments['mesa'] != null) {
        mesaSelected = Get.arguments['mesa'] as EsparragoAgrupaPersonalEntity;
      }
      if (Get.arguments['tarea'] != null) {
        preTarea = Get.arguments['tarea'] as PreTareaEsparragoVariosEntity;
        personalSeleccionado = swicthResult(
                await _getAllPersonalEsparragoPesadoUseCase.execute((IS_ONLINE)
                    ? {
                        QUERY_MESA: mesaSelected.grupo,
                        QUERY_LINEA: mesaSelected.linea,
                        'itempretareaesparragovarios':
                            preTarea.itempretareaesparragovarios
                      }
                    : {
                        KEY_BOX_HIVE:
                            'personal_pre_tarea_esparrago_${preTarea.key}'
                      })) ??
            [];

        update(['personal_seleccionado']);
      }

      if (Get.arguments['index'] != null) {
        editando = BOOLEAN_TRUE_VALUE;
        indexTarea = Get.arguments['index'] as int;
      }
    }

    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    super.onInit();
  }

  dynamic swicthResult(ResultType<dynamic, Failure> result) {
    if (result is Success) {
      return result.data;
    }
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: (result.error as MessageEntity).message);
    }
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
    return BOOLEAN_TRUE_VALUE;
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
        //await _updatePesadoUseCase.execute(preTarea, preTarea.key);
        await _deletePersonalEsparragoPesadoUseCase.execute(item);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  bool buscando = BOOLEAN_FALSE_VALUE;
  bool esperandoCierre = BOOLEAN_FALSE_VALUE;

  Future<void> _showNotification(
      {bool byLector = BOOLEAN_TRUE_VALUE,
      bool isSuccess,
      String message}) async {
    if (byLector) {
      super.showToast(isSuccess, message);
    } else {
      super.showNotification(isSuccess, message);
    }
  }

  @override
  Future<void> setCodeBar(dynamic barcode,
      [bool byLector = BOOLEAN_FALSE_VALUE]) async {
    print(barcode);
    if (barcode != null && barcode != '-1') {
      List<String> codigos = barcode.toString().trim().split('_');

      if (barcode.toString().trim().toUpperCase()[0] == 'A') {
        if (esperandoCierre) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'Se esta esperando una etiqueta de cierre.');
          return;
        }

        if (codigos.length < 6) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'Etiqueta de apertura, con datos incompletos.');
          return;
        }

        int indexLabor =
            labores.indexWhere((e) => e.idlabor == int.tryParse(codigos[1]));

        if (indexLabor == -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'No se pudo encontrar la labor');
          return;
        }

        int indexCliente =
            clientes.indexWhere((e) => e.idcliente == int.tryParse(codigos[2]));

        if (indexCliente == -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'No se pudo encontrar el cliente');
          return;
        }

        int indexCalibre =
            calibres.indexWhere((e) => e.idcalibre == int.tryParse(codigos[3]));

        if (indexCalibre == -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'No se pudo encontrar el calibre');
          return;
        }

        int indexViaEnvio =
            viasEnvio.indexWhere((e) => e.idvia == int.tryParse(codigos[4]));

        if (indexViaEnvio == -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'No se pudo encontrar la vía de envío.');
          return;
        }

        esperandoCierre = BOOLEAN_TRUE_VALUE;
        personalSeleccionado.insert(
            ZERO_INT_VALUE,
            new PersonalPreTareaEsparragoEntity(
              itempretareaesparragovarios: preTarea.getId,
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
              esperandoCierre: BOOLEAN_TRUE_VALUE,
              linea: mesaSelected.linea.toString(),
              mesa: mesaSelected.grupo.toString(),
              idSQLitePreTareaEsparrago: preTarea.idSQLite,
              keyParent: preTarea.key,
            ));
      }
      if (barcode.toString().trim().toUpperCase()[0] == 'C') {
        if (!esperandoCierre) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'Se esta esperando una etiqueta de apertura.');
          return;
        }

        if (codigos.length < 4) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'Etiqueta de cierre, con datos incompletos.');
          return;
        }

        if ((codigos[1] != mesaSelected.grupo.toString()) ||
            codigos[2] != mesaSelected.linea.toString()) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message:
                  'No pertenece a: L${mesaSelected.linea} - M${mesaSelected.grupo}.');
          return;
        }

        int index =
            personalSeleccionado.indexWhere((e) => e.esperandoCierre == true);

        if (index == -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'No existe etiqueta que espera ser cerrada.');
          return;
        }

        int indexR = personalSeleccionado.indexWhere(
            (e) => '${e.codigotkmesa}' == '${barcode.toString().trim()}');

        if (indexR != -1) {
          _showNotification(
              byLector: byLector,
              isSuccess: BOOLEAN_FALSE_VALUE,
              message: 'Esta etiqueta de cierre ya ha sido registrada.');
          return;
        }
        /*
        for (PreTareaEsparragoVariosEntity otra in otrasPreTareas) {
          List<PersonalPreTareaEsparragoEntity> otroPersonal = swicthResult(
                  await _getAllPersonalEsparragoPesadoUseCase
                      .execute('personal_pre_tarea_esparrago_${otra.key}')) ??
              [];

          int indexROtra = otroPersonal.indexWhere(
              (e) => '${e.codigotkmesa}' == '${barcode.toString().trim()}');

          if (indexROtra != -1) {
            toast(
                type: TypeToast.ERROR,
                message: 'Esta etiqueta ya esta en otra pretarea.');
            return;
          }
        }
        */

        if (index != -1) {
          PersonalPreTareaEsparragoEntity lastValue =
              personalSeleccionado[index];
          personalSeleccionado[index].codigotkmesa = barcode.toString().trim();
          personalSeleccionado[index].esperandoCierre = BOOLEAN_FALSE_VALUE;
          personalSeleccionado[index].mesa = mesaSelected.grupo.toString();
          personalSeleccionado[index].linea = mesaSelected.linea.toString();
          personalSeleccionado[index].correlativomesa =
              int.tryParse(codigos[3]) ?? ZERO_INT_VALUE;

          personalSeleccionado[index].idusuario =
              PreferenciasUsuario().idUsuario;
          personalSeleccionado[index].fecha = new DateTime.now();
          personalSeleccionado[index].hora = new DateTime.now();
          PersonalPreTareaEsparragoEntity result = swicthResult(
              await _createPersonalEsparragoPesadoUseCase.execute(
                  'personal_pre_tarea_esparrago_${preTarea.key}',
                  personalSeleccionado[index]));
          if (result == null) {
            personalSeleccionado[index] = lastValue;
          }
          //TODO: esto es edicion offline
          /*
          int key = result.itempersonalpretareaesparrago;
          personalSeleccionado[index].key = key;
          await _updatePersonalEsparragoPesadoUseCase.execute(
              'personal_pre_tarea_esparrago_${preTarea.key}',
              key,
              personalSeleccionado[index]);
              
          preTarea.sizeDetails = personalSeleccionado.length;
          await _updatePesadoUseCase.execute(preTarea, preTarea.key);*/
          esperandoCierre = BOOLEAN_FALSE_VALUE;
        }
      }
      update(['seleccionados', 'personal_seleccionado']);
    }
  }

  Future<void> goCancelarEsperando(int index) async {
    bool resultado = await basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de cancelar este registro?',
      onPressed: () async => Get.back(result: BOOLEAN_TRUE_VALUE),
      onCancel: () async => Get.back(result: BOOLEAN_FALSE_VALUE),
    );
    if (resultado != null && resultado) {
      esperandoCierre = BOOLEAN_FALSE_VALUE;
      personalSeleccionado.removeAt(index);
      update(['seleccionados', 'personal_seleccionado']);
    }
  }
}

/*
C:\Users\J. HUANCA\fvm\default\bin
FVM_HOME
PS D:\trabajo\agrovision\avg_controles\flutter_tareo> flutter --version
Flutter 2.2.2-0.0.pre.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 36620c91e0 (2 years, 4 months ago) • 2021-09-01 23:19:55 -0500
Engine • revision 6a5030d61b
Tools • Dart 2.14.0 (build 2.14.0-167.0.dev)
Dart SDK version: 2.14.0-167.0.dev
*/