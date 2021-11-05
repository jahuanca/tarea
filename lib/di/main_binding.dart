
import 'package:flutter_tareo/di/login_binding.dart';
import 'package:flutter_tareo/di/navigation_binding.dart';
import 'package:flutter_tareo/di/sincronizar_binding.dart';
import 'package:flutter_tareo/di/splash_binding.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings{


  @override
  void dependencies() {

    SplashBinding().dependencies();

    LoginBinding().dependencies(); 

    SincronizarBinding().dependencies(); 

    NavigationBinding().dependencies();
    
  }

}