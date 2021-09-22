
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class NuevaTareaController extends GetxController{

  GetTempActividadsUseCase _getTemActividadsUseCase;
  GetTempLaborsUseCase _getTempLaborsUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;
  GetPersonalsEmpresaBySubdivisionUseCase _getPersonalsEmpresaBySubdivisionUseCase;
  
  DateTime horaInicio, horaFin, inicioPausa, finPausa;
  DateTime fecha=new DateTime.now();

  TareaProcesoEntity nuevaTarea=new TareaProcesoEntity();

  bool validando=false;
  bool editando=false;

  List<TempActividadEntity> actividades=[];
  List<TempLaborEntity> labores=[];
  List<SubdivisionEntity> subdivisions=[];
  List<PersonalEmpresaEntity> supervisors=[];


  NuevaTareaController(this._getTemActividadsUseCase, this._getTempLaborsUseCase, this._getSubdivisonsUseCase, this._getPersonalsEmpresaBySubdivisionUseCase);

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
      
      update(['hora_inicio','editando', 'hora_fin', 'pausa_inicio', 'pausa_fin', 'subdivisions']);
    }
  }

  @override
  void onReady()async{
    super.onReady();
    validando=true;
    update(['validando']);
    await getActividades();
    await getLabores();
    await getSubdivisions();
    validando=false;
    update(['validando']);

    setEditValues();
  }

  Future<void> getActividades()async{
    actividades=await _getTemActividadsUseCase.execute();
    nuevaTarea.actividad=actividades?.first;
    update(['actividades']);
  }

  Future<void> getSubdivisions()async{
    subdivisions=await _getSubdivisonsUseCase.execute();
    if(!editando)
    nuevaTarea.sede=subdivisions?.first;
    update(['subdivisions']);
    await getSupervisors(nuevaTarea.sede.idsubdivision ?? 0);
  }

  Future<void> getSupervisors(int idSubdivision)async{
    validando=true;
    update(['validando']);
    supervisors=await _getPersonalsEmpresaBySubdivisionUseCase.execute(idSubdivision);
    if(supervisors.length>0){
      nuevaTarea.supervisor=supervisors.first;
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

  Future<void> changeSede(String id)async{
    int index=subdivisions.indexWhere((e) => e.idsubdivision==int.parse(id));
    if(index!=-1){
      nuevaTarea.sede=subdivisions[index];
      await getSupervisors(int.parse(id));
    }
    return;
    /* nuevaTarea.=int.parse(id); */
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

  String validar(){
    if(nuevaTarea.sede==null) return 'Debe seleccionar una sede';
    if(nuevaTarea.actividad==null) return 'Debe seleccionar una actividad';
    if(nuevaTarea.labor==null) return 'Debe seleccionar una labor';
    if(nuevaTarea.supervisor==null) return 'Debe seleccionar un supervisor';
    //if(nuevaTarea.turno==null) return 'Debe seleccionar un supervisor';
    if(nuevaTarea.horainicio==null) return 'Debe elegir una hora de inicio';
    if(nuevaTarea.horafin==null) return 'Debe elegir una hora fin';
    if(nuevaTarea.pausainicio==null) return 'Debe elegir un inicio de pausa';
    if(nuevaTarea.pausafin==null) return 'Debe elegir un fin de pausa';
    return null;
  }

}