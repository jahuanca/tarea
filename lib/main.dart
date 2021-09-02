import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/app.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

