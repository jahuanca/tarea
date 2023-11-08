import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
import 'package:flutter_tareo/ui/control_asistencia/pages/home_asistencia_page.dart';
import 'package:flutter_tareo/ui/home/pages/home_page.dart';
import 'package:flutter_tareo/ui/home/utils/navigation.dart';
import 'package:flutter_tareo/ui/pages/esparragos/esparragos_page.dart';
import 'package:flutter_tareo/ui/pages/herramientas/herramientas_page.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos/pre_tareos_page.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos_uva/pre_tareos_uva_page.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_page.dart';

enum titles {
  start,
  tareas,
  packing,
  esparrago,
  herramientas,
  asistencias,
  configuracion,
  logout,
}

Map<titles, NavigationItem> NAVIGATIONS = {
  titles.start: NavigationItem(
    icon: Icons.home,
    title: 'Inicio',
    value: 0,
    dependencies: () {},
    widget: HomePage(),
  ),
  titles.tareas: NavigationItem(
    icon: Icons.file_copy,
    title: 'Tareas',
    value: 1,
    dependencies: () => TareasBinding().dependencies(),
    widget: TareasPage(),
  ),
  titles.packing: NavigationItem(
    icon: 'assets/images/uva_icon.png',
    title: 'Packing',
    value: 5,
    dependencies: () {},
    widget: PreTareosUvaPage(),
  ),
  titles.esparrago: NavigationItem(
    icon: 'assets/images/arandano_icon.png',
    title: 'Esparrago',
    value: 6,
    dependencies: () {},
    widget: EsparragosPage(),
  ),
  titles.herramientas: NavigationItem(
    icon: Icons.construction,
    title: 'Herramientas',
    value: 7,
    dependencies: () {},
    widget: HerramientasPage(),
  ),
  titles.asistencias: NavigationItem(
    icon: Icons.person_pin_outlined,
    title: 'Asistencias',
    value: 8,
    dependencies: () {},
    widget: HomeAsistenciaPage(),
  ),
  titles.configuracion: NavigationItem(
    icon: Icons.settings,
    title: 'Configuración',
    value: 9,
    dependencies: () {},
    widget: Container(),
  ),
  titles.logout: NavigationItem(
    icon: Icons.exit_to_app,
    title: 'Cerrar sesión',
    value: 10,
    dependencies: () {},
    widget: Container(),
  ),
};
