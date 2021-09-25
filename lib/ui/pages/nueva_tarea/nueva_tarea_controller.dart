
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class NuevaTareaController extends GetxController{

  GetActividadsByKeyUseCase _getActividadsByKeyUseCase;
  GetTempLaborsUseCase _getTempLaborsUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;
  GetPersonalsEmpresaBySubdivisionUseCase _getPersonalsEmpresaBySubdivisionUseCase;
  
  DateTime horaInicio, horaFin, inicioPausa, finPausa;
  DateTime fecha=new DateTime.now();

  TareaProcesoEntity nuevaTarea=new TareaProcesoEntity();

  bool validando=false;
  bool editando=false;
  bool rendimiento=true;

  List<ActividadEntity> actividades=[];
  List<TempLaborEntity> labores=[];
  List<SubdivisionEntity> subdivisions=[];
  List<PersonalEmpresaEntity> supervisors=[];


  NuevaTareaController(this._getActividadsByKeyUseCase, this._getTempLaborsUseCase, this._getSubdivisonsUseCase, this._getPersonalsEmpresaBySubdivisionUseCase);

  @override
  void onInit(){
    super.onInit();
    if(Get.arguments!=null){
      if(Get.arguments['tarea'] != null){
        editando=true;
        nuevaTarea=Get.arguments['tarea'] as TareaProcesoEntity;
      }
    }
  }

  void setEditValues(){
    if(editando){
      horaInicio=nuevaTarea.horainicio;
      horaFin=nuevaTarea.horafin;
      inicioPausa=nuevaTarea.pausainicio;
      finPausa=nuevaTarea.pausafin;
      update(['hora_inicio','editando', 'hora_fin', 'pausa_inicio', 'pausa_fin']);
    }
  }

  @override
  void onReady()async{
    super.onReady();
    validando=true;
    update(['validando']);
    await getActividades(rendimiento ? 'esrendimiento' : 'esjornal', true);
    await getLabores();
    await getSupervisors(PreferenciasUsuario().sede);
    validando=false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getActividades(String key, dynamic value)async{
    actividades=await _getActividadsByKeyUseCase.execute(key, value);
    if(actividades.length>0){
      nuevaTarea.actividad=actividades?.first;
    }
    update(['actividades']);
  }

  Future<void> getSupervisors(int idSubdivision)async{
    nuevaTarea.sede=(await _getSubdivisonsUseCase.execute()).firstWhere((e) => e.idsubdivision==idSubdivision);
    validando=true;
    update(['validando']);
    supervisors=await _getPersonalsEmpresaBySubdivisionUseCase.execute(5);
    if(supervisors.length>0){
      nuevaTarea.supervisor=supervisors[1];
    }
    update(['supervisors']);
    validando=false;
    update(['validando']);
  }

  Future<void> getLabores()async{
    labores=await _getTempLaborsUseCase.execute();
    if(!editando)
    nuevaTarea.labor=labores.first;
    update(['labores']);
  }

  void changeHoraInicio(){
    nuevaTarea.horainicio=horaInicio;
    update(['hora_inicio']);
  }

  void changeHoraFin(){
    nuevaTarea.horafin=horaFin;
    update(['hora_fin']);
  }

  void changeInicioPausa(){
    nuevaTarea.pausainicio=inicioPausa;
    update(['inicio_pausa']);
  }

  void changeFinPausa(){
    nuevaTarea.pausafin=finPausa;
    update(['fin_pausa']);
  }

  void changeFecha(){
    nuevaTarea.fecha=fecha;
    update(['fecha']);
  }

  void changeSupervisor(String id){
    int index=supervisors.indexWhere((e) => e.codigoempresa==id);
    if(index!=-1){
      nuevaTarea.supervisor=supervisors[index];
    }
    nuevaTarea.codigoempresa=id;
  }

  void changeActividad(String id){
    int index=actividades.indexWhere((e) => e.actividad==id);
    if(index!=-1){
      nuevaTarea.actividad=actividades[index];
    }
    nuevaTarea.idactividad=int.parse(id);
  }

  Future<void> goAgregarPersona() async{

    if(supervisors.length==0){
      toastError('Error', 'No hay personal en dicha sede');
      return;
    }

    AgregarPersonaBinding().dependencies();
    final result= await Get.to<PersonalTareaProcesoEntity>(() => AgregarPersonaPage(), 
    arguments: {
      'personal' : supervisors,
      'tarea': nuevaTarea,
    } );
    if(result!=null){
      print('regreso');
      if(nuevaTarea.personal==null) nuevaTarea.personal= [];
      nuevaTarea.personal.add(result);
      update(['personal']);
    }
  }

  void goBack(){
    String mensaje=validar();
    if(mensaje==null){
      Get.back(result: nuevaTarea);
    }else{
      toastError('Error', mensaje);
    }
  }

  Future<void> goListadoPersonas()async{
    ListadoPersonasBinding().dependencies();
    final resultados=await Get.to<List<PersonalTareaProcesoEntity>>(() => ListadoPersonasPage(), arguments: {'personal_seleccionado': nuevaTarea.personal, 'personal': supervisors});

    if(resultados!=null){
      nuevaTarea.personal=resultados;
    }
  }

  Future<void> changeDiaSiguiente(bool value){
    nuevaTarea.diasiguiente=value;
    update(['dia_siguiente']);
  }

  Future<void> changeRendimiento(bool value)async{
    rendimiento=value;
    await getActividades(rendimiento ? 'esrendimiento' : 'esjornal', true);
    update(['rendimiento', 'actividades']);
  }

  String validar(){
    if(nuevaTarea.sede==null) return 'Debe seleccionar una sede';
    if(nuevaTarea.actividad==null) return 'Debe seleccionar una actividad';
    if(nuevaTarea.labor==null) return 'Debe seleccionar una labor';
    if(nuevaTarea.supervisor==null) return 'Debe seleccionar un supervisor';
    //if(nuevaTarea.turno==null) return 'Debe seleccionar un supervisor';
    if(nuevaTarea.horainicio==null) return 'Debe elegir una hora de inicio';
    if(nuevaTarea.horafin==null) return 'Debe elegir una hora fin';
    //TODO: en caso de haber inicio de pausa validar que esten dentro de horafin y horainicio
    /* if(nuevaTarea.pausainicio==null) return 'Debe elegir un inicio de pausa';
    if(nuevaTarea.pausafin==null) return 'Debe elegir un fin de pausa'; */
    return null;
  }

}