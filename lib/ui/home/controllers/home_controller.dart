import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/sincronizar/sincronizar_binding.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_page.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  String lastVersion = 'X.X.X';
  String lastVersionDate = '----';
  int modo = ZERO_INT_VALUE;
  HomeController();

  @override
  void onInit() {
    super.onInit();
    PreferenciasUsuario().offLine = BOOLEAN_TRUE_VALUE;
    setLog();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void setLog() {
    lastVersion = PreferenciasUsuario().lastVersion;
    lastVersionDate = PreferenciasUsuario().lastVersionDate;
    modo = (PreferenciasUsuario().offLine) ? ZERO_INT_VALUE : ONE_INT_VALUE;
    update([HOME_PAGE_ID_VERSION, HOME_PAGE_ID_MODE]);
  }

  void changeModo(dynamic value) {
    modo = value;
    update([HOME_PAGE_ID_MODE, HOME_PAGE_ID_REFRESH]);
  }

  void setModo() {
    PreferenciasUsuario().offLine =
        (modo == ZERO_INT_VALUE) ? BOOLEAN_TRUE_VALUE : BOOLEAN_FALSE_VALUE;
  }

  Future<void> goSincronizar() async {
    SincronizarBinding().dependencies();
    await Get.to(() => SincronizarPage());
    setLog();
  }
}
