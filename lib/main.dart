import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/strings/sqLiteDB.dart';

import 'package:flutter_tareo/ui/app.dart';
import 'package:flutter_tareo/ui/utils/adapters.dart';
import 'package:path/path.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

  initAdapters();

  Database db = await openDatabase(
    join(await getDatabasesPath(), 'tareo_esparrago.db'),
    onCreate: (db, version) async {
      await db.execute(TABLE_PRETAREAESPARRAGO);
      return await db.execute(TABLE_PERSONALPRETAREAESPARRAGO);
    },
    version: 1,
  );

  await db.close();

  runApp(MyApp());
}
