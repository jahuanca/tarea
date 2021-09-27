
import 'package:flutter_tareo/data/repositories/tarea_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/aprobar/aprobar_controller.dart';
import 'package:get/get.dart';

class AprobarBinding extends Bindings{

  @override
  void dependencies() {

    Get.lazyPut<TareaProcesoRepository>(() => TareaProcesoRepositoryImplementation());

    Get.lazyReplace<GetAllTareaProcesoUseCase>(() => GetAllTareaProcesoUseCase(Get.find()));
    Get.lazyReplace<UpdateTareaProcesoUseCase>(() => UpdateTareaProcesoUseCase(Get.find()));
    Get.lazyReplace<DeleteTareaProcesoUseCase>(() => DeleteTareaProcesoUseCase(Get.find()));

    Get.lazyPut<AprobarController>(() => AprobarController(Get.find(), Get.find()));
    
  }

}