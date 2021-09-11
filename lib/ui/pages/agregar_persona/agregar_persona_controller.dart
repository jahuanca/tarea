
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:get/get.dart';

class AgregarPersonaController extends GetxController{

  GetPersonalsEmpresaUseCase _getPersonalsEmpresaUseCase;
  int cantidadEnviada=0;
  List<PersonalEmpresaEntity> personalEmpresa = [];
  bool validando=false;

  PersonalEmpresaEntity personaSeleccionada;

  AgregarPersonaController(this._getPersonalsEmpresaUseCase);

  @override
  void onInit()async{
    super.onInit();
    if(Get.arguments!=null){
      if(Get.arguments['cantidad']!=null){
        cantidadEnviada=Get.arguments['cantidad'] as int;
      }
    }
    validando=true;
    update(['validando']);
    personalEmpresa=await _getPersonalsEmpresaUseCase.execute();
    if(personalEmpresa.length>0){
      personaSeleccionada=personalEmpresa.first;
    }
    validando=false;
    update(['personal', 'validando']);
  }

  void changePersonal(String id){
    personaSeleccionada=personalEmpresa.firstWhere((e) => e.codigoempresa==id);
  }

  void guardar(){
    Get.back(result: personaSeleccionada);
  }

  
}