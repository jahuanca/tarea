
import 'package:flutter_tareo/data/repositories/tarea_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/migrar_all_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/migrar/migrar_controller.dart';
import 'package:get/get.dart';

class MigrarBinding extends Bindings{

  @override
  void dependencies() {

    Get.lazyPut<TareaProcesoRepository>(() => TareaProcesoRepositoryImplementation());

    Get.lazyReplace<MigrarAllTareaUseCase>(() => MigrarAllTareaUseCase(Get.find()));
    Get.lazyReplace<GetAllTareaProcesoUseCase>(() => GetAllTareaProcesoUseCase(Get.find()));
    Get.lazyReplace<UpdateTareaProcesoUseCase>(() => UpdateTareaProcesoUseCase(Get.find()));
    Get.lazyReplace<DeleteTareaProcesoUseCase>(() => DeleteTareaProcesoUseCase(Get.find()));

    Get.lazyPut<MigrarController>(() => MigrarController(Get.find(), Get.find(), Get.find()));
    
  }

}