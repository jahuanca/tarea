
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:get/get.dart';

class ListadoPersonasController extends GetxController{

  List<int> seleccionados=[];
  List<PersonalEmpresaEntity> personal=[];

  @override
  void onInit(){
    super.onInit();
    if(Get.arguments!=null){
      if(Get.arguments['personal']!=null){
        personal=Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      }
    }
  }

  void seleccionar(int index){
    int i=seleccionados.indexWhere((element) => element==index);
    if(i==-1){
      seleccionados.add(index);
    }else{
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  void changeOptionsGlobal(dynamic index){
    switch (index) {
      case 3:
        Get.to( () => AgregarPersonaPage(), arguments: {'cantidad' : 4});
        break;
      default:
    }
  }
}