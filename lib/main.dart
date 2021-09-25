import 'package:flutter/material.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/division_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/ui/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

  var path=await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(LogEntityAdapter());
  Hive.registerAdapter(TareaProcesoEntityAdapter());
  Hive.registerAdapter(TempActividadEntityAdapter());
  Hive.registerAdapter(ActividadEntityAdapter());
  Hive.registerAdapter(TempLaborEntityAdapter());
  Hive.registerAdapter(PersonalEmpresaEntityAdapter());
  Hive.registerAdapter(SubdivisionEntityAdapter());
  Hive.registerAdapter(PersonalTareaProcesoEntityAdapter());
  Hive.registerAdapter(PersonalEmpresaSubdivisionEntityAdapter());
  Hive.registerAdapter(UsuarioEntityAdapter());
  Hive.registerAdapter(CentroCostoEntityAdapter());
  Hive.registerAdapter(DivisionEntityAdapter());
  
  runApp(MyApp());
}

