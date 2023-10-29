import 'package:flutter_tareo/domain/use_cases/splash/get_token_use_case.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:imei_plugin/imei_plugin.dart';

class SplashController extends GetxController {
  GetTokenUseCase _getTokenUseCase;

  SplashController(this._getTokenUseCase);

  @override
  void onInit() async {
    super.onInit();

    String imei = await ImeiPlugin.getImei();
    /* List<String> multiImei =await ImeiPlugin.getImeiMulti(); //for double-triple SIM phones */
    String uuid = await ImeiPlugin.getId();
    print('Imei: $imei');
    print('UUDI: $uuid');
    PreferenciasUsuario().imei= imei;
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(Duration(seconds: 2));
    String token = await _getTokenUseCase.execute();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String lastVersion = packageInfo.version;
    PreferenciasUsuario().lastVersion = lastVersion;
    if (token != null) {
      Get.offAndToNamed('navigation');
    } else {
      Get.offAndToNamed('login');
    }
  }
}
