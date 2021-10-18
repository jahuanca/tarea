
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/create_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/delete_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/get_all_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/migrar_all_pre_tareo_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/create_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/delete_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/get_all_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/migrar_all_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/update_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/upload_file_of_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos/pre_tareos_controller.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos_uva/pre_tareos_uva_controller.dart';
import 'package:get/get.dart';

class PreTareosUvaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PreTareoProcesoUvaRepository>(() => PreTareoProcesoUvaRepositoryImplementation());

    Get.lazyReplace<CreatePreTareoProcesoUvaUseCase>(() => CreatePreTareoProcesoUvaUseCase(Get.find()));
    Get.lazyReplace<GetAllPreTareoProcesoUvaUseCase>(() => GetAllPreTareoProcesoUvaUseCase(Get.find()));
    Get.lazyReplace<UpdatePreTareoProcesoUvaUseCase>(() => UpdatePreTareoProcesoUvaUseCase(Get.find()));
    Get.lazyReplace<DeletePreTareoProcesoUvaUseCase>(() => DeletePreTareoProcesoUvaUseCase(Get.find()));
    Get.lazyReplace<MigrarAllPreTareoUvaUseCase>(() => MigrarAllPreTareoUvaUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfPreTareoUvaUseCase>(() => UploadFileOfPreTareoUvaUseCase(Get.find()));

    Get.lazyPut<PreTareosUvaController>(() => PreTareosUvaController(Get.find(), Get.find() , Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}