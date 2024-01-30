import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/use_cases/get_resumen_lanzada_use_case.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';

class ControlLanzadaController extends GetxController {
  bool validando = BOOLEAN_FALSE_VALUE;
  DateTime fecha = new DateTime.now();
  List<int> seleccionados = List.empty();
  List<ResumenLanzadaEntity> listado = [];
  GetResumenLanzaUseCase _getResumenLanzaUseCase;
  int itempretareaesparragovarios;
  List<Map<String, String>> empty = [
    {'name': 'Todas', '_id': '-1'}
  ];
  List<PersonalPreTareaEsparragoEntity> lineas = [];
  List<PersonalPreTareaEsparragoEntity> mesas = [];
  Map<String, String> turnoSelected = TURNOS_ARRAY.first;
  PersonalPreTareaEsparragoEntity lineaSelected;
  PersonalPreTareaEsparragoEntity mesaSelected;

  ControlLanzadaController(
    this._getResumenLanzaUseCase,
  );

  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      if (Get.arguments['item'] != null) {
        itempretareaesparragovarios = Get.arguments['item'] as int;
      }
    }
    await getResumenMesaLinea();
    super.onInit();
  }

  void changeFecha(DateTime date) {
    if (fecha != null) fecha = date;
    update(['fecha']);
  }

  Future<void> getResumenMesaLinea() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    swithResult(await _getResumenLanzaUseCase
        .execute(itempretareaesparragovarios ?? 27));
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
  }

  void swithResult(ResultType result) {
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: ((result.error) as MessageEntity).message);
    } else {
      if (result.data is List<ResumenLanzadaEntity>) {
        listado = result.data;
        update(['listado']);
      }
    }
  }
}
