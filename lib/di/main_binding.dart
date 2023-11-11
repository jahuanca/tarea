import 'package:flutter_tareo/di/login/login_binding.dart';
import 'package:flutter_tareo/di/home/navigation_binding.dart';
import 'package:flutter_tareo/di/sincronizar/sincronizar_binding.dart';
import 'package:flutter_tareo/di/login/splash_binding.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    SplashBinding().dependencies();

    LoginBinding().dependencies();

    SincronizarBinding().dependencies();

    NavigationBinding().dependencies();
  }
}
