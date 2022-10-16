
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo/listado_personas_pre_tareo_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaPreTareaController extends GetxController {
  final GetActividadsByKeyUseCase _getActividadsByKeyUseCase;
  final GetLaborsByKeyUseCase _getLaborsByKeyUseCase;
  final GetSubdivisonsUseCase _getSubdivisonsUseCase;
  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetCentroCostosUseCase _getCentroCostosUseCase;
  final GetLaboresCultivoPackingUseCase _getLaboresCultivoPackingUseCase;

  DateTime fecha = DateTime.now();
  String errorActividad,
      errorLabor,
      errorPresentacion,
      errorCentroCosto,
      errorSupervisor,
      errorDigitador,
      errorHoraInicio,
      errorHoraFin,
      errorFecha,
      errorPausaInicio,
      errorPausaFin;

  PreTareoProcesoEntity nuevaPreTarea;

  bool validando = false;
  bool editando = false;

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<SubdivisionEntity> subdivisions = [];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking = [];
  List<PresentacionLineaEntity> presentaciones = [];
  List<PersonalEmpresaEntity> supervisors = [];

  NuevaPreTareaController(
      this._getActividadsByKeyUseCase,
      this._getLaborsByKeyUseCase,
      this._getSubdivisonsUseCase,
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getLaboresCultivoPackingUseCase,
      this._getCentroCostosUseCase);

  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        editando = true;
        nuevaPreTarea = Get.arguments['tarea'] as PreTareoProcesoEntity;
        update(['hora_fin']);
      }
    }
    if (nuevaPreTarea == null) nuevaPreTarea = new PreTareoProcesoEntity();
    nuevaPreTarea.fechamod = fecha;
    super.onInit();
    
  }

  void setEditValues() {
    if (editando) {
      update(
          ['hora_inicio', 'editando', 'hora_fin', 'pausa_inicio', 'pausa_fin']);
    }
  }

  @override
  void onReady() async {
    super.onReady();
    validando = true;
    update(['validando']);

    //await getLabores();
    await getCentrosCosto();
    await getPresentaciones();
    await getSupervisors(PreferenciasUsuario().idSede);
    changeTurno(editando ? nuevaPreTarea.turnotareo : 'D');
    validando = false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getPresentaciones() async {
    laboresCultivoPacking = await _getLaboresCultivoPackingUseCase.execute();
    presentaciones = [];
    if (laboresCultivoPacking.isNotEmpty) {
      nuevaPreTarea.laboresCultivoPacking = new LaboresCultivoPackingEntity();
    }
    laboresCultivoPacking.forEach((element) {
      PresentacionLineaEntity presentacion = element.presentacionLinea;
      int index = presentaciones
          .indexWhere((e) => e.idpresentacion == presentacion.idpresentacion);
      if (index == -1) {
        presentaciones.add(presentacion);
      }
    });
    if (presentaciones.isNotEmpty) {
      nuevaPreTarea.laboresCultivoPacking.presentacionLinea =
          presentaciones.first;
      nuevaPreTarea.laboresCultivoPacking.idpresentacion =
          presentaciones.first.idpresentacion;
      await changePresentacion(nuevaPreTarea
          .laboresCultivoPacking.presentacionLinea?.idpresentacion
          .toString());
      getActividades();
    }
    update(['presentacion']);
  }

  Future<void> getActividades() async {
    actividades = [];
    laboresCultivoPacking.forEach((element) {
      if (element.presentacionLinea.idpresentacion ==
          nuevaPreTarea.laboresCultivoPacking.idpresentacion) {
        ActividadEntity actividad = element.actividad;
        int index = actividades
            .indexWhere((e) => e.idactividad == actividad.idactividad);
        if (index == -1) {
          actividades.add(actividad);
        }
      }
    });
    if (actividades.isNotEmpty) {
      nuevaPreTarea.laboresCultivoPacking.actividad = actividades?.first;
      nuevaPreTarea.laboresCultivoPacking.idactividad =
          actividades?.first?.idactividad;
      await changeActividad(
          nuevaPreTarea.laboresCultivoPacking.idactividad.toString());
      await getLabores();
    }
    update(['actividades']);
  }

  Future<void> getSupervisors(int idSubdivision) async {
    nuevaPreTarea.sede = (await _getSubdivisonsUseCase.execute())
        .firstWhere((e) => e.idsubdivision == idSubdivision);
    validando = true;
    supervisors =
        await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    update(['validando']);

    if (supervisors.length > 0) {
      nuevaPreTarea.supervisor = supervisors[0];
      nuevaPreTarea.digitador = supervisors[0];
      changeSupervisor(nuevaPreTarea.supervisor.codigoempresa);
      changeDigitador(nuevaPreTarea.digitador.codigoempresa);
    }
    update(['supervisors', 'digitadors']);
    validando = false;
    update(['validando']);
  }

  Future<void> getLabores() async {
    if (nuevaPreTarea?.laboresCultivoPacking?.actividad?.idactividad == null) {
      return;
    }
    labores = [];
    laboresCultivoPacking.forEach((element) {
      if (element.idpresentacion ==
              nuevaPreTarea.laboresCultivoPacking.idpresentacion &&
          element.idactividad ==
              nuevaPreTarea.laboresCultivoPacking.idactividad) {
        LaborEntity labor = element.labor;
        int index = labores.indexWhere((e) => e.idlabor == labor.idlabor);
        if (index == -1) {
          labores.add(labor);
        }
      }
    });

    if (labores.isNotEmpty) {
      nuevaPreTarea.laboresCultivoPacking.labor = labores.first;
      nuevaPreTarea.laboresCultivoPacking.idlabor = labores.first.idlabor;
    }
    changeLabor(nuevaPreTarea.laboresCultivoPacking.idlabor.toString());
    update(['labores']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosUseCase.execute();
    if (!editando) {
      if (centrosCosto.isNotEmpty) {
        nuevaPreTarea.centroCosto = centrosCosto.first;
      }
    }
    changeCentroCosto(nuevaPreTarea.centroCosto.idcentrocosto.toString());
    update(['centro_costo']);
  }

  void changeTurno(String id) {
    nuevaPreTarea.turnotareo = id;
    if (id == 'D') {
      nuevaPreTarea.pausainicio = null;
      nuevaPreTarea.pausafin = null;
      update(['inicio_pausa', 'fin_pausa']);
    }
    update(['turno']);
  }

  void changeHoraInicio() {
    errorHoraInicio = (nuevaPreTarea.horainicio == null)
        ? 'Debe elegir una hora de inicio'
        : null;
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin =
        (nuevaPreTarea.horafin == null) ? 'Debe elegir una hora de fin' : null;
    update(['hora_fin', 'inicio_pausa', 'fin_pausa']);
  }

  void changeInicioPausa() {
    /* if (nuevaPreTarea.pausainicio != null) {
      if (nuevaPreTarea.turnotareo == 'N') {
        update(['inicio_pausa']);
        return;
      }
      if (nuevaPreTarea.pausainicio.isBefore(nuevaPreTarea.horainicio) ||
          nuevaPreTarea.pausainicio.isAfter(nuevaPreTarea.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaPreTarea.pausainicio = null;
      }
      update(['inicio_pausa']);
    } */
    update(['inicio_pausa']);
  }

  void changeFinPausa() {
    /* if (nuevaPreTarea.pausafin != null && nuevaPreTarea.turnotareo == 'D') {
      if (nuevaPreTarea.turnotareo == 'N') {
        update(['inicio_pausa']);
        return;
      }
      if (nuevaPreTarea.pausafin.isBefore(nuevaPreTarea.horainicio) ||
          nuevaPreTarea.pausafin.isAfter(nuevaPreTarea.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaPreTarea.pausafin = null;
      }
      if (nuevaPreTarea.pausainicio != null &&
          nuevaPreTarea.pausainicio.isAfter(nuevaPreTarea?.pausafin)) {
        mostrarDialog('La hora debe ser mayor a la hora de pausa');
        nuevaPreTarea.pausafin = null;
      }
      update(['fin_pausa']);
    } */
    update(['fin_pausa']);
  }

  void mostrarDialog(String mensaje) {
    basicAlert(
      Get.overlayContext,
      'Alerta',
      mensaje,
      'Aceptar',
      () => Get.back(),
    );
  }

  void changeFecha() {
    nuevaPreTarea.fecha = fecha;
    update(['fecha']);
    errorFecha = (nuevaPreTarea.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeSupervisor(String id) {
    errorSupervisor = validatorUtilText(id, 'Supervisor', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorSupervisor == null && index != -1) {
      nuevaPreTarea.supervisor = supervisors[index];
      nuevaPreTarea.codigoempresasupervisor =
          nuevaPreTarea.supervisor.codigoempresa;
    } else {
      nuevaPreTarea.supervisor = null;
      nuevaPreTarea.codigoempresasupervisor = null;
    }

    update(['supervisors']);
  }

  void changeDigitador(String id) {
    errorDigitador = validatorUtilText(id, 'Digitador', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorDigitador == null && index != -1) {
      nuevaPreTarea.digitador = supervisors[index];
      nuevaPreTarea.codigoempresadigitador = supervisors[index].codigoempresa;
    } else {
      nuevaPreTarea.digitador = null;
      nuevaPreTarea.codigoempresadigitador = null;
    }

    update(['digitadors']);
  }

  Future<void> changeActividad(String id) async {
    errorActividad = validatorUtilText(id, 'Actividad', {
      'required': '',
    });
    int index = actividades.indexWhere((e) => e.idactividad == int.parse(id));
    if (errorActividad == null && index != -1) {
      nuevaPreTarea.laboresCultivoPacking.actividad = actividades[index];
      nuevaPreTarea.laboresCultivoPacking.idactividad = int.parse(id);
      await getLabores();
    } else {
      nuevaPreTarea.laboresCultivoPacking.actividad = null;
      nuevaPreTarea.laboresCultivoPacking.idactividad = null;
    }

    update(['actividades']);
  }

  void changePresentacion(String id) {
    errorPresentacion = validatorUtilText(id, 'Presentación', {
      'required': '',
    });
    int index =
        presentaciones.indexWhere((e) => e.idpresentacion == int.parse(id));
    if (errorPresentacion == null && index != -1) {
      nuevaPreTarea.laboresCultivoPacking = LaboresCultivoPackingEntity();
      nuevaPreTarea.laboresCultivoPacking.presentacionLinea =
          presentaciones[index];
      nuevaPreTarea.laboresCultivoPacking.idpresentacion = int.parse(id);
    } else {
      nuevaPreTarea.laboresCultivoPacking.presentacionLinea = null;
      nuevaPreTarea.laboresCultivoPacking.idpresentacion = null;
    }
    getActividades();
    update(['presentacion']);
  }

  void changeCentroCosto(String id) {
    errorCentroCosto = validatorUtilText(id, 'Centro de costo', {
      'required': '',
    });
    int index =
        centrosCosto.indexWhere((e) => e.idcentrocosto == int.parse(id));
    if (errorCentroCosto == null && index != -1) {
      nuevaPreTarea.centroCosto = centrosCosto[index];
      nuevaPreTarea.idcentrocosto = int.parse(id);
    } else {
      nuevaPreTarea.centroCosto = null;
      nuevaPreTarea.idcentrocosto = null;
    }
    update(['centro_costo']);
  }

  void changeLabor(String id) {
    errorLabor = validatorUtilText(id, 'Labor', {
      'required': '',
    });
    int index = labores?.indexWhere((e) => e.idlabor.toString() == id);

    if (errorLabor == null && index != -1) {
      nuevaPreTarea.laboresCultivoPacking.labor = labores[index];
      nuevaPreTarea.laboresCultivoPacking.idlabor =
          nuevaPreTarea.laboresCultivoPacking.labor.idlabor;
    } else {
      nuevaPreTarea.laboresCultivoPacking.labor = null;
      nuevaPreTarea.laboresCultivoPacking.idlabor = null;
    }
    update(['labores']);
  }

  void goBack() {
    String mensaje = validar();
    if (mensaje == null) {
      laboresCultivoPacking.forEach((e) {
        LaboresCultivoPackingEntity actual =
            nuevaPreTarea.laboresCultivoPacking;
        if (e.idactividad == actual.idactividad &&
            e.idlabor == actual.idlabor && e.idcultivo==1 &&
            e.idpresentacion == actual.idpresentacion) {
          nuevaPreTarea.item = e.item;
          nuevaPreTarea.laboresCultivoPacking = actual;
        }
      });

      nuevaPreTarea.idusuario = PreferenciasUsuario().idUsuario;
      nuevaPreTarea.estadoLocal = 'PC';
      Get.back(result: nuevaPreTarea);
    } else {
      toastError('Error', mensaje);
    }
  }

  Future<void> goListadoPersonas() async {
    ListadoPersonasBinding().dependencies();
    final resultados = await Get.to<List<PreTareoProcesoDetalleEntity>>(
        () => ListadoPersonasPreTareoPage(),
        arguments: {'tarea': nuevaPreTarea, 'personal': supervisors});

    if (resultados != null) {
      nuevaPreTarea.detalles = resultados;
      update(['personal']);
    }
  }

  void changeDiaSiguiente(bool value) {
    nuevaPreTarea.diasiguiente = value;
    update(['dia_siguiente']);
  }

  void deleteInicioPausa() {
    nuevaPreTarea.pausainicio = null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa() {
    nuevaPreTarea.pausafin = null;
    update(['fin_pausa']);
  }

  String validar() {
    changeFecha();
    //changeActividad(nuevaPreTarea.laboresCultivoPacking.idactividad.toString());
    changeLabor(nuevaPreTarea.laboresCultivoPacking.idlabor.toString());
    changeCentroCosto(nuevaPreTarea.idcentrocosto.toString());
    changeSupervisor(nuevaPreTarea.codigoempresasupervisor.toString());
    changeHoraInicio();
    changeDiaSiguiente(nuevaPreTarea.diasiguiente ?? false);
    changeHoraFin();
    if (errorActividad != null) return errorActividad;
    if (errorLabor != null) return errorLabor;
    if (errorSupervisor != null) return errorSupervisor;
    if (errorHoraInicio != null) return errorHoraInicio;
    if (errorHoraFin != null) return errorHoraFin;
    if (errorFecha != null) return errorFecha;

    if (nuevaPreTarea.pausainicio != null && nuevaPreTarea.pausafin == null) {
      errorPausaFin = 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin = null;
    if (nuevaPreTarea.pausafin != null && nuevaPreTarea.pausainicio == null) {
      errorPausaInicio = 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio = null;
    return null;
  }
}
