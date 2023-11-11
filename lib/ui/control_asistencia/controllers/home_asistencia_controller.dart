import 'dart:io';

import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/create_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/delete_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/export_asistencia_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/get_all_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/migrar_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/update_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/upload_file_of_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/registro_asistencia/create_registro_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/registro_asistencia/get_all_registro_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/di/control_asistencia/nueva_asistencia_binding.dart';
import 'package:flutter_tareo/ui/control_asistencia/pages/listado_asistencias_page.dart';
import 'package:flutter_tareo/ui/control_asistencia/pages/nueva_asistencia_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

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
  final GetAllRegistroAsistenciaUseCase _getAllRegistroAsistenciaUseCase;
  final CreateRegistroAsistenciaUseCase _createRegistroAsistenciaUseCase;

  HomeAsistenciaController(
    this._createAsistenciaUseCase,
    this._getAllAsistenciaUseCase,
    this._updateAsistenciaUseCase,
    this._deleteAsistenciaUseCase,
    this._migrarAsistenciaUseCase,
    this._uploadFileOfAsistenciaUseCase,
    this._exportAsistenciaToExcelUseCase,
    this._getAllRegistroAsistenciaUseCase,
    this._createRegistroAsistenciaUseCase,
  );

  Future<void> getRegistrosAsistencia() async {
    asistencias = await _getAllAsistenciaUseCase.execute();
    return;
  }

  Future<void> goNuevoRegistro() async {
    NuevaAsistenciaBinding().dependencies();
    final result =
        await Get.to<AsistenciaFechaTurnoEntity>(() => NuevaAsistenciaPage());
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      int id = await _createAsistenciaUseCase.execute(result);
      result.key = id;
      asistencias.add(result);
      update(['registros']);
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
    int index = asistencias.indexWhere((element) => element.key == key);
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
    int index = asistencias.indexWhere((e) => e.key == key);
    if (index == -1) toastError('Error', 'No se pudo eliminar la tarea.');
    await basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar esta asistencia?',
      'Si',
      'No',
      () async {
        await delete(index);
        update(['asistencias']);
        Get.back();
      },
      () => Get.back(),
    );
  }

  Future<void> delete(int index) async {
    await _deleteAsistenciaUseCase.execute(asistencias[index].key);
    asistencias.removeAt(index);
  }

  void goAprobar(int key) async {
    int index = asistencias.indexWhere((element) => element.key == key);
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
        '¿Desea aprobar esta asistencia?',
        'Si',
        'No',
        () async {
          Get.back();
          //await getimageditor(index);
        },
        () => Get.back(),
      );
    }
  }

  Future<String> validarParaAprobar(int index) async {
    AsistenciaFechaTurnoEntity asistencia = asistencias[index];
    if (asistencia.sizeDetails == null || asistencia.sizeDetails == 0) {
      return 'No se puede aprobar una asistencia que no tiene registros';
    } else {
      asistencia.detalles = await _getAllRegistroAsistenciaUseCase
          .execute('personal_asistencia_proceso_${asistencia.key}');
      for (AsistenciaRegistroPersonalEntity item in asistencia?.detalles) {
        /*if(item.validadoParaAprobar!=null){
          return item.validadoParaAprobar;
        }*/
      }
    }
    return null;
  }

  Future<void> goListadoRegistros(int key) async {
    int index = asistencias.indexWhere((e) => e.key == key);
    //ListadoPersonasBinding().dependencies();
    final resultado =
        await Get.to<List<num>>(() => ListadoAsistenciasPage(), arguments: {
      'asistencia': asistencias[index],
      'index': index,
      'turno': asistencias[index].turno
    });

    if (resultado != null) {
      validando = true;
      update(['validando']);
      asistencias[index].sizeDetails = resultado.first;
      //asistencias[index].cantidadAvance = resultado.last;
      //await _updateAsistenciaUseCase.execute(asistencias[index], asistencias[index].key);
      validando = false;
      update(['validando', 'asistencias']);
    }
  }

  void goMigrar(int key) {
    int index = asistencias.indexWhere((element) => element.key == key);
    if (asistencias[index].estadoLocal == 'A') {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea migrar esta asistencia?',
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
        'Esta asistencai aun no ha sido aprobada',
        'Aceptar',
        () => Get.back(),
      );
    }
  }

  Future<void> migrar(int index) async {
    validando = true;
    update(['validando']);
    AsistenciaFechaTurnoEntity asistenciaMigrada =
        await _migrarAsistenciaUseCase.execute(asistencias[index]);
    if (asistenciaMigrada != null) {
      toastExito('Exito', 'Asistencia migrada con exito');
      asistencias[index].estadoLocal = 'M';
      //asistencias[index].itemtareoproceso = asistenciaMigrada.itemtareoproceso;
      await _updateAsistenciaUseCase.execute(
          asistencias[index], asistencias[index].key);
      asistenciaMigrada = await _uploadFileOfAsistenciaUseCase.execute(
          asistencias[index], File(asistencias[index].pathUrl));
      asistencias[index].firmaSupervisor = asistenciaMigrada?.firmaSupervisor;
      await _updateAsistenciaUseCase.execute(
          asistencias[index], asistencias[index].key);
    }
    validando = false;

    update(['validando', 'asistencias']);
  }

  void goEditar(int key) {
    int index = asistencias.indexWhere((element) => element.key == key);
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de editar la siguiente tarea?',
      'Si',
      'No',
      () async {
        Get.back();
        await editarAsistencia(index);
      },
      () => Get.back(),
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
          asistencias[index], asistencias[index].key);
      update(['asistencias']);
    }
  }
}
