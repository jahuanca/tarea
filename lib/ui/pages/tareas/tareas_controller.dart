
import 'package:flutter_tareo/di/nueva_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:get/get.dart';

class TareasController extends GetxController{

  List<int> seleccionados=[];
  List<TareaProcesoEntity> tareas=[];

  void seleccionar(int index){
    int i=seleccionados.indexWhere((element) => element==index);
    if(i==-1){
      seleccionados.add(index);
    }else{
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaTarea() async{
    NuevaTareaBinding().dependencies();
    final result=await Get.to<TareaProcesoEntity>(() => NuevaTareaPage());
    if(result!=null){
      tareas.add(result);
      update(['tareas']);
    }
  }
}