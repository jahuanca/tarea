import 'package:flutter_tareo/domain/control_asistencia/use_cases/turno/get_all_turnos_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/ubicacion/get_all_ubicacions_use_case.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaAsistenciaController extends GetxController {
  GetAllTurnosUseCase _getAllTurnosUseCase;
  GetAllUbicacionsUseCase _getAllUbicacionsUseCase;

  DateTime fecha = new DateTime.now();
  String errorTurno, errorUbicacion, errorFecha;

  AsistenciaFechaTurnoEntity nuevaAsistencia;

  bool validando = false, editando = false, firstTime = true, copiando = false;

  List<AsistenciaUbicacionEntity> ubicacions = [];
  List<TurnoEntity> turnos = [];

  NuevaAsistenciaController(
      this._getAllUbicacionsUseCase, this._getAllTurnosUseCase);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['asistencia'] != null) {
        editando = true;
        firstTime = true;
        nuevaAsistencia = AsistenciaFechaTurnoEntity.fromJson(
            (Get.arguments['asistencia'] as AsistenciaFechaTurnoEntity)
                .toJson());
        fecha = nuevaAsistencia.fecha;
        if (Get.arguments['copiando'] != null) {
          copiando = true;
          update([
            'editando',
          ]);
        }
      }
    }
    if (nuevaAsistencia == null) {
      nuevaAsistencia = new AsistenciaFechaTurnoEntity();
      //nuevaAsistencia.fechamod = fecha;
      nuevaAsistencia.idestado = 1;
    }
  }

  void setEditValues() {
    if (editando) update(['editando']);
  }

  @override
  void onReady() async {
    super.onReady();
    validando = true;
    update(['validando']);
    await getUbicacions();
    await getTurnos();
    validando = false;
    update(['validando']);

    setEditValues();
    firstTime = false;
  }

  Future<void> getTurnos() async {
    turnos = await _getAllTurnosUseCase.execute();
    if (turnos.isNotEmpty) {
      await changeTurno(editando && firstTime
          ? nuevaAsistencia.idturno.toString() ?? '${turnos.first.idturno}'
          : '${turnos.first.idturno}');
    }
    update([TURNOS_ID]);
  }

  Future<void> getUbicacions() async {
    ubicacions = await _getAllUbicacionsUseCase.execute();
    if (ubicacions.isNotEmpty) {
      await changeUbicacion(editando && firstTime
          ? nuevaAsistencia.idubicacion.toString() ??
              '${ubicacions.first.idubicacion}'
          : '${ubicacions.first.idubicacion}');
    }
    update([UBICACIONS_ID]);
  }

  void mostrarDialog(String mensaje) {
    basicAlert(
      context: Get.overlayContext,
      message: mensaje,
      onPressed: () => Get.back(),
    );
  }

  void changeFecha() {
    nuevaAsistencia.fecha = fecha;
    errorFecha = (nuevaAsistencia.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeUbicacion(String id) {
    errorUbicacion = validatorUtilText(id, UBICACION_LABEL, {
      'required': '',
    });
    int index = ubicacions.indexWhere((e) => e.idubicacion == int.parse(id));
    if (errorUbicacion == null && index != -1) {
      nuevaAsistencia.ubicacion = ubicacions[index];
      nuevaAsistencia.idubicacion = int.parse(id);
    } else {
      nuevaAsistencia.ubicacion = null;
      nuevaAsistencia.idubicacion = null;
    }
    update(['ubicacion']);
  }

  Future<void> changeTurno(String id) async {
    errorTurno = validatorUtilText(id, TURNO_LABEL, {
      'required': '',
    });
    int index = turnos?.indexWhere((e) => e.idturno.toString().trim() == id);

    if (errorTurno == null && index != -1) {
      nuevaAsistencia.turno = turnos[index];
      nuevaAsistencia.idturno = nuevaAsistencia.turno.idturno;
    } else {
      nuevaAsistencia.turno = null;
      nuevaAsistencia.idturno = null;
    }
    update(['turnos']);
  }

  Future<void> goBack() async {
    String mensaje = await validar();
    if (mensaje == null) {
      nuevaAsistencia.idusuario = PreferenciasUsuario().idUsuario;
      nuevaAsistencia.estadoLocal = 'P';
      nuevaAsistencia.fechamod = new DateTime.now();
      Get.back(result: nuevaAsistencia);
    } else {
      toastError('Error', mensaje);
    }
  }

  Future<String> validar() async {
    changeFecha();
    await changeTurno(nuevaAsistencia.idturno.toString());
    await changeUbicacion(nuevaAsistencia.idubicacion.toString());
    if (errorTurno != null) return errorTurno;
    if (errorUbicacion != null) return errorUbicacion;
    if (errorFecha != null) return errorFecha;

    return null;
  }
}
