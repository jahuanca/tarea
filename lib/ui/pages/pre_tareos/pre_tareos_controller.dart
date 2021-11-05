
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_personas_pre_tareo_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/create_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/delete_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/get_all_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/migrar_all_pre_tareo_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo/listado_personas_pre_tareo_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea/nueva_pre_tarea_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PreTareosController extends GetxController {
  final CreatePreTareoProcesoUseCase _createPreTareoProcesoUseCase;
  final GetAllPreTareoProcesoUseCase _getAllPreTareoProcesoUseCase;
  final UpdatePreTareoProcesoUseCase _updatePreTareoProcesoUseCase;
  final DeletePreTareoProcesoUseCase _deletePreTareoProcesoUseCase;
  final MigrarAllPreTareoUseCase _migrarAllPreTareoUseCase;
  final UploadFileOfPreTareoUseCase _uploadFileOfPreTareoUseCase;
  final ExportDataToExcelUseCase _exportDataToExcelUseCase;

  bool validando = false;

  PreTareosController(
      this._createPreTareoProcesoUseCase,
      this._getAllPreTareoProcesoUseCase,
      this._updatePreTareoProcesoUseCase,
      this._deletePreTareoProcesoUseCase,
      this._migrarAllPreTareoUseCase,
      this._uploadFileOfPreTareoUseCase,
      this._exportDataToExcelUseCase);

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
    preTareos=[];
    preTareos = await _getAllPreTareoProcesoUseCase.execute();
    update(['tareas']);
    return;
  }

  void onChangedMenu(dynamic value, int index) async {
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
        goExcel(index);
        break;
      default:
        break;
    }
  }

  void goExcel(int index) async {
    await _exportDataToExcelUseCase.execute(preTareos[index]);
    print('exportando');
  }

  void goAprobar(int index) async {
    String mensaje = await validarParaAprobar(index);
    if (mensaje != null) {
      basicAlert(
        Get.overlayContext,
        'Alerta',
        mensaje,
        'Aceptar',
        () => Get.back(),
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

        preTareos[index].pathUrl = _image.path;
        preTareos[index].estadoLocal = 'A';
        await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareoProcesoEntity tarea = preTareos[index];
    if (tarea.detalles == null || tarea.detalles.isEmpty) {
      return 'No se puede aprobar una actividad que no tiene personal';
    } else {
      for (var item in tarea.detalles) {
        if (!item.validadoParaAprobar) {
          return 'Verifique que todos los datos del personal esten llenos';
        }
      }
    }
    return null;
  }

  Future<void> goMigrar(int index) async {
    if (preTareos[index].estadoLocal == 'A') {
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
    PreTareoProcesoEntity tareaMigrada =
        await _migrarAllPreTareoUseCase.execute(preTareos[index]);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      preTareos[index].estadoLocal = 'M';
      preTareos[index].itempretareaproceso = tareaMigrada.itempretareaproceso;
      await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);
      tareaMigrada = await _uploadFileOfPreTareoUseCase.execute(
          preTareos[index], File(preTareos[index].pathUrl));
      preTareos[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  /* Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPreTareoUseCase.execute(preTareos[index]);
  } */

  Future<void> goListadoPersonas(int index) async {
    List<PreTareoProcesoEntity> otras = [];
    otras.addAll(preTareos);
    otras.removeAt(index);
    ListadoPersonasPreTareoBinding().dependencies();
    final resultados = await Get.to<List<PreTareoProcesoDetalleEntity>>(
        () => ListadoPersonasPreTareoPage(),
        arguments: {
          'otras': otras,
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
    final result =
        await Get.to<PreTareoProcesoEntity>(() => NuevaPreTareaPage());
    if (result != null) {
      preTareos.insert(0, result);
      await _createPreTareoProcesoUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaPreTareaBinding().dependencies();
    print(preTareos[index].horafin);
    final result = await Get.to<PreTareoProcesoEntity>(
        () => NuevaPreTareaPage(),
        arguments: {'tarea': preTareos[index]});
    if (result != null) {
      print(result.horafin);
      result.idusuario = PreferenciasUsuario().idUsuario;
      preTareos[index] = result;
      await _updatePreTareoProcesoUseCase.execute(preTareos[index], index);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaPreTareaBinding().dependencies();
    final result = await Get.to<PreTareoProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': preTareos[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      preTareos.add(result);
      await _createPreTareoProcesoUseCase.execute(preTareos.last);
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
