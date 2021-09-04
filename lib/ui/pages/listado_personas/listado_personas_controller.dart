
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:get/get.dart';

class ListadoPersonasController extends GetxController{

  List<int> seleccionados=[];

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