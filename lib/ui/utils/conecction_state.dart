import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> hasInternet() async {
    ConnectivityResult conectividad = await Connectivity().checkConnectivity();
    bool bandera=conectividad != ConnectivityResult.none ? true : false;
    /* if(!bandera) toastAdvertencia('Advertencia', 'Verifique su conexion a internet'); */
    return bandera;
  }