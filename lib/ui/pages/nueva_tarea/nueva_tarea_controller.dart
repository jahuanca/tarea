import 'dart:developer';

import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaTareaController extends GetxController {
  GetActividadsByKeyUseCase _getActividadsByKeyUseCase;
  GetLaborsByKeyUseCase _getLaborsByKeyUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;

  GetPersonalsEmpresaUseCase _getPersonalsEmpresaUseCase;

  GetCentroCostosByKeyUseCase _getCentroCostosByKeyUseCase;

  DateTime fecha = new DateTime.now();
  String errorActividad,
      errorLabor,
      errorCentroCosto,
      errorSupervisor,
      errorDigitador,
      errorHoraInicio,
      errorHoraFin,
      errorFecha,
      errorPausaInicio,
      errorPausaFin;

  TareaProcesoEntity nuevaTarea;

  bool validando = false, editando = false, firstTime = true, copiando = false;

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<SubdivisionEntity> subdivisions = [];
  List<PersonalEmpresaEntity> supervisors = [];

  NuevaTareaController(
      this._getActividadsByKeyUseCase,
      this._getLaborsByKeyUseCase,
      this._getSubdivisonsUseCase,
      this._getPersonalsEmpresaUseCase,
      this._getCentroCostosByKeyUseCase);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        editando = true;
        firstTime = true;
        nuevaTarea = TareaProcesoEntity.fromJson(
            (Get.arguments['tarea'] as TareaProcesoEntity).toJson());
        fecha = nuevaTarea.fecha;
        if (Get.arguments['copiando'] != null) {
          copiando = true;
          nuevaTarea.horainicio = null;
          nuevaTarea.horafin = null;
          nuevaTarea.pausainicio = null;
          nuevaTarea.pausafin = null;
          update([
            'hora_inicio',
            'editando',
            'hora_fin',
            'pausa_inicio',
            'pausa_fin'
          ]);
        }
      }
    }
    if (nuevaTarea == null) {
      nuevaTarea = new TareaProcesoEntity();
      //nuevaTarea.fechamod = fecha;
      nuevaTarea.escampo = true;
      nuevaTarea.espacking = true;
      nuevaTarea.idestado = 1;
      nuevaTarea.esjornal = false;
      nuevaTarea.esrendimiento = true;
    }
  }

  void setEditValues() {
    if (editando)
      update(
          ['hora_inicio', 'editando', 'hora_fin', 'pausa_inicio', 'pausa_fin']);
  }

  @override
  void onReady() async {
    super.onReady();
    validando = true;
    update(['validando']);
    await getActividades(
        (nuevaTarea?.esrendimiento ?? false) ? 'esjornal' : 'esrendimiento',
        true);
    await getCentrosCosto();
    await getSupervisors(PreferenciasUsuario().idSede);
    await changeTurno(
        editando && firstTime ? nuevaTarea.turnotareo ?? 'D' : 'D');
    validando = false;
    update(['validando']);

    setEditValues();
    firstTime = false;
  }

  Future<void> getActividades(String key, dynamic value) async {
    actividades.clear();
    actividades.addAll(await _getActividadsByKeyUseCase.execute(
            {key: value, 'idsociedad': PreferenciasUsuario().idSociedad}) ??
        []);
    if (actividades.isNotEmpty) {
      await changeActividad(editando && firstTime
          ? nuevaTarea.idactividad.toString() ??
              '${actividades.first.idactividad}'
          : '${actividades.first.idactividad}');
    }
    update(['actividades']);
  }

  Future<void> getSupervisors(int idSubdivision) async {
    nuevaTarea.sede = (await _getSubdivisonsUseCase.execute())
        .firstWhere((e) => e.idsubdivision == idSubdivision);
    validando = true;
    update(['validando']);
    //supervisors = await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    supervisors = await _getPersonalsEmpresaUseCase.execute();
    if (supervisors.isNotEmpty) {
      await changeSupervisor(editando && firstTime
          ? nuevaTarea.codigoempresasupervisor ??
              '${supervisors.first.codigoempresa}'
          : '${supervisors.first.codigoempresa}');
      await changeDigitador(editando && firstTime
          ? nuevaTarea.codigoempresadigitador ??
              '${supervisors.first.codigoempresa}'
          : '${supervisors.first.codigoempresa}');
    }
    validando = false;
    update(['supervisors', 'digitadors', 'validando']);
  }

  Future<void> getLabores() async {
    if (nuevaTarea.idactividad == null) {
      return;
    }
    labores = await _getLaborsByKeyUseCase
        .execute({'idactividad': nuevaTarea?.idactividad});
    if (labores.isNotEmpty) {
      await changeLabor(editando && firstTime
          ? nuevaTarea.idlabor.toString() ?? '${labores.first.idlabor}'
          : '${labores.first.idlabor}');
    }
    update(['labores']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosByKeyUseCase
        .execute({'idsociedad': PreferenciasUsuario().idSociedad});
    if (centrosCosto.isNotEmpty) {
      await changeCentroCosto(editando && firstTime
          ? nuevaTarea.idcentrocosto.toString() ??
              '${centrosCosto.first.idcentrocosto}'
          : '${centrosCosto.first.idcentrocosto}');
    }
    update(['centro_costo']);
  }

  void changeTurno(String id) {
    nuevaTarea.turnotareo = id;
    update(['turno']);
  }

  void changeHoraInicio() {
    errorHoraInicio = (nuevaTarea.horainicio == null)
        ? 'Debe elegir una hora de inicio'
        : null;
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin =
        (nuevaTarea.horafin == null) ? 'Debe elegir una hora de fin' : null;
    update(['hora_fin', 'inicio_pausa', 'fin_pausa']);
  }

  void changeInicioPausa() {
    /* if(nuevaTarea.pausainicio!=null){
      if(nuevaTarea.pausainicio.isBefore(nuevaTarea.horainicio) || nuevaTarea.pausainicio.isAfter(nuevaTarea.horafin)){
        mostrarDialog('La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaTarea.pausainicio=null;
      }
      update(['inicio_pausa']);
    } */
    update(['inicio_pausa']);
  }

  void changeFinPausa() {
    /* if(nuevaTarea.pausafin!=null){
      if(nuevaTarea.pausafin.isBefore(nuevaTarea.horainicio) || nuevaTarea.pausafin.isAfter(nuevaTarea.horafin)){
        mostrarDialog('La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaTarea.pausafin = null;
      }
      if(nuevaTarea.pausainicio!=null && nuevaTarea.pausainicio.isAfter(nuevaTarea.pausafin)){
        mostrarDialog('La hora debe ser mayor a la hora de pausa');
        nuevaTarea.pausafin = null;
      }
      update(['fin_pausa']);
    } */
    update(['fin_pausa']);
  }

  void mostrarDialog(String mensaje) {
    basicAlert(
      context: Get.overlayContext,
      message: mensaje,
      onPressed: () => Get.back(),
    );
  }

  void changeFecha() {
    nuevaTarea.fecha = fecha;
    update(['fecha']);
    errorFecha = (nuevaTarea.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeSupervisor(String id) {
    errorSupervisor = validatorUtilText(id, 'Supervisor', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorSupervisor == null && index != -1) {
      nuevaTarea.supervisor = supervisors[index];
      nuevaTarea.codigoempresasupervisor = nuevaTarea.supervisor.codigoempresa;
    } else {
      nuevaTarea.supervisor = null;
      nuevaTarea.codigoempresasupervisor = null;
    }

    update(['supervisors']);
  }

  void changeDigitador(String id) {
    errorDigitador = validatorUtilText(id, 'Digitador', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorDigitador == null && index != -1) {
      nuevaTarea.digitador = supervisors[index];
      nuevaTarea.codigoempresadigitador = nuevaTarea.digitador.codigoempresa;
    } else {
      nuevaTarea.digitador = null;
      nuevaTarea.codigoempresadigitador = null;
    }
    update(['digitadors']);
  }

  Future<void> changeActividad(String id) async {
    errorActividad = validatorUtilText(id, 'Actividad', {
      'required': '',
    });
    int index =
        actividades.indexWhere((e) => e.idactividad == int.tryParse(id));
    if (errorActividad == null && index != -1) {
      nuevaTarea.actividad = actividades[index];
      nuevaTarea.idactividad = nuevaTarea.actividad.idactividad;
    } else {
      nuevaTarea.actividad = null;
      nuevaTarea.idactividad = null;
    }
    update(['actividades']);
    await getLabores();
  }

  void changeCentroCosto(String id) {
    errorCentroCosto = validatorUtilText(id, 'Centro de costo', {
      'required': '',
    });
    int index =
        centrosCosto.indexWhere((e) => e.idcentrocosto == int.parse(id));
    if (errorCentroCosto == null && index != -1) {
      nuevaTarea.centroCosto = centrosCosto[index];
      nuevaTarea.idcentrocosto = int.parse(id);
    } else {
      nuevaTarea.centroCosto = null;
      nuevaTarea.idcentrocosto = null;
    }
    update(['centro_costo']);
  }

  Future<void> changeLabor(String id) async {
    errorLabor = validatorUtilText(id, 'Labor', {
      'required': '',
    });
    int index = labores?.indexWhere((e) => e.idlabor.toString().trim() == id);

    if (errorLabor == null && index != -1) {
      nuevaTarea.labor = labores[index];
      nuevaTarea.idlabor = nuevaTarea.labor.idlabor;
    } else {
      nuevaTarea.labor = null;
      nuevaTarea.idlabor = null;
    }
    update(['labores']);
  }

  Future<void> goAgregarPersona() async {
    if (supervisors.length == 0) {
      toast(type: TypeToast.ERROR, message: 'No hay personal en dicha sede');
      return;
    }

    AgregarPersonaBinding().dependencies();
    final result = await Get.to<PersonalTareaProcesoEntity>(
        () => AgregarPersonaPage(),
        arguments: {
          'personal': supervisors,
          'personal_seleccionado': nuevaTarea.personal,
          'tarea': nuevaTarea,
        });
    if (result != null) {
      nuevaTarea.personal.add(result);
      update(['personal']);
    }
  }

  Future<void> goBack() async {
    String mensaje = await validar();
    if (mensaje == null) {
      nuevaTarea.idusuario = PreferenciasUsuario().idUsuario;
      nuevaTarea.estadoLocal = 'P';
      log(nuevaTarea.toJson().toString());
      Get.back(result: nuevaTarea);
    } else {
      toast(type: TypeToast.ERROR, message: mensaje);
    }
  }

  Future<void> goListadoPersonas() async {
    ListadoPersonasBinding().dependencies();
    final resultados = await Get.to<List<PersonalTareaProcesoEntity>>(
        () => ListadoPersonasPage(),
        arguments: {'tarea': nuevaTarea, 'personal': supervisors});

    if (resultados != null) {
      nuevaTarea.personal = resultados;
      update(['personal']);
    }
  }

  void changeDiaSiguiente(bool value) {
    nuevaTarea.diasiguiente = value;
    update(['dia_siguiente']);
  }

  Future<void> changeRendimiento(bool value) async {
    if (value) {
      nuevaTarea.esjornal = true;
      nuevaTarea.esrendimiento = false;
    } else {
      nuevaTarea.esjornal = false;
      nuevaTarea.esrendimiento = true;
    }
    await getActividades(value ? 'esjornal' : 'esrendimiento', true);
    update(['rendimiento', 'actividades']);
  }

  void deleteInicioPausa() {
    nuevaTarea.pausainicio = null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa() {
    nuevaTarea.pausafin = null;
    update(['fin_pausa']);
  }

  Future<String> validar() async {
    changeFecha();
    //await changeActividad(nuevaTarea.idactividad.toString());
    await changeLabor(nuevaTarea.labor.idlabor.toString());
    await changeCentroCosto(nuevaTarea.idcentrocosto.toString());
    await changeSupervisor(nuevaTarea.codigoempresasupervisor.toString());
    await changeDigitador(nuevaTarea.codigoempresadigitador.toString());
    changeHoraInicio();
    changeDiaSiguiente(nuevaTarea.diasiguiente ?? false);
    /* changeRendimiento(nuevaTarea.esjornal ?? false); */
    changeHoraFin();
    if (errorActividad != null) return errorActividad;
    if (errorLabor != null) return errorLabor;
    if (errorSupervisor != null) return errorSupervisor;
    if (errorDigitador != null) return errorDigitador;
    if (errorHoraInicio != null) return errorHoraInicio;
    if (errorHoraFin != null) return errorHoraFin;
    if (errorFecha != null) return errorFecha;

    if (nuevaTarea.pausainicio != null && nuevaTarea.pausafin == null) {
      errorPausaFin = 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin = null;
    if (nuevaTarea.pausafin != null && nuevaTarea.pausainicio == null) {
      errorPausaInicio = 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio = null;

    //PUEDEN SER NULOS: inicioPausa y finPausa (00:00:00)
    return null;
  }
}
