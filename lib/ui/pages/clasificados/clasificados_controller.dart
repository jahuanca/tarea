
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_cajas_binding.dart';
import 'package:flutter_tareo/di/listado_personas_clasificacion_binding.dart';
import 'package:flutter_tareo/di/nueva_clasificacion_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/create_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/delete_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/get_all_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/migrar_all_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/update_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/upload_file_of_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_cajas/listado_cajas_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_clasificacion/nueva_clasificacion_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class ClasificadosController extends GetxController {
  final CreateClasificacionUseCase _createClasificacionUseCase;
  final GetAllClasificacionUseCase _getAllClasificacionUseCase;
  final UpdateClasificacionUseCase _updateClasificacionUseCase;
  final DeleteClasificacionUseCase _deleteClasificacionUseCase;
  final MigrarAllClasificacionUseCase _migrarAllPreTareoUseCase;
  final UploadFileOfClasificacionUseCase _uploadFileOfPreTareoUseCase;
  final ExportDataToExcelUseCase _exportDataToExcelUseCase;

  bool validando = false;

  ClasificadosController(
      this._createClasificacionUseCase,
      this._getAllClasificacionUseCase,
      this._updateClasificacionUseCase,
      this._deleteClasificacionUseCase,
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
    clasificados=[];
    clasificados = await _getAllClasificacionUseCase.execute();
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
    await _exportDataToExcelUseCase.execute(clasificados[index]);
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

        clasificados[index].pathUrl = _image.path;
        clasificados[index].estadoLocal = 'A';
        await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareaEsparragoEntity tarea = clasificados[index];
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

  Future<void> goMigrar(int index) async {
    if (clasificados[index].estadoLocal == 'A') {
      //if (true) {
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
    PreTareaEsparragoEntity tareaMigrada =
        await _migrarAllPreTareoUseCase.execute(clasificados[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      clasificados[index].estadoLocal = 'M';
      clasificados[index].itempretareaesparrago= tareaMigrada.itempretareaesparrago;
      await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);
      tareaMigrada = await _uploadFileOfPreTareoUseCase.execute(
          clasificados[index], File(clasificados[index].pathUrl));
      clasificados[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  /* Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPreTareoUseCase.execute(preTareos[index]);
  } */


  Future<void> goListadoCajas(int index) async {
    List<PreTareaEsparragoEntity> otras = [];
    otras.addAll(clasificados);
    otras.removeAt(index);
    ListadoCajasBinding().dependencies();
    final resultado = await Get.to<int>(
        () => ListadoCajasPage(),
        arguments: {
          'otras': otras,
          'tarea': clasificados[index],
          'index': index,
        });

    if (resultado != null) {
      clasificados[index].sizeDetails = resultado;
      await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);
      update(['tareas']);
    }
  }

  Future<void> goListadoPersonas(int index) async {
    List<PreTareaEsparragoEntity> otras = [];
    otras.addAll(clasificados);
    otras.removeAt(index);
    ListadoPersonasClasificacionBinding().dependencies();
    final resultado = await Get.to<int>(
        () => ListadoPersonasClasificacionPage(),
        arguments: {
          'otras': otras,
          'tarea': clasificados[index],
          'index': index,
        });

    if (resultado != null) {
      clasificados[index].sizeDetails = resultado;
      await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);
      update(['tareas']);
    }
  }

  Future<void> delete(int index) async {
    await _deleteClasificacionUseCase.execute(clasificados[index].key);
    clasificados.removeAt(index);
  }

  List<int> seleccionados = [];
  List<PreTareaEsparragoEntity> clasificados = [];

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
    NuevaClasificacionBinding().dependencies();
    final result =
        await Get.to<PreTareaEsparragoEntity>(() => NuevaClasificacionPage());
    if (result != null) {
      clasificados.insert(0, result);
      await _createClasificacionUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaClasificacionBinding().dependencies();
    print(clasificados[index].horafin);
    final result = await Get.to<PreTareaEsparragoEntity>(
        () => NuevaClasificacionPage(),
        arguments: {'tarea': clasificados[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      clasificados[index] = result;
      await _updateClasificacionUseCase.execute(clasificados[index], clasificados[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaClasificacionBinding().dependencies();
    final result = await Get.to<PreTareaEsparragoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': clasificados[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      clasificados.add(result);
      await _createClasificacionUseCase.execute(clasificados.last);
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
