import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/esparrago_varios/control_lanzada_esparrago_binding.dart';
import 'package:flutter_tareo/di/personal_esparrago_pesado_binding.dart';
import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/buscar_linea_mesa/get_linea_mesa_use_case.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/reporte/reporte_lanzada_page.dart';
import 'package:flutter_tareo/ui/pages/personal_esparrago_pesado/personal_esparrago_pesado_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_tareo/ui/utils/extensions.dart';

class ControlLanzadaController extends GetxController {
  bool validando = BOOLEAN_FALSE_VALUE;
  DateTime fecha = new DateTime.now();

  GetLineaMesaUseCase _getLineaMesaUseCase;
  int itempretareaesparragovarios;
  List<Map<String, String>> empty = [
    {'name': 'Todas', '_id': '-1'}
  ];
  List<EsparragoAgrupaPersonalEntity> lineas = [];
  List<EsparragoAgrupaPersonalEntity> mesas = [];
  Map<String, String> turnoSelected = TURNOS_ARRAY.first;
  EsparragoAgrupaPersonalEntity lineaSelected;
  EsparragoAgrupaPersonalEntity mesaSelected;

  List<EsparragoAgrupaPersonalEntity> currentList = [];
  List<EsparragoAgrupaPersonalEntity> listadoDiaTurno = [];

  ControlLanzadaController(
    this._getLineaMesaUseCase,
  );

  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      if (Get.arguments['item'] != null) {
        itempretareaesparragovarios = Get.arguments['item'] as int;
      }
      if (Get.arguments['tarea'] != null) {
        itempretareaesparragovarios =
            (Get.arguments['tarea'] as PreTareaEsparragoVariosEntity).getId;
      }
      await getListadoDia();
    }

    super.onInit();
  }

  void changeFecha(DateTime date) async {
    if (date != null) {
      fecha = date;
      getListadoDia();
    }
    update(['fecha']);
  }

  Future<void> getListadoDia() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    List<EsparragoAgrupaPersonalEntity> result =
        switchResult(await _getLineaMesaUseCase.execute(BuscarLineaMesaEntity(
      itempretareaesparragovarios: itempretareaesparragovarios,
      fecha: fecha,
      turno: turnoSelected['_id'],
    )));
    if (result != null) {
      listadoDiaTurno = result;
      lineas = listadoDiaTurno
          .toList()
          .unique((EsparragoAgrupaPersonalEntity x) => x.linea);
      lineas.sort((a, b) => a.linea.compareTo(b.linea));
      if (lineas.isEmpty) {
        currentList = [];
        mesas = [];
      } else {
        lineaSelected = lineas.first;
        mesas = listadoDiaTurno
            .where((e) => e.linea == lineaSelected.linea)
            .toList();
        mesas.sort(((a, b) => a.grupo.compareTo(b.grupo)));
        currentList = mesas;
        mesaSelected = lineas.first;
      }
    }
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID, 'listado', SELECCIONADO_ID]);
  }

  Future<void> changeValue(String label, String value) async {
    if ([null, '-1'].contains(value)) return;
    switch (label) {
      case 'turnos':
        turnoSelected = TURNOS_ARRAY.firstWhere((e) => e['_id'] == value);
        getListadoDia();
        break;
      case 'lineas':
        lineaSelected =
            lineas.firstWhere((e) => '${e.itemagruparpersonal}' == value);
        currentList = listadoDiaTurno
            .where((e) => e.linea == lineaSelected.linea)
            .toList();
        update(['lineas', 'listado']);
        break;
      case 'mesas':
        if ([-1, '-1'].contains(value)) {
          mesaSelected = mesas.first;
          currentList = listadoDiaTurno
              .where((e) => e.linea == lineaSelected.linea)
              .toList();
          update(['mesas', 'listado']);
          return;
        }
        mesaSelected =
            mesas.firstWhere((e) => '${e.itemagruparpersonal}' == value);
        currentList = listadoDiaTurno
            .where((e) => '${e.itemagruparpersonal}' == value)
            .toList();
        update(['mesas', 'listado']);
        break;
    }
    update([label]);
  }

  Future<void> getResumenMesaLinea() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    List<EsparragoAgrupaPersonalEntity> result =
        switchResult(await _getLineaMesaUseCase.execute(BuscarLineaMesaEntity(
      itempretareaesparragovarios: itempretareaesparragovarios,
      fecha: fecha.subtract(Duration(days: 1)),
      turno: turnoSelected['_id'],
    )));
    if (result != null) {
      currentList = result;
      lineas = currentList
          .toList()
          .unique((EsparragoAgrupaPersonalEntity x) => x.linea);
    }
    /*swithResult(await _getResumenLanzaUseCase
        .execute(itempretareaesparragovarios ?? 27));*/
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID, 'listado']);
  }

  void swithResult(ResultType result) {
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: ((result.error) as MessageEntity).message);
    } else {
      if (result.data is List<ResumenLanzadaEntity>) {
        currentList = result.data;
        update(['listado']);
      }
    }
  }

  Future<void> goReporteLanzada(int index) async {
    ControlLanzadaEsparragoBinding().dependencies();
    Get.to(() => ReporteLanzadaPage(), arguments: {
      'otras': Get.arguments['otras'],
      'tarea': Get.arguments['tarea'],
      'fecha': fecha,
      'mesa': currentList[index],
    });
  }

  Future<void> goListadoPersonasPreTareaEsparrago(int index) async {
    PersonalEsparragoPesadoBinding().dependencies();
    final resultado =
        await Get.to<int>(() => PersonalEsparragoPesadoPage(), arguments: {
      'otras': Get.arguments['otras'],
      'tarea': Get.arguments['tarea'],
      'index': Get.arguments['index'],
      'mesa': currentList[index],
    });

    if (resultado != null) {
      //pesados[index].sizeDetails = resultado;
      update(['tareas']);
    }
  }
}
