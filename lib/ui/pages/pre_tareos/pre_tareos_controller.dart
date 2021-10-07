import 'dart:developer';

import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/di/listado_personas_pre_tareo_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/di/nueva_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/create_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/delete_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/get_all_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/migrar_all_pre_tareo_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/create_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo/listado_personas_pre_tareo_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea/nueva_pre_tarea_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class PreTareosController extends GetxController {
  final CreatePreTareoProcesoUseCase _createPreTareoProcesoUseCase;
  final GetAllPreTareoProcesoUseCase _getAllPreTareoProcesoUseCase;
  final UpdatePreTareoProcesoUseCase _updatePreTareoProcesoUseCase;
  final DeletePreTareoProcesoUseCase _deletePreTareoProcesoUseCase;
  final MigrarAllPreTareoUseCase _migrarAllPreTareoUseCase;

  PreTareosController(
      this._createPreTareoProcesoUseCase,
      this._getAllPreTareoProcesoUseCase,
      this._updatePreTareoProcesoUseCase,
      this._deletePreTareoProcesoUseCase,
      this._migrarAllPreTareoUseCase
      );

  @override
  void onInit() async {
    super.onInit();
    await getTareas();
  }

  Future<void> getTareas() async {
    preTareos = await _getAllPreTareoProcesoUseCase.execute();
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

  Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPreTareoUseCase.execute(preTareos[index]);
  }

  Future<void> goListadoPersonas(int index) async {
    ListadoPersonasPreTareoBinding().dependencies();
    final resultados = await Get.to<List<PreTareoProcesoDetalleEntity>>(
        () => ListadoPersonasPreTareoPage(),
        arguments: {
          'tarea': preTareos[index],
          'index': index,
        });

    if (resultados != null && resultados.isNotEmpty) {
      preTareos[index].detalles = resultados;
      await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);
      print(resultados.first.toJson());
      update(['tareas']);
    }
  }

  Future<void> delete(int index) async {
    await _deletePreTareoProcesoUseCase.execute(index);
    preTareos.removeAt(index);
  }

  List<int> seleccionados = [];
  List<PreTareoProcesoEntity> preTareos = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaPreTarea() async {
    NuevaPreTareaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoEntity>(() => NuevaPreTareaPage());
    if (result != null) {
      preTareos.add(result);
      await _createPreTareoProcesoUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': preTareos[index]});
    if (result != null) {
      log(result.toJson().toString());
      result.idusuario=PreferenciasUsuario().idUsuario;
      preTareos[index] = result;
      await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': preTareos[index]});
    if (result != null) {
      result.idusuario=PreferenciasUsuario().idUsuario;
      preTareos.add(result);
      await _createPreTareoProcesoUseCase.execute(preTareos.last);
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
        await copiarTarea(index);
      }, 
      ()=> Get.back(),
    );
  }

}
