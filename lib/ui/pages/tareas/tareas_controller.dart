
import 'package:get/get.dart';

class TareasController extends GetxController{

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
}