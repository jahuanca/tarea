
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_tipo_tareas_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo_uva/listado_personas_pre_tareo_uva_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaClasificacionController extends GetxController {
  
  final GetSubdivisonsUseCase _getSubdivisonsUseCase;
  final GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  final GetCentroCostosUseCase _getCentroCostosUseCase;
  final GetCultivosUseCase _getCultivosUseCase;
  final GetTipoTareasUseCase _getTipoTareasUseCase;

  DateTime fecha = DateTime.now();
  String errorActividad,
      errorLabor,
      errorPresentacion,
      errorTipoTarea,
      errorCentroCosto,
      errorCultivo,
      errorSupervisor,
      errorDigitador,
      errorHoraInicio,
      errorHoraFin,
      errorFecha,
      errorPausaInicio,
      errorPausaFin;

  PreTareaEsparragoEntity nuevaClasificacion;

  bool validando = false;
  bool editando = false;

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<TipoTareaEntity> tipoTareas = [];
  List<CultivoEntity> cultivos = [];
  List<SubdivisionEntity> subdivisions = [];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking = [];
  List<PresentacionLineaEntity> presentaciones = [];
  List<PersonalEmpresaEntity> supervisors = [];

  NuevaClasificacionController(
      this._getSubdivisonsUseCase,
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getCultivosUseCase,
      this._getCentroCostosUseCase,
      this._getTipoTareasUseCase,
      );

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        editando = true;
        nuevaClasificacion = Get.arguments['tarea'] as PreTareaEsparragoEntity;
        if(nuevaClasificacion.detalles==null) nuevaClasificacion.detalles=[];
      }
    }
    if (nuevaClasificacion == null) nuevaClasificacion = new PreTareaEsparragoEntity();
    if(nuevaClasificacion.detalles==null) nuevaClasificacion.detalles=[];
    /* nuevaClasificacion.fechamod = fecha; */
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

    /* await getCultivos(); */
    await getTipoTarea();
    await getCentrosCosto();
    await getSupervisors(PreferenciasUsuario().idSede);
    changeTurno(editando ? nuevaClasificacion.turnotareo : 'D');
    validando = false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getSupervisors(int idSubdivision) async {
    nuevaClasificacion.sede = (await _getSubdivisonsUseCase.execute())
        .firstWhere((e) => e.idsubdivision == idSubdivision);
    validando = true;
    update(['validando']);
    supervisors = await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    if (supervisors.length > 0) {
      nuevaClasificacion.supervisor = supervisors[0];
      nuevaClasificacion.digitador = supervisors[0];
      changeSupervisor(nuevaClasificacion.supervisor.codigoempresa);
      changeDigitador(nuevaClasificacion.digitador.codigoempresa);
    }
    update(['supervisors','digitadors']);
    validando = false;
    update(['validando']);
  }

  Future<void> getTipoTarea() async {
    tipoTareas= await _getTipoTareasUseCase.execute();
    print(tipoTareas.first.toJson());
    if (!editando) {
      if (tipoTareas.isNotEmpty) {
        nuevaClasificacion.tipoTarea = tipoTareas.first;
      }
    }
    changeTipoTarea(nuevaClasificacion.tipoTarea.idtipotarea.toString());
    update(['tipo_tarea']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosUseCase.execute();
    if (!editando) {
      if (centrosCosto.isNotEmpty) {
        nuevaClasificacion.centroCosto = centrosCosto.first;
      }
    }
    changeCentroCosto(nuevaClasificacion.centroCosto.idcentrocosto.toString());
    update(['centro_costo']);
  }

  /* Future<void> getCultivos() async {
    cultivos = await _getCultivosUseCase.execute();
    if (!editando) {
      if (cultivos.isNotEmpty) {
        nuevaClasificacion.cultivo = cultivos.first;
      }
    }
    changeCultivo(nuevaClasificacion.cultivo.idcultivo.toString());
    update(['cultivos']);
  } */

  void changeTurno(String id) {
    nuevaClasificacion.turnotareo = id;
    if (id == 'D') {
      nuevaClasificacion.pausainicio = null;
      nuevaClasificacion.pausafin = null;
      update(['inicio_pausa', 'fin_pausa']);
    }
    update(['turno']);
  }

  void changeHoraInicio() {
    errorHoraInicio = (nuevaClasificacion.horainicio == null)
        ? 'Debe elegir una hora de inicio'
        : null;
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin =
        (nuevaClasificacion.horafin == null) ? 'Debe elegir una hora de fin' : null;
    update(['hora_fin', 'inicio_pausa', 'fin_pausa']);
  }

  void changeInicioPausa() {
    /* if (nuevaClasificacion.pausainicio != null) {
      if (nuevaClasificacion.turnotareo == 'N') {
        update(['inicio_pausa']);
        return;
      }
      if (nuevaClasificacion.pausainicio.isBefore(nuevaClasificacion.horainicio) ||
          nuevaClasificacion.pausainicio.isAfter(nuevaClasificacion.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaClasificacion.pausainicio = null;
      }
      update(['inicio_pausa']);
    } */
    update(['inicio_pausa']);
  }

  void changeFinPausa() {
    /* if (nuevaClasificacion.pausafin != null && nuevaClasificacion.turnotareo == 'D') {
      if (nuevaClasificacion.turnotareo == 'N') {
        update(['inicio_pausa']);
        return;
      }
      if (nuevaClasificacion.pausafin.isBefore(nuevaClasificacion.horainicio) ||
          nuevaClasificacion.pausafin.isAfter(nuevaClasificacion.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        nuevaClasificacion.pausafin = null;
      }
      if (nuevaClasificacion.pausainicio != null &&
          nuevaClasificacion.pausainicio.isAfter(nuevaClasificacion?.pausafin)) {
        mostrarDialog('La hora debe ser mayor a la hora de pausa');
        nuevaClasificacion.pausafin = null;
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
    nuevaClasificacion.fecha = fecha;
    update(['fecha']);
    errorFecha = (nuevaClasificacion.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeSupervisor(String id) {
    errorSupervisor = validatorUtilText(id, 'Supervisor', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorSupervisor == null && index != -1) {
      nuevaClasificacion.supervisor = supervisors[index];
      nuevaClasificacion.codigosupervisor =
          nuevaClasificacion.supervisor.codigoempresa;
    } else {
      nuevaClasificacion.supervisor = null;
      nuevaClasificacion.codigosupervisor = null;
    }

    update(['supervisors']);
  }

  void changeDigitador(String id) {
    errorDigitador = validatorUtilText(id, 'Digitador', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString() == id);
    if (errorDigitador == null && index != -1) {
      nuevaClasificacion.digitador = supervisors[index];
      nuevaClasificacion.codigodigitador =
          supervisors[index].codigoempresa;
    } else {
      nuevaClasificacion.digitador = null;
      nuevaClasificacion.codigodigitador = null;
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
      nuevaClasificacion.centroCosto = centrosCosto[index];
      nuevaClasificacion.idcentrocosto = int.parse(id);
    } else {
      nuevaClasificacion.centroCosto = null;
      nuevaClasificacion.idcentrocosto = null;
    }
    update(['centro_costo']);
  }

  void changeTipoTarea(String id) {
    errorTipoTarea = validatorUtilText(id, 'Tipo de tareas', {
      'required': '',
    });
    int index =
        tipoTareas.indexWhere((e) => e.idtipotarea == int.parse(id));
    if (errorTipoTarea == null && index != -1) {
      nuevaClasificacion.tipoTarea = tipoTareas[index];
      nuevaClasificacion.idtipotarea = int.parse(id);
    } else {
      nuevaClasificacion.tipoTarea = null;
      nuevaClasificacion.idtipotarea = null;
    }
    update(['tipo_tarea']);
  }

  /* void changeCultivo(String id) {
    errorCultivo = validatorUtilText(id, 'Cultivo', {
      'required': '',
    });
    int index =
        cultivos.indexWhere((e) => e.idcultivo== int.parse(id));
    if (errorCultivo == null && index != -1) {
      nuevaClasificacion.cultivo = cultivos[index];
      nuevaClasificacion.idcultivo = int.parse(id);
    } else {
      nuevaClasificacion.cultivo = null;
      nuevaClasificacion.idcultivo = null;
    }
    update(['cultivo']);
  } */

  void goBack() {
    String mensaje = validar();
    if (mensaje == null) {

      nuevaClasificacion.idusuario=PreferenciasUsuario().idUsuario;
      nuevaClasificacion.estadoLocal='PC';
      Get.back(result: nuevaClasificacion);
    } else {
      toastError('Error', mensaje);
    }
  }

  Future<void> goListadoPersonas() async {
    ListadoPersonasBinding().dependencies();
    final resultados = await Get.to<List<PreTareaEsparragoFormatoEntity>>(
        () => ListadoPersonasPreTareoUvaPage(),
        arguments: {'tarea': nuevaClasificacion, 'personal': supervisors});

    if (resultados != null) {
      nuevaClasificacion.detalles = resultados;
      update(['personal']);
    }
  }

  void changeDiaSiguiente(bool value) {
    nuevaClasificacion.diasiguiente = value;
    update(['dia_siguiente']);
  }

  void deleteInicioPausa() {
    nuevaClasificacion.pausainicio = null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa() {
    nuevaClasificacion.pausafin = null;
    update(['fin_pausa']);
  }

  String validar() {
    changeFecha();
    /* changeCultivo(nuevaClasificacion.idcultivo.toString()); */
    changeCentroCosto(nuevaClasificacion.idcentrocosto.toString());
    changeSupervisor(nuevaClasificacion.codigosupervisor.toString());
    changeHoraInicio();
    changeDiaSiguiente(nuevaClasificacion.diasiguiente ?? false);
    changeHoraFin();
    //TODO: VALIDAR: fechas por TURNO NOCHE
    if (errorActividad != null) return errorActividad;
    if (errorCultivo != null) return errorCultivo;
    if (errorLabor != null) return errorLabor;
    if (errorSupervisor != null) return errorSupervisor;
    if (errorHoraInicio != null) return errorHoraInicio;
    if (errorHoraFin != null) return errorHoraFin;
    if (errorFecha != null) return errorFecha;

    if (nuevaClasificacion.pausainicio != null && nuevaClasificacion.pausafin == null) {
      errorPausaFin = 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin = null;
    if (nuevaClasificacion.pausafin != null && nuevaClasificacion.pausainicio == null) {
      errorPausaInicio = 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio = null;

    //PUEDEN SER NULOS: inicioPausa y finPausa (00:00:00)

    //TODO: en caso de haber inicio de pausa validar que esten dentro de horafin y horainicio
    return null;
  }
}
