import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/asignacion_personal/listado_asignacion_personal_binding.dart';
import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/buscar_linea_mesa/get_linea_mesa_use_case.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
import 'package:flutter_tareo/ui/asignacion_personal/listado/listado_asignacion_personal_page.dart';
import 'package:flutter_tareo/ui/asignacion_personal/utils/constants.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_tareo/ui/utils/extensions.dart';

class BuscarLineaMesaController extends GetxController {
  String errorFecha, errorUbicacion, errorTurno, errorLinea, errorMesa;

  List<TurnoEntity> turnos = [
    TurnoEntity(idturno: 1, turno: 'D'),
    TurnoEntity(idturno: 2, turno: 'N'),
  ];

  List<EsparragoAgrupaPersonalEntity> lineas = [];

  List<EsparragoAgrupaPersonalEntity> mesas = [];

  DateTime fecha = new DateTime.now();
  bool validando = false;

  BuscarLineaMesaEntity query = new BuscarLineaMesaEntity();
  EsparragoAgrupaPersonalEntity asignacionSelected;

  GetLineaMesaUseCase _getLineaMesaUseCase;

  BuscarLineaMesaController(
    this._getLineaMesaUseCase,
  );

  @override
  void onInit() {
    changeFecha();
    super.onInit();
  }

  void changeFecha() {
    query.fecha = fecha;
    errorFecha = (query.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  Future<void> changeTurno(String id) async {
    errorTurno = validatorUtilText(id, TURNO_LABEL, {
      'required': '',
    });
    int index = turnos?.indexWhere((e) => e.idturno.toString().trim() == id);

    if (errorTurno == null && index != -1) {
      query.turno = turnos[index].turno;
      await getLineaMesa();
    } else {
      query.turno = null;
    }

    update([TURNOS_ID]);
  }

  Future<void> changeLinea(String id) async {
    errorLinea = validatorUtilText(id, LINEAS_LABEL, {
      'required': '',
    });
    int index = lineas?.indexWhere((e) => e.linea.toString().trim() == id);

    if (errorLinea == null && index != -1) {
      query.linea = lineas[index].linea;
      await getLineaMesa(isMesa: BOOLEAN_TRUE_VALUE);
    } else {
      query.linea = null;
    }

    update([LINEAS_ID]);
  }

  Future<void> changeMesa(String id) async {
    errorMesa = validatorUtilText(id, MESAS_LABEL, {
      'required': '',
    });
    int index = mesas?.indexWhere((e) => e.grupo.toString().trim() == id);

    if (errorMesa == null && index != -1) {
      query.grupo = mesas[index].grupo;
      asignacionSelected = mesas[index];
    } else {
      query.grupo = null;
      asignacionSelected = null;
    }

    update([MESAS_ID]);
  }

  Future<void> getLineaMesa({bool isMesa = BOOLEAN_FALSE_VALUE}) async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    if (!isMesa) {
      lineas = (await _getLineaMesaUseCase.execute(query))
          .toList()
          .unique((EsparragoAgrupaPersonalEntity x) => x.linea);
      mesas = [];
      update([LINEAS_ID, MESAS_ID]);
    } else {
      mesas = (await _getLineaMesaUseCase.execute(query)).toList();
      update([MESAS_ID]);
    }
    validando = BOOLEAN_FALSE_VALUE;
    update([
      VALIDANDO_ID,
    ]);
  }

  Future<void> goListadoAsignacionPersonal() async {
    ListadoAsignacionPersonalBinding().dependencies();
    Get.to(() => ListadoAsignacionPersonalPage(),
        arguments: {'asignacion': asignacionSelected});
  }
}
