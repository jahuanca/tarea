
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tarea_esparrago_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_repository.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/create_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/delete_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/get_all_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/migrar_all_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/update_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/upload_file_of_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/ui/pages/clasificados/clasificados_controller.dart';
import 'package:get/get.dart';

class ClasificadosBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PreTareaEsparragoRepository>(() => PreTareaEsparragoRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(() => ExportDataRepositoryImplementation());

    Get.lazyReplace<CreateClasificacionUseCase>(() => CreateClasificacionUseCase(Get.find()));
    Get.lazyReplace<GetAllClasificacionUseCase>(() => GetAllClasificacionUseCase(Get.find()));
    Get.lazyReplace<UpdateClasificacionUseCase>(() => UpdateClasificacionUseCase(Get.find()));
    Get.lazyReplace<DeleteClasificacionUseCase>(() => DeleteClasificacionUseCase(Get.find()));
    Get.lazyReplace<MigrarAllClasificacionUseCase>(() => MigrarAllClasificacionUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfClasificacionUseCase>(() => UploadFileOfClasificacionUseCase(Get.find()));
    Get.lazyReplace<ExportDataToExcelUseCase>(() => ExportDataToExcelUseCase(Get.find()));

    Get.lazyPut<ClasificadosController>(() => ClasificadosController(Get.find(), Get.find() , Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}