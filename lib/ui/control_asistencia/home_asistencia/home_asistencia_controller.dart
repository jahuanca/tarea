import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/control_asistencia/listado_asistencia_registro_binding.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/create_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/delete_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/export_asistencia_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/get_all_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/migrar_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/update_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/upload_file_of_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/get_all_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/di/control_asistencia/nueva_asistencia_binding.dart';
import 'package:flutter_tareo/ui/control_asistencia/listado_asistencia_registro/listado_asistencia_registro_page.dart';
import 'package:flutter_tareo/ui/control_asistencia/nueva_asistencia/nueva_asistencia_page.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class HomeAsistenciaController extends GetxController {
  List<int> seleccionados = [];
  List<AsistenciaFechaTurnoEntity> asistencias = [];

  bool validando = false;

  final CreateAsistenciaUseCase _createAsistenciaUseCase;
  final GetAllAsistenciaUseCase _getAllAsistenciaUseCase;
  final UpdateAsistenciaUseCase _updateAsistenciaUseCase;
  final DeleteAsistenciaUseCase _deleteAsistenciaUseCase;
  final MigrarAsistenciaUseCase _migrarAsistenciaUseCase;
  final UploadFileOfAsistenciaUseCase _uploadFileOfAsistenciaUseCase;
  final ExportAsistenciaToExcelUseCase _exportAsistenciaToExcelUseCase;
  final GetAllAsistenciaRegistroUseCase _getAllRegistroAsistenciaUseCase;

  HomeAsistenciaController(
      this._createAsistenciaUseCase,
      this._getAllAsistenciaUseCase,
      this._updateAsistenciaUseCase,
      this._deleteAsistenciaUseCase,
      this._migrarAsistenciaUseCase,
      this._uploadFileOfAsistenciaUseCase,
      this._exportAsistenciaToExcelUseCase,
      this._getAllRegistroAsistenciaUseCase);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    await getAsistencias();
    super.onReady();
  }

  Future<void> getAsistencias() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    asistencias = await _getAllAsistenciaUseCase.execute();
    validando = BOOLEAN_FALSE_VALUE;
    update([LISTADO_ASISTENCIAS_ID, VALIDANDO_ID]);
    return;
  }

  Future<void> goNuevoRegistro() async {
    NuevaAsistenciaBinding().dependencies();
    final result =
        await Get.to<AsistenciaFechaTurnoEntity>(() => NuevaAsistenciaPage());
    if (result != null) {
      validando = BOOLEAN_TRUE_VALUE;
      update([VALIDANDO_ID]);
      result.idusuario = PreferenciasUsuario().idUsuario;
      result.setId = await _createAsistenciaUseCase.execute(result);
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
      asistencias.insert(ZERO_INT_VALUE, result);
      update([LISTADO_ASISTENCIAS_ID]);
    }
  }

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  void onChangedMenu(dynamic value, int key) async {
    asistencias.indexWhere((element) => element.getId == key);
    switch (value.toInt()) {
      case 1:
        await _exportAsistenciaToExcelUseCase.execute(key);
        break;
      case 2:
        break;
      case 3:
        goEliminar(key);
        break;
      default:
        break;
    }
  }

  Future<void> goEliminar(int key) async {
    int index = asistencias.indexWhere((e) => e.getId == key);
    if (index == -1)
      toast(type: TypeToast.ERROR, message: 'No se pudo eliminar la tarea.');

    bool result = await basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de eliminar esta asistencia?',
      onPressed: () async {
        Get.back(result: BOOLEAN_TRUE_VALUE);
      },
      onCancel: () => Get.back(result: BOOLEAN_FALSE_VALUE),
    );
    if (result) {
      validando = BOOLEAN_TRUE_VALUE;
      update([VALIDANDO_ID]);
      await delete(index);
      update([LISTADO_ASISTENCIAS_ID]);
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
    }
  }

  Future<void> delete(int index) async {
    await _deleteAsistenciaUseCase.execute(asistencias[index].getId);
    asistencias.removeAt(index);
  }

  void goAprobar(int key) async {
    int index = asistencias.indexWhere((element) => element.getId == key);
    String mensaje = await validarParaAprobar(index);
    if (mensaje != null) {
      basicAlert(
        context: Get.overlayContext,
        message: mensaje,
        onPressed: () => Get.back(),
      );
    } else {
      basicDialog(
        context: Get.overlayContext,
        message: '¿Desea aprobar esta asistencia?',
        onPressed: () async {
          Get.back();
          await getimageditor(index);
        },
        onCancel: () => Get.back(),
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

        asistencias[index].pathUrl = _image.path;
        asistencias[index].estadoLocal = 'A';
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        await _updateAsistenciaUseCase.execute(
            asistencias[index], asistencias[index].getId);
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        update([SELECCIONADO_ID]);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    AsistenciaFechaTurnoEntity asistencia = asistencias[index];
    if (asistencia.sizeDetails == null || asistencia.sizeDetails == 0) {
      return 'No se puede aprobar una asistencia que no tiene registros';
    } else {
      asistencia.detalles =
          await _getAllRegistroAsistenciaUseCase.execute(asistencia.getId);
      /*for (AsistenciaRegistroPersonalEntity item in asistencia?.detalles) {
        if(item.validadoParaAprobar!=null){
          return item.validadoParaAprobar;
        }
      }*/
    }
    return null;
  }

  Future<void> goListadoRegistrosAsistencias(int key) async {
    int index = asistencias.indexWhere((e) => e.getId == key);
    ListadoAsistenciaRegistroBinding().dependencies();
    final resultado =
        await Get.to<int>(() => ListadoRegistroAsistenciaPage(), arguments: {
      'asistencia': asistencias[index],
    });

    if (resultado != null) {
      validando = true;
      update([VALIDANDO_ID]);
      asistencias[index].sizeDetails = resultado;
      //await _updateAsistenciaUseCase.execute(asistencias[index], asistencias[index].getId);
      validando = false;
      update(['validando', LISTADO_ASISTENCIAS_ID]);
    }
  }

  void goMigrar(int key) {
    int index = asistencias.indexWhere((element) => element.getId == key);
    if (asistencias[index].estadoLocal == 'A') {
      basicDialog(
        context: Get.overlayContext,
        message: '¿Desea migrar esta asistencia?',
        onPressed: () async {
          Get.back();
          await migrar(index);
        },
        onCancel: () => Get.back(),
      );
    } else {
      basicAlert(
        context: Get.overlayContext,
        message: 'Esta asistencia aun no ha sido aprobada',
        onPressed: () => Get.back(),
      );
    }
  }

  Future<void> migrar(int index) async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    AsistenciaFechaTurnoEntity asistenciaMigrada =
        await _migrarAsistenciaUseCase.execute(asistencias[index]);
    if (asistenciaMigrada != null) {
      toast(type: TypeToast.SUCCESS, message: 'Asistencia migrada con exito');
      asistencias[index].estadoLocal = 'M';
      asistencias[index].idasistenciaturno =
          asistenciaMigrada.idasistenciaturno;
      await _updateAsistenciaUseCase.execute(
          asistencias[index], asistencias[index].getId);
      asistenciaMigrada = await _uploadFileOfAsistenciaUseCase.execute(
          asistencias[index], File(asistencias[index].pathUrl));
      asistencias[index].firmaSupervisor = asistenciaMigrada?.firmaSupervisor;
      await _updateAsistenciaUseCase.execute(
          asistencias[index], asistencias[index].getId);
    }
    validando = BOOLEAN_FALSE_VALUE;

    update([VALIDANDO_ID, LISTADO_ASISTENCIAS_ID]);
  }

  void goEditar(int key) {
    int index = asistencias.indexWhere((element) => element.getId == key);
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de editar la siguiente tarea?',
      onPressed: () async {
        Get.back();
        await editarAsistencia(index);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> editarAsistencia(int index) async {
    NuevaAsistenciaBinding().dependencies();
    final result = await Get.to<AsistenciaFechaTurnoEntity>(
        () => NuevaAsistenciaPage(),
        arguments: {'asistencia': asistencias[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      asistencias[index] = result;
      await _updateAsistenciaUseCase.execute(
          asistencias[index], asistencias[index].getId);
      update([LISTADO_ASISTENCIAS_ID]);
    }
  }
}
