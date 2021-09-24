
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

class SincronizarController extends GetxController{

  List<TempActividadEntity> actividades=[];
  List<TempLaborEntity> labores=[];
  List<SubdivisionEntity> sedes=[];
  List<UsuarioEntity> usuarios=[];

  GetTempActividadsUseCase _getTempActividadsUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;
  GetTempLaborsUseCase _getTempLaborsUseCase;
  GetUsuariosUseCase _getUsuariosUseCase;

  SincronizarController(this._getTempActividadsUseCase, this._getSubdivisonsUseCase, this._getTempLaborsUseCase, this._getUsuariosUseCase);

  bool validando=false;

  @override
  void onInit(){
    super.onInit();
    validando=true;
    update(['validando']);

  }

  @override
  void onReady()async{
    super.onReady();
    await getActividades();
    await getSedes();
    await getUsuarios();
    await getLabores();
    validando=false;
    update(['validando']);
    await setLog();

  }


  Future<void> getActividades()async{
    actividades= await _getTempActividadsUseCase.execute();
    var actividadesSincronizadas = await Hive.openBox<TempActividadEntity>('actividades_sincronizar');
    await actividadesSincronizadas.clear();
    await actividadesSincronizadas.addAll(actividades);
    await actividadesSincronizadas.close();
    update(['actividades']);
  }

  Future<void> getSedes()async{
    sedes= await _getSubdivisonsUseCase.execute();
    var sedesSincronizadas = await Hive.openBox<SubdivisionEntity>('sedes_sincronizar');
    await sedesSincronizadas.clear();
    await sedesSincronizadas.addAll(sedes);
    await sedesSincronizadas.close();
    update(['sedes']);
  }

  Future<void> getLabores()async{
    labores= await _getTempLaborsUseCase.execute();
    var laboresSincronizadas = await Hive.openBox<TempLaborEntity>('labores_sincronizar');
    await laboresSincronizadas.clear();
    await laboresSincronizadas.addAll(labores);
    await laboresSincronizadas.close();
    update(['labores']);
  }

  Future<void> setLog()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var logs = await Hive.openBox<LogEntity>('log_sincronizar');
    PreferenciasUsuario().lastVersion=version;
    PreferenciasUsuario().lastVersionDate=formatoFechaHora(DateTime.now());
    logs.add(
      new LogEntity(
        id: DateTime.now().microsecond,
        fecha: DateTime.now(),
        version: version,
      )
    );
  }

  Future<void> getUsuarios()async{
    usuarios= await _getUsuariosUseCase.execute();
    var usuariosSincronizadas = await Hive.openBox<UsuarioEntity>('usuarios_sincronizar');
    await usuariosSincronizadas.clear();
    await usuariosSincronizadas.addAll(usuarios);
    await usuariosSincronizadas.close();
    update(['usuarios']);

  }


}