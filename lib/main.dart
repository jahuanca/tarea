import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/strings.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/division_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_perfil_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/ui/app.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

  var path = await getApplicationDocumentsDirectory();
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
  Hive.registerAdapter(LaborEntityAdapter());
  Hive.registerAdapter(UsuarioPerfilEntityAdapter());
  Hive.registerAdapter(PreTareoProcesoEntityAdapter());
  Hive.registerAdapter(LaboresCultivoPackingEntityAdapter());
  Hive.registerAdapter(CultivoEntityAdapter());
  Hive.registerAdapter(PresentacionLineaEntityAdapter());
  Hive.registerAdapter(PreTareoProcesoDetalleEntityAdapter());
  Hive.registerAdapter(PreTareoProcesoUvaEntityAdapter());
  Hive.registerAdapter(PreTareoProcesoUvaDetalleEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoVariosEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoDetalleVariosEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoGrupoEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoDetalleGrupoEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoFormatoEntityAdapter());
  Hive.registerAdapter(PreTareaEsparragoDetalleEntityAdapter());
  Hive.registerAdapter(ClienteEntityAdapter());
  Hive.registerAdapter(TipoTareaEntityAdapter());
  Hive.registerAdapter(EsparragoAgrupaPersonalEntityAdapter());
  Hive.registerAdapter(ViaEnvioEntityAdapter());
  Hive.registerAdapter(CalibreEntityAdapter());
  Hive.registerAdapter(EstadoEntityAdapter());
  Hive.registerAdapter(PersonalPreTareaEsparragoEntityAdapter());

  Database  db=await openDatabase(
    join(await getDatabasesPath(), 'tareo_esparrago.db'),
    onCreate: (db, version) async{
      await db.execute(TABLE_PRETAREAESPARRAGO);
      return await db.execute(TABLE_PERSONALPRETAREAESPARRAGO);
      
    },
    version: 1,
  );

  await db.close();
  

  runApp(MyApp());
}
