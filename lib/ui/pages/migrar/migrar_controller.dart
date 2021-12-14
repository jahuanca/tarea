import 'dart:io';

import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/migrar_all_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class MigrarController extends GetxController {
  final GetAllTareaProcesoUseCase _getAllTareaProcesoUseCase;
  final UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  final MigrarAllTareaUseCase _migrarAllTareaUseCase;
  final UploadFileOfTareaUseCase _uploadFileOfTareaUseCase;

  List<TareaProcesoEntity> tareas = [];

  bool validando = false;

  MigrarController(
      this._getAllTareaProcesoUseCase,
      this._updateTareaProcesoUseCase,
      this._migrarAllTareaUseCase,
      this._uploadFileOfTareaUseCase);

  @override
  void onInit() async {
    super.onInit();
    await getTareas();
  }

  Future<void> getTareas() async {
    tareas.clear();
    tareas.addAll(await _getAllTareaProcesoUseCase.execute());
    update(['tareas']);
  }

  @override
  void onReady() {
    super.onReady();
  }

  List<int> seleccionados = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  void goMigrar(int index) {
    if (tareas[index].estadoLocal == 'A') {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea migrar esta tarea?',
        'Si',
        'No',
        () async {
          Get.back();
          await migrar(index);
        },
        () => Get.back(),
      );
    } else {
      basicAlert(
        Get.overlayContext,
        'Alerta',
        'Esta tarea aun no ha sido aprobada',
        'Aceptar',
        () => Get.back(),
      );
    }
  }

  Future<void> migrar(int index) async {
    validando = true;
    update(['validando']);
    TareaProcesoEntity tareaMigrada =
        await _migrarAllTareaUseCase.execute(tareas[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      tareas[index].estadoLocal = 'M';
      tareas[index].itemtareoproceso = tareaMigrada.itemtareoproceso;
      await _updateTareaProcesoUseCase.execute(tareas[index], tareas[index].key);
      tareaMigrada = await _uploadFileOfTareaUseCase.execute(
          tareas[index], File(tareas[index].pathUrl));
      tareas[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updateTareaProcesoUseCase.execute(tareas[index], tareas[index].key);
    }
    validando = false;

    update(['validando', 'tareas']);
  }
}
