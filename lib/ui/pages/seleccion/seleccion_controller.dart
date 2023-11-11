import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_personas_seleccion_binding.dart';
import 'package:flutter_tareo/di/nueva_seleccion_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_seleccion_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/create_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/delete_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/get_all_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/migrar_all_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/update_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/upload_file_of_seleccion_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_seleccion/listado_personas_seleccion_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_seleccion/nueva_seleccion_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class SeleccionController extends GetxController {
  final CreateSeleccionUseCase _createSeleccionUseCase;
  final GetAllSeleccionUseCase _getAllSeleccionUseCase;
  final UpdateSeleccionUseCase _updateSeleccionUseCase;
  final DeleteSeleccionUseCase _deleteSeleccionUseCase;
  final MigrarAllSeleccionUseCase _migrarAllSeleccionUseCase;
  final UploadFileOfSeleccionUseCase _uploadFileOfSeleccionUseCase;
  final ExportSeleccionToExcelUseCase _exportSeleccionToExcelUseCase;

  bool validando = false;

  SeleccionController(
      this._createSeleccionUseCase,
      this._getAllSeleccionUseCase,
      this._updateSeleccionUseCase,
      this._deleteSeleccionUseCase,
      this._migrarAllSeleccionUseCase,
      this._uploadFileOfSeleccionUseCase,
      this._exportSeleccionToExcelUseCase);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await getTareas();
  }

  Future<void> getTareas() async {
    seleccions = [];
    seleccions = await _getAllSeleccionUseCase.execute();
    update(['tareas']);
    return;
  }

  void onChangedMenu(dynamic value, int key) async {
    switch (value.toInt()) {
      case 1:
        break;
      case 2:
        goCopiar(key);
        break;
      case 3:
        goEliminar(key);
        break;
      case 4:
        goExcel(key);
        break;
      default:
        break;
    }
  }

  void goExcel(int key) async {
    await _exportSeleccionToExcelUseCase.execute(key);
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
        '¿Desea aprobar esta actividad?',
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

  Future<void> getimageditor(int index) async {
    Navigator.push(Get.overlayContext, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Color(0xFF009ee0),
        bottomBarColor: Colors.white,
      );
    })).then((geteditimage) async {
      if (geteditimage != null) {
        File _image = geteditimage[0];

        seleccions[index].pathUrl = _image.path;
        seleccions[index].estadoLocal = 'A';
        await _updateSeleccionUseCase.execute(
            seleccions[index], seleccions[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareaEsparragoGrupoEntity tarea = seleccions[index];
    if (tarea.sizeDetails == null || tarea.sizeDetails == 0) {
      return 'No se puede aprobar una actividad que no tiene personal';
    } else {
      /* for (var item in tarea.detalles) {
        if (!item.validadoParaAprobar) {
          return 'Verifique que todos los datos del personal esten llenos';
        }
      } */
    }
    return null;
  }

  Future<void> goMigrar(int key) async {
    int index = seleccions.indexWhere((element) => element.key == key);
    if (seleccions[index].estadoLocal == 'A') {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea migrar esta actividad?',
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
        context: Get.overlayContext,
        message: 'Esta tarea aun no ha sido aprobada',
        onPressed: () => Get.back(),
      );
    }
  }

  Future<void> migrar(int index) async {
    validando = true;
    update(['validando']);
    PreTareaEsparragoGrupoEntity tareaMigrada =
        await _migrarAllSeleccionUseCase.execute(seleccions[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      seleccions[index].estadoLocal = 'M';
      seleccions[index].itempretareaesparragogrupo =
          tareaMigrada.itempretareaesparragogrupo;
      await _updateSeleccionUseCase.execute(
          seleccions[index], seleccions[index].key);
      tareaMigrada = await _uploadFileOfSeleccionUseCase.execute(
          seleccions[index], File(seleccions[index].pathUrl));
      seleccions[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updateSeleccionUseCase.execute(
          seleccions[index], seleccions[index].key);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  Future<void> goListadoPersonas(int index) async {
    List<PreTareaEsparragoGrupoEntity> otras = [];
    otras.addAll(seleccions);
    otras.removeAt(index);
    ListadoPersonasSeleccionBinding().dependencies();
    final resultado =
        await Get.to<int>(() => ListadoPersonasSeleccionPage(), arguments: {
      'otras': otras,
      'tarea': seleccions[index],
      'index': index,
    });

    if (resultado != null) {
      seleccions[index].sizeDetails = resultado;
      await _updateSeleccionUseCase.execute(
          seleccions[index], seleccions[index].key);

      update(['tareas']);
    }
  }

  Future<void> delete(int key) async {
    await _deleteSeleccionUseCase.execute(key);
    int index = seleccions.indexWhere((element) => element.key == key);
    seleccions.removeAt(index);
  }

  List<int> seleccionados = [];
  List<PreTareaEsparragoGrupoEntity> seleccions = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaSeleccion() async {
    NuevaSeleccionBinding().dependencies();
    final result =
        await Get.to<PreTareaEsparragoGrupoEntity>(() => NuevaSeleccionPage());
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      int key = await _createSeleccionUseCase.execute(result);
      result.key = key;
      seleccions.insert(0, result);
      update(['tareas']);
    }
  }

  Future<void> editarSeleccion(int index) async {
    NuevaSeleccionBinding().dependencies();
    final result = await Get.to<PreTareaEsparragoGrupoEntity>(
        () => NuevaSeleccionPage(),
        arguments: {'tarea': seleccions[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      seleccions[index] = result;
      await _updateSeleccionUseCase.execute(
          seleccions[index], seleccions[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarSeleccion(int index) async {
    NuevaPreTareaBinding().dependencies();
    final result = await Get.to<PreTareaEsparragoGrupoEntity>(
        () => NuevaTareaPage(),
        arguments: {'tarea': seleccions[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      seleccions.add(result);
      await _createSeleccionUseCase.execute(seleccions.last);
      update(['tareas']);
    }
  }

  void goEliminar(int key) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar este Seleccion?',
      'Si',
      'No',
      () async {
        await delete(key);
        update(['tareas']);
        Get.back();
      },
      () => Get.back(),
    );
  }

  void goCopiar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de copiar la siguiente tarea?',
      'Si',
      'No',
      () async {
        Get.back();
        await copiarSeleccion(index);
      },
      () => Get.back(),
    );
  }

  void goEditar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de editar la actividad?',
      'Si',
      'No',
      () async {
        Get.back();
        await editarSeleccion(index);
      },
      () => Get.back(),
    );
  }
}
