
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/create_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/delete_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/get_all_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/migrar_all_pre_tareo_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos/pre_tareos_controller.dart';
import 'package:get/get.dart';

class PreTareosBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PreTareoProcesoRepository>(() => PreTareoProcesoRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(() => ExportDataRepositoryImplementation());

    Get.lazyReplace<CreatePreTareoProcesoUseCase>(() => CreatePreTareoProcesoUseCase(Get.find()));
    Get.lazyReplace<GetAllPreTareoProcesoUseCase>(() => GetAllPreTareoProcesoUseCase(Get.find()));
    Get.lazyReplace<UpdatePreTareoProcesoUseCase>(() => UpdatePreTareoProcesoUseCase(Get.find()));
    Get.lazyReplace<DeletePreTareoProcesoUseCase>(() => DeletePreTareoProcesoUseCase(Get.find()));
    Get.lazyReplace<MigrarAllPreTareoUseCase>(() => MigrarAllPreTareoUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfPreTareoUseCase>(() => UploadFileOfPreTareoUseCase(Get.find()));
    Get.lazyReplace<ExportDataToExcelUseCase>(() => ExportDataToExcelUseCase(Get.find()));

    Get.lazyPut<PreTareosController>(() => PreTareosController(Get.find(), Get.find() , Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}