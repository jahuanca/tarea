
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';

class NuevaTareaController extends GetxController{

  GetTempActividadsUseCase _getTemActividadsUseCase;
  GetTempLaborsUseCase _getTempLaborsUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;

  DateTime horaInicio, horaFin, inicioPausa, finPausa;
  DateTime fecha=new DateTime.now();

  bool validando=false;

  List<TempActividadEntity> actividades=[];
  List<TempLaborEntity> labores=[];
  List<SubdivisionEntity> subdivisions=[];
  List<PersonalEmpresaEntity> personal= [];

  NuevaTareaController(this._getTemActividadsUseCase, this._getTempLaborsUseCase, this._getSubdivisonsUseCase);

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
    validando=false;
    update(['validando']);
  }

  Future<void> getActividades()async{
    actividades=await _getTemActividadsUseCase.execute();
    update(['actividades']);
  }

  Future<void> getSubdivisions()async{
    subdivisions=await _getSubdivisonsUseCase.execute();
    update(['subdivisions']);
  }

  Future<void> getLabores()async{
    labores=await _getTempLaborsUseCase.execute();
    update(['labores']);
  }

  

  void changeHoraInicio(){
    update(['hora_inicio']);
  }

  void changeHoraFin(){
    update(['hora_fin']);
  }

  void changeInicioPausa(){
    update(['inicio_pausa']);
  }

  void changeFinPausa(){
    update(['fin_pausa']);
  }

  void changeFecha(){
    update(['fecha']);
  }

  Future<void> goAgregarPersona() async{
    AgregarPersonaBinding().dependencies();
    final result= await Get.to<PersonalEmpresaEntity>(() => AgregarPersonaPage() );
    if(result!=null){
      personal.add(result);
      update(['personal']);
    }
  }

  void goListadoPersonas(){
    Get.to(() => ListadoPersonasPage(), arguments: {'personal': personal});
  }

}