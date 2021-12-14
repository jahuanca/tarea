
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/tarea_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/migrar_all_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_tarea_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/create_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_controller.dart';
import 'package:get/get.dart';

class TareasBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<TareaProcesoRepository>(() => TareaProcesoRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(() => ExportDataRepositoryImplementation());

    Get.lazyPut<CreateTareaProcesoUseCase>(() => CreateTareaProcesoUseCase(Get.find()));
    Get.lazyPut<GetAllTareaProcesoUseCase>(() => GetAllTareaProcesoUseCase(Get.find()));
    Get.lazyPut<UpdateTareaProcesoUseCase>(() => UpdateTareaProcesoUseCase(Get.find()));
    Get.lazyPut<DeleteTareaProcesoUseCase>(() => DeleteTareaProcesoUseCase(Get.find()));
    Get.lazyPut<MigrarAllTareaUseCase>(() => MigrarAllTareaUseCase(Get.find()));
    Get.lazyPut<DeleteTareaProcesoUseCase>(() => DeleteTareaProcesoUseCase(Get.find()));
    Get.lazyPut<ExportTareaToExcelUseCase>(() => ExportTareaToExcelUseCase(Get.find()));

    Get.lazyPut<TareasController>(() => TareasController(Get.find(), Get.find() , Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}