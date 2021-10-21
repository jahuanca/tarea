import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class NuevaTareaController extends GetxController {
  GetActividadsByKeyUseCase _getActividadsByKeyUseCase;
  GetLaborsByKeyUseCase _getLaborsByKeyUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;
  GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  GetCentroCostosUseCase _getCentroCostosUseCase;

  DateTime fecha = new DateTime.now();
  String errorActividad, errorLabor, errorCentroCosto, errorSupervisor, errorHoraInicio, errorHoraFin, errorFecha, errorPausaInicio, errorPausaFin;

  TareaProcesoEntity nuevaTarea = new TareaProcesoEntity();

  bool validando = false;
  bool editando = false;

  List<ActividadEntity> actividades = [];
  List<LaborEntity> labores = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<SubdivisionEntity> subdivisions = [];
  List<PersonalEmpresaEntity> supervisors = [];

  NuevaTareaController(
      this._getActividadsByKeyUseCase,
      this._getLaborsByKeyUseCase,
      this._getSubdivisonsUseCase,
      this._getPersonalsEmpresaBySubdivisionUseCase,
      this._getCentroCostosUseCase);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        editando = true;
        nuevaTarea = Get.arguments['tarea'] as TareaProcesoEntity;
      }
    }
    nuevaTarea.fechamod = fecha;
    nuevaTarea.escampo = true;
    nuevaTarea.espacking = true;
    nuevaTarea.idestado = 1;
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
    await getActividades(
        nuevaTarea.esrendimiento ?? false ? 'esjornal' : 'esrendimiento', true);
    await getLabores();
    await getCentrosCosto();
    await getSupervisors(PreferenciasUsuario().idSede);
    changeTurno(editando ? nuevaTarea.turnotareo : 'D');
    validando = false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getActividades(String key, dynamic value) async {
    actividades = await _getActividadsByKeyUseCase
        .execute({key: value, 'idsociedad': PreferenciasUsuario().idSociedad});
    print(actividades.length);
    if (actividades.length > 0) {
      nuevaTarea.actividad = actividades?.first;
      await changeActividad(nuevaTarea.actividad?.idactividad.toString());
      await getLabores();
    }
    update(['actividades']);
  }

  Future<void> getSupervisors(int idSubdivision) async {
    nuevaTarea.sede = (await _getSubdivisonsUseCase.execute())
        .firstWhere((e) => e.idsubdivision == idSubdivision);
    validando = true;
    update(['validando']);
    supervisors = await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    if (supervisors.length > 0) {
      nuevaTarea.supervisor = supervisors[1];
      changeSupervisor(nuevaTarea.supervisor.codigoempresa);
    }
    update(['supervisors']);
    validando = false;
    update(['validando']);
  }

  Future<void> getLabores() async {
    if (nuevaTarea.idactividad == null) {
      return;
    }
    labores = await _getLaborsByKeyUseCase
        .execute({'idactividad': nuevaTarea.idactividad});
    print(labores.length);
    if (labores.isNotEmpty) {
      nuevaTarea.labor = labores.first;
      nuevaTarea.idlabor = nuevaTarea.labor.idlabor;
    }

    changeLabor(nuevaTarea.labor?.idlabor.toString());
    update(['labores']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosUseCase.execute();
    if (!editando) {
      if (centrosCosto.isNotEmpty) {
        nuevaTarea.centroCosto = centrosCosto.first;
      }
    }
    changeCentroCosto(nuevaTarea.centroCosto.idcentrocosto.toString());
    update(['centro_costo']);
  }

  void changeTurno(String id) {
    nuevaTarea.turnotareo = id;
    update(['turno']);
  }

  void changeHoraInicio() {
    errorHoraInicio= (nuevaTarea.horainicio == null) ? 'Debe elegir una hora de inicio' : null;
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin= (nuevaTarea.horafin == null) ? 'Debe elegir una hora de fin' : null;
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
  }

  void mostrarDialog(String mensaje){
    basicAlert(
        Get.overlayContext,
        'Alerta',
        mensaje,
        'Aceptar',
        () => Get.back(),
      );
  }

  void changeFecha() {
    nuevaTarea.fecha = fecha;
    update(['fecha']);
    errorFecha= (nuevaTarea.fecha == null) ? 'Ingrese una fecha' : null;
    update(['fecha']);
  }

  void changeSupervisor(String id) {
    errorSupervisor = validatorUtilText(id, 'Supervisor', {
      'required': '',
    });
    int index = supervisors.indexWhere((e) => e.codigoempresa.toString()== id);
    if (errorSupervisor == null && index != -1) {
      nuevaTarea.supervisor = supervisors[index];
      nuevaTarea.codigoempresa = nuevaTarea.supervisor.codigoempresa;
      
    } else {
      nuevaTarea.supervisor = null;
      nuevaTarea.codigoempresa = null;
    }

    update(['supervisors']);
  }

  Future<void> changeActividad(String id) async {
    errorActividad = validatorUtilText(id, 'Actividad', {
      'required': '',
    });
    int index = actividades.indexWhere((e) => e.idactividad == int.parse(id));
    if (errorActividad == null && index != -1) {
      nuevaTarea.actividad = actividades[index];
      nuevaTarea.idactividad = int.parse(id);
      await getLabores();
    } else {
      nuevaTarea.actividad = null;
      nuevaTarea.idactividad = null;
    }

    update(['actividades']);
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

  void changeLabor(String id) {
    errorLabor = validatorUtilText(id, 'Labor', {
      'required': '',
    });
    int index = labores?.indexWhere((e) => e.idlabor.toString() == id);
    
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
      toastError('Error', 'No hay personal en dicha sede');
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
      print('regreso');
      nuevaTarea.personal.add(result);
      update(['personal']);
    }
  }

  void goBack() {
    String mensaje = validar();
    if (mensaje == null) {
      nuevaTarea.idusuario=PreferenciasUsuario().idUsuario;
      Get.back(result: nuevaTarea);
    } else {
      toastError('Error', mensaje);
    }
  }

  Future<void> goListadoPersonas() async {
    ListadoPersonasBinding().dependencies();
    final resultados = await Get.to<List<PersonalTareaProcesoEntity>>(
        () => ListadoPersonasPage(),
        arguments: {
          'tarea': nuevaTarea,
          'personal': supervisors
        });

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

  void deleteInicioPausa(){
    nuevaTarea.pausainicio=null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa(){
    nuevaTarea.pausafin=null;
    update(['fin_pausa']);
  }

  String validar() {
    changeFecha();
    changeActividad(nuevaTarea.idactividad.toString());
    changeLabor(nuevaTarea.idlabor.toString());
    changeCentroCosto(nuevaTarea.idcentrocosto.toString());
    changeSupervisor(nuevaTarea.codigoempresa.toString());
    changeHoraInicio();
    changeDiaSiguiente(nuevaTarea.diasiguiente ?? false);
    changeRendimiento(nuevaTarea.esjornal ?? false);
    changeHoraFin();
    //TODO: VALIDAR: fechas por TURNO NOCHE
    if (errorActividad != null) return errorActividad;
    if (errorLabor != null) return errorLabor;
    if (errorSupervisor != null) return errorSupervisor;
    if(errorHoraInicio != null) return errorHoraInicio;
    if(errorHoraFin != null) return errorHoraFin;
    if(errorFecha != null) return errorFecha;
    
    if (nuevaTarea.pausainicio != null && nuevaTarea.pausafin == null){
      errorPausaFin= 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin=null;
    if (nuevaTarea.pausafin != null && nuevaTarea.pausainicio == null){
      errorPausaInicio= 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio=null;
    
    //PUEDEN SER NULOS: inicioPausa y finPausa (00:00:00)

    //TODO: en caso de haber inicio de pausa validar que esten dentro de horafin y horainicio
    return null;
  }
}
