
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/migrar_all_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/create_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class MigrarController extends GetxController{

  GetAllTareaProcesoUseCase _getAllTareaProcesoUseCase;
  UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  MigrarAllTareaUseCase _migrarAllTareaUseCase;

  List<TareaProcesoEntity> tareas=[];

  MigrarController(this._getAllTareaProcesoUseCase, this._updateTareaProcesoUseCase, this._migrarAllTareaUseCase);

  @override
  void onInit() async{
    super.onInit();
    tareas= await _getAllTareaProcesoUseCase.execute();
  }

  @override
  void onReady(){
    super.onReady();
  }

  List<int> seleccionados=[];

  void seleccionar(int index){
    int i=seleccionados.indexWhere((element) => element==index);
    if(i==-1){
      seleccionados.add(index);
    }else{
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  void goAprobar(int index){
    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Desea migrar esta tarea?', 
      'Si', 
      'No', 
      ()async{
        Get.back();
        await migrar(index);
        
      }, 
      ()=> Get.back(),
    );
  }

  Future<void> migrar(int index)async{
    await _migrarAllTareaUseCase.execute(tareas[index]);
  }
}