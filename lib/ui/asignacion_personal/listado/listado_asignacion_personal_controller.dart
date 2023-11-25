import 'dart:async';
import 'dart:io';

import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/get_all_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/contants.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/GetxScannerController.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class ListadoAsignacionPersonalController extends GetxScannerController {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<EsparragoAgrupaPersonalDetalleEntity> registrosSeleccionados = [];
  EsparragoAgrupaPersonalEntity asignacion;

  bool validando = BOOLEAN_FALSE_VALUE;
  bool editando = BOOLEAN_FALSE_VALUE;
  bool buscando = BOOLEAN_FALSE_VALUE;

  final GetAllPersonalAsignacionUseCase _getAllPersonalAsignacionUse;

  ListadoAsignacionPersonalController(
    this._getAllPersonalAsignacionUse,
    /*this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getAllAsistenciaRegistroUseCase,
    this._deleteAsistenciaRegistroUseCase,
    this._registrarAsistenciaRegistroUseCase,*/
  );

  Future<void> getDetalles() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    registrosSeleccionados.addAll(await _getAllPersonalAsignacionUse
        .execute(asignacion?.itemagruparpersonal));
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    update(['personal_seleccionado']);
  }

  @override
  void onReady() async {
    super.onReady();
    if (Get.arguments != null) {
      if (Get.arguments['asignacion'] != null) {
        print('asignacion');
        asignacion =
            Get.arguments['asignacion'] as EsparragoAgrupaPersonalEntity;
        getDetalles();
      }
      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      } else {
        await _getAll();
        update([VALIDANDO_ID]);
      }
    }
  }

  Future<void> _getAll() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);

    /*personal = await _getPersonalsEmpresaBySubdivisionUseCase
        .execute(PreferenciasUsuario().idSede);*/
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    update(['personal_seleccionado']);
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

  Future<bool> onWillPop() async {
    Get.back(result: registrosSeleccionados.length);
    return true;
  }

  Future<void> changeOptionsGlobal(dynamic index) async {
    switch (index) {
      case 1:
        seleccionados.clear();
        for (var i = 0; i < registrosSeleccionados.length; i++) {
          seleccionados.add(i);
        }
        update(['seleccionados', 'personal_seleccionado']);
        break;
      case 2:
        seleccionados.clear();
        update(['seleccionados', 'personal_seleccionado']);
        break;
      default:
        break;
    }
  }

  Future<void> changeOptions(dynamic index, int key) async {
    switch (index) {
      case 2:
        goEliminar(key);
        break;
      default:
        break;
    }
  }

  Future<void> goEliminar(int key) async {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Desea eliminar el registro?',
      onPressed: () async {
        Get.back();
        //registrosSeleccionados.removeWhere((e) => e.getId == key);
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        //await _deleteAsistenciaRegistroUseCase.execute(asignacion.getId, key);
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> _registrar(
      AsistenciaRegistroPersonalEntity detalle, bool byLector) async {
    /*final res = await _registrarAsistenciaRegistroUseCase.execute(detalle);
    if (res is Success) {
      AsistenciaRegistroPersonalEntity d = res.data;
      String message = '';
      if (d.tipomovimiento == 'I') {
        detalle.idasistencia = d.idasistencia;
        detalle.horaentrada = d.horaentrada;
        detalle.fechaentrada = d.fechaentrada;
        message = 'Se ha creado un ingreso';
        registrosSeleccionados.insert(ZERO_INT_VALUE, detalle);
        update([LISTADO_ASISTENCIA_REGISTRO_ID, CONTADOR_ID]);
      } else {
        message = 'Se ha generado una salida';
        int index = registrosSeleccionados
            .indexWhere((e) => e.idasistencia == d.idasistencia);
        registrosSeleccionados[index].horasalida = d.horasalida;
        update([LISTADO_ASISTENCIA_REGISTRO_ID, CONTADOR_ID]);
      }
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
      byLector
          ? toast(type: TypeToast.SUCCESS, message: message)
          : showNotification(BOOLEAN_TRUE_VALUE, message);
      ;
    } else {
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
      byLector
          ? toast(
              type: TypeToast.ERROR,
              message: (res.error as MessageEntity).message)
          : showNotification(
              BOOLEAN_FALSE_VALUE, (res.error as MessageEntity).message);
    }*/
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
  }

  @override
  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    if (barcode != null && barcode != '-1' && buscando == BOOLEAN_FALSE_VALUE) {
      buscando = BOOLEAN_TRUE_VALUE;

      /** */
      int index = personal.indexWhere(
          (e) => e.nrodocumento.trim() == barcode.toString().trim());
      if (index != -1) {
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        await _registrar(
            AsistenciaRegistroPersonalEntity(
              personal: personal[index],
              codigoempresa: personal[index].codigoempresa,
              fechamod: DateTime.now(),
              fechaturno: asignacion.fecha,
              idusuario: PreferenciasUsuario().idUsuario,
            ),
            byLector);
      }
      (!byLector)
          ? await sleep(WAITING_INTERVAL_CAMERA)
          : await sleep(WAITING_INTERVAL_PDA);
      buscando = BOOLEAN_FALSE_VALUE;
      /** */
      return;
    }
  }
}
