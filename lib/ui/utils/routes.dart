import 'package:flutter_tareo/ui/home/pages/home_page.dart';
import 'package:flutter_tareo/ui/home/pages/navigation_page.dart';

import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/login/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/login/pages/splash_page.dart';

Map<String, Widget Function(BuildContext)> getAplicattionRoutes() {
  return {
    '/': (BuildContext context) => SplashPage(),
    'navigation': (BuildContext context) => (NavigationPage()),
    'login': (BuildContext context) => (LoginPage()),
    'nueva_tarea': (BuildContext context) => (NuevaTareaPage()),
    'listado_personas': (BuildContext context) => (ListadoPersonasPage()),
    'agregar_persona': (BuildContext context) => (AgregarPersonaPage()),
    'home': (BuildContext context) => (HomePage()),
  };
}
