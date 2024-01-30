import 'package:flutter_tareo/data/esparrago/datastores/esparrago_pesado_datastore_implementation.dart';
import 'package:flutter_tareo/data/esparrago/repositories/esparrago_pesado_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tarea_esparrago_varios_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/resumen_varios_repository_implementation.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_esparrago_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/send_resumen_varios_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/send_resumen_varios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/create_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/delete_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/get_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/migrar_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/ui/esparrago_varios/pesados/pesados_controller.dart';

import 'package:get/get.dart';

class PesadosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreTareaEsparragoVariosRepository>(
        () => PreTareaEsparragoVariosRepositoryImplementation());

    Get.lazyPut<EsparragoPesadoDataStore>(
        () => EsparragoPesadoDataStoreImplementation());
    //Get.lazyPut<EsparragoPesadoDataStore>(() => EsparragoPesadoDataStoreHiveImplementation());
    Get.lazyPut<EsparragoPesadoRepository>(
        () => EsparragoPesadoRepositoryImplementation(Get.find()));

    Get.lazyPut<ExportDataRepository>(
        () => ExportDataRepositoryImplementation());
    Get.lazyPut<ResumenVariosRepository>(
        () => ResumenVariosRepositoryImplementation());

    Get.lazyReplace<SendResumenVariosUseCase>(
        () => SendResumenVariosUseCase(Get.find()));

    Get.lazyReplace<SendResumenVariosEsparragoUseCase>(
        () => SendResumenVariosEsparragoUseCase(Get.find()));

    Get.lazyReplace<CreatePesadoUseCase>(() => CreatePesadoUseCase(Get.find()));
    Get.lazyReplace<GetAllPesadoUseCase>(() => GetAllPesadoUseCase(Get.find()));
    Get.lazyReplace<UpdatePesadoUseCase>(() => UpdatePesadoUseCase(Get.find()));
    Get.lazyReplace<DeletePesadoUseCase>(() => DeletePesadoUseCase(Get.find()));
    Get.lazyReplace<MigrarAllPesadoUseCase>(
        () => MigrarAllPesadoUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfPesadoUseCase>(
        () => UploadFileOfPesadoUseCase(Get.find()));
    Get.lazyReplace<ExportEsparragoToExcelUseCase>(
        () => ExportEsparragoToExcelUseCase(Get.find()));

    Get.lazyPut<PesadosController>(() => PesadosController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find()));
  }
}
