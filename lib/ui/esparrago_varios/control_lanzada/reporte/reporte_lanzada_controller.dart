import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_pesado_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/use_cases/get_reporte_pesado_linea_mesa_use_case.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:flutter_tareo/ui/utils/extensions.dart';

class ReporteLanzadaController extends GetxController {
  GetReportePesadoLineaMesaUseCase _getReportePesadoLineaMesaUseCase;
  ReportePesadoLineaMesaEntity reporte;
  bool validando = BOOLEAN_FALSE_VALUE;
  EsparragoAgrupaPersonalEntity mesaSelected;
  DateTime fechaSelected;
  PreTareaEsparragoVariosEntity tareaEsparrago;

  ReporteLanzadaController(this._getReportePesadoLineaMesaUseCase);

  @override
  void onInit() async {
    if (Get.arguments != null) {
      if (Get.arguments['mesa'] != null) {
        mesaSelected = Get.arguments['mesa'] as EsparragoAgrupaPersonalEntity;
      }
      if (Get.arguments['tarea'] != null) {
        tareaEsparrago =
            Get.arguments['tarea'] as PreTareaEsparragoVariosEntity;
      }
      if (Get.arguments['fecha'] != null) {
        fechaSelected = Get.arguments['fecha'] as DateTime;
      }
      await getReporte();
    }
    super.onInit();
  }

  Future<void> getReporte() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    reporte = switchResult(await _getReportePesadoLineaMesaUseCase.execute({
      'linea': mesaSelected.linea,
      'mesa': mesaSelected.grupo,
      'itempretareaesparragovarios': tareaEsparrago.itempretareaesparragovarios,
      'fecha': fechaSelected.toOnlyDate(),
      'turno': mesaSelected.turno,
      'grupo': mesaSelected.grupo
    }));
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
  }

  dynamic switchResult(
      ResultType<ReportePesadoLineaMesaEntity, Failure> result) {
    if (result is Success) {
      return result.data;
    }
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: (result.error as MessageEntity).message);
    }
  }
}
