
import 'package:flutter_tareo/ui/pages/esparragos/esparragos_controller.dart';
import 'package:get/get.dart';

class EsparragosBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<EsparragosController>(() => EsparragosController());
    
  }

}