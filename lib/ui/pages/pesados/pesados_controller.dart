
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_personas_pesado_binding.dart';
import 'package:flutter_tareo/di/nueva_pesado_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/create_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/delete_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/get_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/migrar_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pesado/listado_personas_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pesado/nueva_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea/nueva_pre_tarea_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PesadosController extends GetxController {
  final CreatePesadoUseCase _createPesadoUseCase;
  final GetAllPesadoUseCase _getAllPesadoUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;
  final DeletePesadoUseCase _deletePesadoUseCase;
  final MigrarAllPesadoUseCase _migrarAllPesadoUseCase;
  final UploadFileOfPesadoUseCase _uploadFileOfPesadoUseCase;
  final ExportDataToExcelUseCase _exportDataToExcelUseCase;

  bool validando = false;

  PesadosController(
      this._createPesadoUseCase,
      this._getAllPesadoUseCase,
      this._updatePesadoUseCase,
      this._deletePesadoUseCase,
      this._migrarAllPesadoUseCase,
      this._uploadFileOfPesadoUseCase,
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
    pesados=[];
    pesados = await _getAllPesadoUseCase.execute();
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
    await _exportDataToExcelUseCase.execute(pesados[index]);
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

        pesados[index].pathUrl = _image.path;
        pesados[index].estadoLocal = 'A';
        await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareaEsparragoVariosEntity tarea = pesados[index];
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
    if (pesados[index].estadoLocal == 'A') {
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
    PreTareaEsparragoVariosEntity tareaMigrada =
        await _migrarAllPesadoUseCase.execute(pesados[index]);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      pesados[index].estadoLocal = 'M';
      pesados[index].itempretareaesparragosvarios = tareaMigrada.itempretareaesparragosvarios;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
      tareaMigrada = await _uploadFileOfPesadoUseCase.execute(
          pesados[index], File(pesados[index].pathUrl));
      pesados[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  /* Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPesadoUseCase.execute(preTareos[index]);
  } */

  Future<void> goListadoPersonas(int index) async {
    List<PreTareaEsparragoVariosEntity> otras = [];
    otras.addAll(pesados);
    otras.removeAt(index);
    ListadoPersonasPesadoBinding().dependencies();
    final resultados = await Get.to<List<PreTareaEsparragoDetalleVariosEntity>>(
        () => ListadoPersonasPesadoPage(),
        arguments: {
          'otras': otras,
          'tarea': pesados[index],
          'index': index,
        });

    if (resultados != null && resultados.isNotEmpty) {
      pesados[index].detalles = resultados;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
      print(resultados.first.toJson());
      update(['tareas']);
    }
  }

  Future<void> delete(int index) async {
    await _deletePesadoUseCase.execute(pesados[index].key);
    pesados.removeAt(index);
  }

  List<int> seleccionados = [];
  List<PreTareaEsparragoVariosEntity> pesados = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaPesado() async {
    NuevaPesadoBinding().dependencies();
    final result =
        await Get.to<PreTareaEsparragoVariosEntity>(() => NuevaPesadoPage());
    if (result != null) {
      pesados.insert(0, result);
      await _createPesadoUseCase.execute(result);
      update(['tareas']);
    }
  }

  Future<void> editarPesado(int index) async {
    NuevaPreTareaBinding().dependencies();
    print(pesados[index].horafin);
    final result = await Get.to<PreTareaEsparragoVariosEntity>(
        () => NuevaPreTareaPage(),
        arguments: {'tarea': pesados[index]});
    if (result != null) {
      print(result.horafin);
      result.idusuario = PreferenciasUsuario().idUsuario;
      pesados[index] = result;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarPesado(int index) async {
    NuevaPreTareaBinding().dependencies();
    final result = await Get.to<PreTareaEsparragoVariosEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': pesados[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      pesados.add(result);
      await _createPesadoUseCase.execute(pesados.last);
      update(['tareas']);
    }
  }

  void goEliminar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar este pesado?',
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
        await copiarPesado(index);
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
        await editarPesado(index);
      },
      () => Get.back(),
    );
  }
}
