
import 'package:flutter_tareo/di/navigation_binding.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings{


  @override
  void dependencies() {

    /* SplashBinding().dependencies();

    LoginBinding().dependencies(); */

    //RegisterBinding().dependencies();

    NavigationBinding().dependencies();

    /* HomeBinding().dependencies();

    ExploreBinding().dependencies(); */
    //NuevoEventoBinding().dependencies();
    
  }

}