import 'dart:developer';

import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/di/nueva_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/create_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class TareasController extends GetxController {
  CreateTareaProcesoUseCase _createTareaProcesoUseCase;
  GetAllTareaProcesoUseCase _getAllTareaProcesoUseCase;
  UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  DeleteTareaProcesoUseCase _deleteTareaProcesoUseCase;

  TareasController(
      this._createTareaProcesoUseCase,
      this._getAllTareaProcesoUseCase,
      this._updateTareaProcesoUseCase,
      this._deleteTareaProcesoUseCase);

  @override
  void onInit() async {
    super.onInit();
    await getTareas();
  }

  Future<void> getTareas() async {
    tareas = await _getAllTareaProcesoUseCase.execute();
    return;
  }

  void onChangedMenu(dynamic value, int index) async {
    switch (value.toInt()){
      case 1:
        break;
      case 2:
        goCopiar(index);
        break;
      case 3:
        goEliminar(index);
        break;
      default:
        break;
    }
  }

  Future<void> goAgregarPersona(int index) async {
    AgregarPersonaBinding().dependencies();
    final resultado = await Get.to<PersonalTareaProcesoEntity>(
        () => AgregarPersonaPage(),
        arguments: {
          'personal_seleccionado': tareas[index].personal,
          'tarea': tareas[index],
          'sede': tareas[index].sede
        });
    if (resultado != null) {
      tareas[index].personal.add(resultado);
      await _updateTareaProcesoUseCase.execute(tareas[index], index);
      update(['tareas']);
    }
  }

  Future<void> goListadoPersonas(int index) async {
    ListadoPersonasBinding().dependencies();
    final resultados = await Get.to<List<PersonalTareaProcesoEntity>>(
        () => ListadoPersonasPage(),
        arguments: {
          'tarea': tareas[index],
          'index': index,
          'sede': tareas[index].sede
        });

    if (resultados != null) {
      tareas[index].personal = resultados;
      await _updateTareaProcesoUseCase.execute(tareas[index], index);
      update(['tareas']);
    }
  }

  Future<void> delete(int index) async {
    await _deleteTareaProcesoUseCase.execute(index);
    tareas.removeAt(index);
  }

  List<int> seleccionados = [];
  List<TareaProcesoEntity> tareas = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaTarea() async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage());
    if (result != null) {
      result.idusuario=PreferenciasUsuario().idUsuario;
      tareas.add(result);
      await _createTareaProcesoUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': tareas[index]});
    if (result != null) {
      log(result.toJson().toString());
      result.idusuario=PreferenciasUsuario().idUsuario;
      tareas[index] = result;
      await _updateTareaProcesoUseCase.execute(tareas[index], index);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': tareas[index]});
    if (result != null) {
      result.idusuario=PreferenciasUsuario().idUsuario;
      tareas.add(result);
      await _createTareaProcesoUseCase.execute(tareas.last);
      update(['tareas']);
    }
  }

  void goEliminar(int index){
    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Esta seguro de eliminar esta tarea?', 
      'Si', 
      'No', 
      () async{
        await delete(index);
        update(['tareas']);
        Get.back();
      }, 
      ()=> Get.back(),
    );
  }

  void goCopiar(int index){
    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Esta seguro de copiar la siguiente tarea?', 
      'Si', 
      'No', 
      () async{
        Get.back();
        await copiarTarea(index);
      }, 
      ()=> Get.back(),
    );
  }

  void goEditar(int index){
    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Esta seguro de editar la siguiente tarea?', 
      'Si', 
      'No', 
      () async{
        Get.back();
        await editarTarea(index);
      }, 
      ()=> Get.back(),
    );
  }

}
