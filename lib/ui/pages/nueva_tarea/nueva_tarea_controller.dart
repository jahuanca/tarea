
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
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

  List<TempActividadEntity> actividades=[];
  List<TempLaborEntity> labores=[];
  List<SubdivisionEntity> subdivisions=[];
  List<PersonalEmpresaEntity> supervisors=[];


  List<PersonalEmpresaEntity> personal= [];

  NuevaTareaController(this._getTemActividadsUseCase, this._getTempLaborsUseCase, this._getSubdivisonsUseCase, this._getPersonalsEmpresaBySubdivisionUseCase);

  @override
  void onInit(){
    super.onInit();
    
  }

  @override
  void onReady()async{
    super.onReady();
    validando=true;
    update(['validando']);
    await getActividades();
    await getLabores();
    await getSubdivisions();
    /* await getSupervisors(); */
    validando=false;
    update(['validando']);
  }

  Future<void> getActividades()async{
    actividades=await _getTemActividadsUseCase.execute();
    nuevaTarea.actividad=actividades?.first;
    update(['actividades']);
  }

  Future<void> getSubdivisions()async{
    subdivisions=await _getSubdivisonsUseCase.execute();
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
    nuevaTarea.labor=labores.first;
    update(['labores']);
  }

  void changeHoraInicio(){
    nuevaTarea.fecha=horaInicio;
    update(['hora_inicio']);
  }

  void changeHoraFin(){
    nuevaTarea.fecha=horaFin;
    update(['hora_fin']);
  }

  void changeInicioPausa(){
    nuevaTarea.fecha=inicioPausa;
    update(['inicio_pausa']);
  }

  void changeFinPausa(){
    nuevaTarea.fecha=finPausa;
    update(['fin_pausa']);
  }

  void changeFecha(){
    nuevaTarea.fecha=fecha;
    update(['fecha']);
  }

  void changeSupervisor(String id){
    int index=personal.indexWhere((e) => e.codigoempresa==id);
    if(index!=-1){
      nuevaTarea.supervisor=personal[index];
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
    AgregarPersonaBinding().dependencies();
    final result= await Get.to<PersonalTareaProcesoEntity>(() => AgregarPersonaPage() );
    if(result!=null){
      print('regreso');
      if(nuevaTarea.personal==null) nuevaTarea.personal= [];
      nuevaTarea.personal.add(result);
      update(['personal']);
    }
  }

  void goBack(){
    Get.back(result: nuevaTarea);
  }

  Future<void> goListadoPersonas()async{
    final resultados=await Get.to<List<PersonalTareaProcesoEntity>>(() => ListadoPersonasPage(), arguments: {'personal_seleccionado': nuevaTarea.personal, 'personal': supervisors});

    if(resultados!=null){
      nuevaTarea.personal=resultados;
    }
  }

}