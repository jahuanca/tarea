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
    switch (value.toInt()) {
      case 1:
        break;
      case 3:
        await delete(index);
        update(['tareas']);
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
          'personal_seleccionado': tareas[index].personal,
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
      tareas.add(result);
      await _createTareaProcesoUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> goEditTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': tareas[index]});
    if (result != null) {
      tareas[index] = result;
      //await _createTareaProcesoUseCase.execute(result);
      update(['tareas']);
    }
  }
}
