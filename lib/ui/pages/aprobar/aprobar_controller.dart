import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class AprobarController extends GetxController {
  GetAllTareaProcesoUseCase _getAllTareaProcesoUseCase;
  UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;

  List<int> seleccionados = [];
  List<TareaProcesoEntity> tareas = [];

  AprobarController(
      this._getAllTareaProcesoUseCase, this._updateTareaProcesoUseCase);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await getTareas();
  }

  void seleccionar(int index) {
    print(tareas[index].estadoLocal);
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> getTareas() async {
    tareas = await _getAllTareaProcesoUseCase.execute();
    update(['tareas']);
    return;
  }

  Future<void> getimageditor(int index) async {
    Navigator.push(Get.overlayContext, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Color(0xFF009ee0),
        bottomBarColor: Colors.white,
      );
    })).then((geteditimage) async {
      if (geteditimage != null) {
        File _image = geteditimage[0];

        tareas[index].pathUrl = _image.path;
        tareas[index].estadoLocal = 'A';
        await _updateTareaProcesoUseCase.execute(
            tareas[index], tareas[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    TareaProcesoEntity tarea = tareas[index];
    if (tarea.personal == null || tarea.personal.isEmpty) {
      return 'No se puede aprobar una tarea que no tiene personal';
    } else {
      for (PersonalTareaProcesoEntity item in tarea.personal) {
        if (item.validadoParaAprobar != null) {
          return item.validadoParaAprobar;
        }
      }
    }
    return null;
  }

  void goAprobar(int index) async {
    String mensaje = await validarParaAprobar(index);
    if (mensaje != null) {
      basicAlert(
        context: Get.overlayContext,
        message: mensaje,
        onPressed: () => Get.back(),
      );
    } else {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea aprobar esta tarea?',
        'Si',
        'No',
        () async {
          Get.back();
          await getimageditor(index);
        },
        () => Get.back(),
      );
    }
  }
}
