import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  String lastVersion = 'X.X.X';
  String lastVersionDate = '----';
  int modo = 0;
  HomeController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    lastVersion = PreferenciasUsuario().lastVersion;
    lastVersionDate = PreferenciasUsuario().lastVersionDate;
    modo = (PreferenciasUsuario().offLine) ? 0 : 1;
    update(['version', 'modo']);
  }

  void changeModo(dynamic value) {
    modo = value;
    update(['modo']);
  }

  void setModo() {
    PreferenciasUsuario().offLine = (modo == 0) ? true : false;
  }
}
