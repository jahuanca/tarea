import 'dart:async';
import 'dart:io';

import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/add_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/delete_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/get_all_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
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
  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;

  bool validando = BOOLEAN_FALSE_VALUE;
  bool editando = BOOLEAN_FALSE_VALUE;
  bool buscando = BOOLEAN_FALSE_VALUE;

  final GetAllPersonalAsignacionUseCase _getAllPersonalAsignacionUse;
  final AddPersonalAsignacionUseCase _addPersonalAsignacionUseCase;
  final DeletePersonalAsignacionUseCase _deletePersonalAsignacionUseCase;

  ListadoAsignacionPersonalController(
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._getAllPersonalAsignacionUse,
    this._addPersonalAsignacionUseCase,
    this._deletePersonalAsignacionUseCase,
  );

  Future<void> _getAll() async {
    personal = await _getPersonalsEmpresaBySubdivisionUseCase
        .execute(PreferenciasUsuario().idSede);
    /*print('Personal ${personal.length}');
    print(personal.first.nrodocumento);
    print(personal[1].nrodocumento);
    print(personal[2].nrodocumento);
    print(personal[3].nrodocumento);
    print(personal.last.nrodocumento);*/
  }

  Future<void> getDetalles() async {
    print('buscando');
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    registrosSeleccionados.clear();
    registrosSeleccionados.addAll(await _getAllPersonalAsignacionUse
        .execute(asignacion?.itemagruparpersonal));
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    update([PERSONAL_SELECCIONADO_ID]);
  }

  @override
  void onInit() async {
    if (Get.arguments != null) {
      if (Get.arguments['asignacion'] != null) {
        print('asignacion');
        asignacion =
            Get.arguments['asignacion'] as EsparragoAgrupaPersonalEntity;
        await _getAll();
        await getDetalles();
      }
    }
    super.onInit();
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
        update(['seleccionados', PERSONAL_SELECCIONADO_ID]);
        break;
      case 2:
        seleccionados.clear();
        update([SELECCIONADO_ID, PERSONAL_SELECCIONADO_ID]);
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
        registrosSeleccionados.removeWhere((e) => e.getId == key);
        validando = BOOLEAN_TRUE_VALUE;
        update([VALIDANDO_ID]);
        await _deletePersonalAsignacionUseCase.execute(key);
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        update(['seleccionados', 'personal_seleccionado']);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> _registrar(
      EsparragoAgrupaPersonalDetalleEntity detalle, bool byLector) async {
    final res =
        await _addPersonalAsignacionUseCase.execute(asignacion, detalle);
    if (res is Success) {
      EsparragoAgrupaPersonalDetalleEntity d = res.data;
      detalle.setId = d.getId;
      detalle.personal = d.personal;
      detalle.codigoempresa = d.codigoempresa;
      /*detalle.horaentrada = d.horaentrada;
      detalle.fechaentrada = d.fechaentrada;*/
      registrosSeleccionados.insert(ZERO_INT_VALUE, detalle);
      update([LISTADO_ASISTENCIA_REGISTRO_ID, CONTADOR_ID]);

      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
      _showNotification(
          byLector: byLector,
          isSuccess: BOOLEAN_TRUE_VALUE,
          message: 'Registro exitoso.');
    } else {
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
      _showNotification(
          byLector: byLector,
          isSuccess: BOOLEAN_FALSE_VALUE,
          message: (res.error as MessageEntity).message);
    }
  }

  Future<void> _showNotification(
      {bool byLector = BOOLEAN_TRUE_VALUE,
      bool isSuccess,
      String message}) async {
    if (byLector) {
      super.showToast(isSuccess, message);
    } else {
      super.showNotification(isSuccess, message);
    }
  }

  @override
  Future<void> setCodeBar(dynamic barcode, [bool byLector = false]) async {
    print(barcode);
    if (barcode != null && barcode != '-1' && buscando == BOOLEAN_FALSE_VALUE) {
      buscando = BOOLEAN_TRUE_VALUE;
      validando = BOOLEAN_TRUE_VALUE;
      update([VALIDANDO_ID]);
      int index = personal.indexWhere(
          (e) => e.nrodocumento.trim() == barcode.toString().trim());
      if (index != -1) {
        await _registrar(
            EsparragoAgrupaPersonalDetalleEntity(
                itemagruparpersonal: asignacion.itemagruparpersonal,
                documento: barcode.toString().trim(),
                codigoempresa: personal[index].codigoempresa,
                fechamod: DateTime.now(),
                idusuario: PreferenciasUsuario().idUsuario,
                linea: asignacion.linea,
                grupo: asignacion.grupo,
                turno: asignacion.turno,
                fecha: asignacion.fecha,
                estado: 'A'),
            byLector);
      } else {
        validando = BOOLEAN_FALSE_VALUE;
        update([VALIDANDO_ID]);
        _showNotification(
            byLector: byLector,
            isSuccess: BOOLEAN_FALSE_VALUE,
            message: 'Personal no se encuentra en esta subdivision');
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
