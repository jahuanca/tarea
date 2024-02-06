import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/use_cases/reporte_packing/get_report_by_document_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/GetxScannerController.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';

class ReportePackingController extends GetxScannerController {
  ReportePackingEntity reporte;
  PreTareoProcesoUvaEntity header;
  GetReportByDocumentUseCase _getReportByDocumentUseCase;
  List<PersonalEmpresaEntity> personal = [];
  GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  bool validando = BOOLEAN_FALSE_VALUE;

  ReportePackingController(this._getReportByDocumentUseCase,
      this._getPersonalsEmpresaBySubdivisionUseCase);

  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['packing'] != null) {
        header = Get.arguments['packing'] as PreTareoProcesoUvaEntity;
      }
    }
    _searchInPersonalEmpresa();
  }

  Future<void> _searchInPersonalEmpresa() async {
    personal = await _getPersonalsEmpresaBySubdivisionUseCase
        .execute(PreferenciasUsuario().idSede);
  }

  @override
  Future<void> setCodeBar(dynamic barcode,
      [bool byLector = BOOLEAN_FALSE_VALUE]) async {
    super.setCodeBar(barcode);
    goScanner(barcode);
  }

  Future<void> goScanner([dynamic result]) async {
    if (result == null) {
      result = await goOnlyOneRead();
    }
    if (result != null) {
      validando = BOOLEAN_TRUE_VALUE;
      update([VALIDANDO_ID]);
      PersonalEmpresaEntity persona =
          personal.firstWhere((e) => e.nrodocumento == result);
      if (persona != null) {
        Map<int, List<PreTareoProcesoUvaDetalleEntity>> result =
            await _getReportByDocumentUseCase.execute(
                persona.codigoempresa, header);
        reporte = ReportePackingEntity();
        reporte.personal = persona;
        reporte.header = header;
        reporte.labors = result;
        toast(type: TypeToast.SUCCESS, message: 'Reporte generado.');
      } else {
        toast(
            type: TypeToast.ERROR,
            message: 'Esta persona no se encuentra en esta sede.');
      }
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
    } else {
      toast(type: TypeToast.ERROR, message: 'No se pudo leer el código QR.');
    }
  }
}
