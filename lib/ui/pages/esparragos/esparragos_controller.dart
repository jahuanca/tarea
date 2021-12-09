
import 'package:flutter_tareo/di/clasficados_binding.dart';
import 'package:flutter_tareo/di/pesados_binding.dart';
import 'package:flutter_tareo/di/seleccion_binding.dart';
import 'package:flutter_tareo/ui/pages/clasificados/clasificados_page.dart';
import 'package:flutter_tareo/ui/pages/pesados/pesados_page.dart';
import 'package:flutter_tareo/ui/pages/seleccion/seleccion_page.dart';
import 'package:get/get.dart';

class EsparragosController extends GetxController {
  
  bool validando = false;

  EsparragosController();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void goClasificados(){
    ClasificadosBinding().dependencies();
    Get.to(() => ClasificadosPage());
  }

  void goVarios(){
    PesadosBinding().dependencies();
    Get.to(() => PesadosPage());
  }

  void goSeleccion(){
    SeleccionBinding().dependencies();
    Get.to(() => SeleccionPage());
  }

  
}
