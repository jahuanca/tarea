import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_personas_pre_tareo_uva_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_uva_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_packing_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/create_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/delete_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/get_all_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/migrar_all_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/update_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/upload_file_of_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo_uva/listado_personas_pre_tareo_uva_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea_uva/nueva_pre_tarea_uva_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PreTareosUvaController extends GetxController {
  final CreatePreTareoProcesoUvaUseCase _createPreTareoProcesoUvaUseCase;
  final GetAllPreTareoProcesoUvaUseCase _getAllPreTareoProcesoUvaUseCase;
  final UpdatePreTareoProcesoUvaUseCase _updatePreTareoProcesoUvaUseCase;
  final DeletePreTareoProcesoUvaUseCase _deletePreTareoProcesoUvaUseCase;
  final MigrarAllPreTareoUvaUseCase _migrarAllPreTareoUvaUseCase;
  final UploadFileOfPreTareoUvaUseCase _uploadFileOfPreTareoUvaUseCase;
  final ExportPackingToExcelUseCase _exportPackingToExcelUseCase;

  bool validando = false;

  PreTareosUvaController(
    this._createPreTareoProcesoUvaUseCase,
    this._getAllPreTareoProcesoUvaUseCase,
    this._updatePreTareoProcesoUvaUseCase,
    this._deletePreTareoProcesoUvaUseCase,
    this._migrarAllPreTareoUvaUseCase,
    this._uploadFileOfPreTareoUvaUseCase,
    this._exportPackingToExcelUseCase,
  );

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
    preTareosUva = await _getAllPreTareoProcesoUvaUseCase.execute();
    update(['tareas']);
    return;
  }

  Future<void> onChangedMenu(dynamic value, int index) async {
    switch (value.toInt()) {
      case 1:
        break;
      case 2:
        goCopiar(index);
        break;
      case 3:
        goEliminar(index);
        break;
      case 4:
        await goExcel(index);
        break;
      default:
        break;
    }
  }

  Future<void> goExcel(int index) async {
    validando = true;
    update(['validando']);
    await _exportPackingToExcelUseCase.execute(preTareosUva[index].key);
    validando = false;
    update(['validando']);
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

        preTareosUva[index].pathUrl = _image.path;
        preTareosUva[index].estadoLocal = 'A';
        await _updatePreTareoProcesoUvaUseCase.execute(
            preTareosUva[index], preTareosUva[index].key);
        update(['seleccionado', 'tareas']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareoProcesoUvaEntity tarea = preTareosUva[index];
    if (tarea.sizeDetails == null || tarea.sizeDetails == 0) {
      return 'No se puede aprobar una actividad que no tiene personal';
    }
    /*  else {
      for (var item in tarea.detalles) {
        if (!item.validadoParaAprobar) {
          return 'Verifique que todos los datos del personal esten llenos';
        }
      }
    } */
    return null;
  }

  Future<void> goMigrar(int index) async {
    if (preTareosUva[index].estadoLocal == 'A') {
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
    PreTareoProcesoUvaEntity tareaMigrada =
        await _migrarAllPreTareoUvaUseCase.execute(preTareosUva[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      preTareosUva[index].estadoLocal = 'M';
      preTareosUva[index].itempretareaprocesouva =
          tareaMigrada.itempretareaprocesouva;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
      tareaMigrada = await _uploadFileOfPreTareoUvaUseCase.execute(
          preTareosUva[index], File(preTareosUva[index].pathUrl));
      preTareosUva[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  /* Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPreTareoUseCase.execute(preTareos[index]);
  } */

  Future<void> goListadoPersonas(int index) async {
    List<PreTareoProcesoUvaEntity> otras = [];
    otras.addAll(preTareosUva);
    otras.removeAt(index);
    ListadoPersonasPreTareoUvaBinding().dependencies();
    final resultado =
        await Get.to<int>(() => ListadoPersonasPreTareoUvaPage(), arguments: {
      'otras': otras,
      'tarea': preTareosUva[index],
      'index': index,
    });

    if (resultado != null) {
      preTareosUva[index].sizeDetails = resultado;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
    }
    update(['tareas']);
  }

  Future<void> delete(int index) async {
    await _deletePreTareoProcesoUvaUseCase.execute(preTareosUva[index].key);
    preTareosUva.removeAt(index);
  }

  List<int> seleccionados = [];
  List<PreTareoProcesoUvaEntity> preTareosUva = [];

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
    NuevaPreTareaUvaBinding().dependencies();
    final result =
        await Get.to<PreTareoProcesoUvaEntity>(() => NuevaPreTareaUvaPage());
    if (result != null) {
      int id = await _createPreTareoProcesoUvaUseCase.execute(result);
      result.key = id;
      preTareosUva.insert(0, result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaPreTareaUvaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoUvaEntity>(
        () => NuevaPreTareaUvaPage(),
        arguments: {'tarea': preTareosUva[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      preTareosUva[index] = result;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaPreTareaUvaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoUvaEntity>(
        () => NuevaPreTareaUvaPage(),
        arguments: {'tarea': preTareosUva[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      int id = await _createPreTareoProcesoUvaUseCase.execute(result);
      result.key = id;
      preTareosUva.add(result);
      update(['tareas']);
    }
  }

  void goEliminar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar esta tarea?',
      'Si',
      'No',
      () async {
        await delete(index);
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
        await copiarTarea(index);
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
        await editarTarea(index);
      },
      () => Get.back(),
    );
  }
}
