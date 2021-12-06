import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo_uva/listado_personas_pre_tareo_uva_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaSeleccionController extends GetxController {
  final GetSubdivisonsUseCase _getSubdivisonsUseCase;
  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetCentroCostosUseCase _getCentroCostosUseCase;
  final GetLaborsByKeyUseCase _getLaborsByKeyUseCase;
  final GetActividadsByKeyUseCase _getActividadsByKeyUseCase;

  DateTime fecha = DateTime.now();
  String errorActividad,
      errorLabor,
      errorPresentacion,
      errorCentroCosto,
      errorCultivo,
      errorKilosavance,
      errorSupervisor,
      errorDigitador,
      errorHoraInicio,
      errorHoraFin,
      errorFecha,
      errorPausaInicio,
      errorPausaFin;

  PreTareaEsparragoGrupoEntity nuevaSeleccion;

  bool validando = false;
  bool editando = false;

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<SubdivisionEntity> subdivisions = [];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking = [];
  List<PresentacionLineaEntity> presentaciones = [];
  List<PersonalEmpresaEntity> supervisors = [];

  NuevaSeleccionController(
      this._getSubdivisonsUseCase,
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getLaborsByKeyUseCase,
      this._getActividadsByKeyUseCase,
      this._getCentroCostosUseCase);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        editando = true;
        nuevaSeleccion = Get.arguments['tarea'] as PreTareaEsparragoGrupoEntity;
        if (nuevaSeleccion.sizeDetails == null) nuevaSeleccion.sizeDetails = 0;
      }
    }
    if (nuevaSeleccion == null) {
      nuevaSeleccion = new PreTareaEsparragoGrupoEntity();
      nuevaSeleccion.turnotareo = 'D';
      if (nuevaSeleccion.sizeDetails== null) nuevaSeleccion.sizeDetails = 0;
    }

    /* nuevaPreTarea.fechamod = fecha; */
  }

  Future<void> getActividades() async {
    actividades = await _getActividadsByKeyUseCase
        .execute({'idsociedad': PreferenciasUsuario().idSociedad});
    if (!editando) {
      if (actividades.isNotEmpty) {
        nuevaSeleccion.actividad = actividades.first;
      }
    }
    await changeActividad(nuevaSeleccion?.actividad?.idactividad.toString());
    await getLabores();

    update(['actividades']);
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
    await getActividades();
    await getCentrosCosto();
    await getSupervisors(PreferenciasUsuario().idSede);
    changeTurno(editando ? nuevaSeleccion.turnotareo : 'D');
    validando = false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getSupervisors(int idSubdivision) async {
    nuevaSeleccion.sede = (await _getSubdivisonsUseCase.execute())
        .firstWhere((e) => e.idsubdivision == idSubdivision);
    validando = true;
    update(['validando']);
    supervisors =
        await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    if (!editando) {
      if (supervisors.isNotEmpty) {
        nuevaSeleccion.supervisor = supervisors[0];
        nuevaSeleccion.digitador = supervisors[0];
      }
    }

    changeSupervisor(nuevaSeleccion.supervisor.codigoempresa);
    changeDigitador(nuevaSeleccion.digitador.codigoempresa);

    update(['supervisors', 'digitadors']);
    validando = false;
    update(['validando']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosUseCase.execute();
    if (!editando) {
      if (centrosCosto.isNotEmpty) {
        nuevaSeleccion.centroCosto = centrosCosto.first;
      }
    }
    changeCentroCosto(nuevaSeleccion.centroCosto.idcentrocosto.toString());
    update(['centro_costo']);
  }

  Future<void> getLabors() async {
    labores = await _getLaborsByKeyUseCase
        .execute({'idactividad': nuevaSeleccion.idactividad});
    ;
    if (!editando) {
      if (labores.isNotEmpty) {
        nuevaSeleccion.labor = labores.first;
      }
    }
    if (labores.isNotEmpty) {
      nuevaSeleccion.labor = labores.first;
      nuevaSeleccion.idlabor = nuevaSeleccion.labor.idlabor;
    }
    changeLabor(nuevaSeleccion.labor.idlabor.toString());
    update(['labors']);
  }

  void changeLabor(String id) {
    errorLabor = validatorUtilText(id, 'Labor', {
      'required': '',
    });
    int index = labores?.indexWhere((e) => e.idlabor.toString() == id);

    if (errorLabor == null && index != -1) {
      nuevaSeleccion.labor = labores[index];
      nuevaSeleccion.idlabor = nuevaSeleccion.labor.idlabor;
    } else {
      nuevaSeleccion.labor = null;
      nuevaSeleccion.idlabor = null;
    }
    update(['labores']);
  }

  void changeTurno(String id) {
    nuevaSeleccion.turnotareo = id;
    if (id == 'D') {
      update(['inicio_pausa', 'fin_pausa']);
    }
    update(['turno']);
  }

  void changeHoraInicio() {
    errorHoraInicio = (nuevaSeleccion.horainicio == null)
        ? 'Debe elegir una hora de inicio'
        : null;
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin =
        (nuevaSeleccion.horafin == null) ? 'Debe elegir una hora de fin' : null;
    update(['hora_fin', 'inicio_pausa', 'fin_pausa']);
  }

  void changeInicioPausa() {
    update(['inicio_pausa']);
  }

  void changeFinPausa() {
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
    nuevaSeleccion.fecha = fecha;
    update(['fecha']);
    errorFecha = (nuevaSeleccion.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeSupervisor(String id) {
    errorSupervisor = validatorUtilText(id, 'Supervisor', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorSupervisor == null && index != -1) {
      nuevaSeleccion.supervisor = supervisors[index];
      nuevaSeleccion.codigosupervisor = nuevaSeleccion.supervisor.codigoempresa;
    } else {
      nuevaSeleccion.supervisor = null;
      nuevaSeleccion.codigosupervisor = null;
    }

    update(['supervisors']);
  }

  void changeDigitador(String id) {
    errorDigitador = validatorUtilText(id, 'Digitador', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorDigitador == null && index != -1) {
      nuevaSeleccion.digitador = supervisors[index];
      nuevaSeleccion.codigodigitador = supervisors[index].codigoempresa;
    } else {
      nuevaSeleccion.digitador = null;
      nuevaSeleccion.codigodigitador = null;
    }

    update(['digitadors']);
  }

  void changeCentroCosto(String id) {
    errorCentroCosto = validatorUtilText(id, 'Centro de costo', {
      'required': '',
    });
    int index =
        centrosCosto.indexWhere((e) => e.idcentrocosto == int.parse(id));
    if (errorCentroCosto == null && index != -1) {
      nuevaSeleccion.centroCosto = centrosCosto[index];
      nuevaSeleccion.idcentrocosto = int.parse(id);
    } else {
      nuevaSeleccion.centroCosto = null;
      nuevaSeleccion.idcentrocosto = null;
    }
    update(['centro_costo']);
  }

  Future<void> changeActividad(String id) async {
    errorActividad = validatorUtilText(id, 'Actividad', {
      'required': '',
    });
    int index = actividades?.indexWhere((e) => e.idactividad == int.parse(id));
    if (errorActividad == null && index != -1) {
      nuevaSeleccion.actividad = actividades[index];
      nuevaSeleccion.idactividad = int.parse(id);
      await getLabores();
    } else {
      nuevaSeleccion.actividad = null;
      nuevaSeleccion.idactividad = null;
    }

    update(['actividades']);
  }

  Future<void> getLabores() async {
    if (nuevaSeleccion.idactividad == null) {
      return;
    }
    labores = await _getLaborsByKeyUseCase
        .execute({'idactividad': nuevaSeleccion.idactividad});

    if (!editando) {
      if (labores.isNotEmpty) {
        nuevaSeleccion.labor = labores.first;
      }
    }

    changeLabor(nuevaSeleccion.labor?.idlabor.toString());
    update(['labores']);
  }

  void goBack() {
    String mensaje = validar();
    if (mensaje == null) {
      nuevaSeleccion.idusuario = PreferenciasUsuario().idUsuario;
      nuevaSeleccion.estadoLocal = 'PC';
      Get.back(result: nuevaSeleccion);
    } else {
      toastError('Error', mensaje);
    }
  }

  void changeDiaSiguiente(bool value) {
    nuevaSeleccion.diasiguiente = value;
    update(['dia_siguiente']);
  }

  void deleteInicioPausa() {
    nuevaSeleccion.pausainicio = null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa() {
    nuevaSeleccion.pausafin = null;
    update(['fin_pausa']);
  }

  String validar() {
    changeFecha();
    changeLabor(nuevaSeleccion.idlabor.toString());
    changeCentroCosto(nuevaSeleccion.idcentrocosto.toString());
    changeSupervisor(nuevaSeleccion.codigosupervisor.toString());
    changeCantidadAvance(nuevaSeleccion.kilosavance.toString());
    changeHoraInicio();
    changeDiaSiguiente(nuevaSeleccion.diasiguiente ?? false);
    changeHoraFin();

    if (errorActividad != null) return errorActividad;
    if (errorCultivo != null) return errorCultivo;
    if (errorLabor != null) return errorLabor;
    if (errorSupervisor != null) return errorSupervisor;
    if (errorHoraInicio != null) return errorHoraInicio;
    if (errorHoraFin != null) return errorHoraFin;
    if (errorFecha != null) return errorFecha;

    if (nuevaSeleccion.pausainicio != null && nuevaSeleccion.pausafin == null) {
      errorPausaFin = 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin = null;
    if (nuevaSeleccion.pausafin != null && nuevaSeleccion.pausainicio == null) {
      errorPausaInicio = 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio = null;

    //PUEDEN SER NULOS: inicioPausa y finPausa (00:00:00)
    return null;
  }

  void changeCantidadAvance(String value) {
    if ([null, ''].contains(value)) {
      errorKilosavance = null;
      nuevaSeleccion.kilosavance = null;
      update(['kilos_avance']);
      return;
    }
    double avance = double.tryParse(value);
    if (avance != null) {
      nuevaSeleccion.kilosavance = avance;
      errorKilosavance = null;
    } else {
      errorKilosavance = 'El valor ingresado no es un número';
    }

    update(['kilos_avance']);
  }
}
