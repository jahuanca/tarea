
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

class SincronizarController extends GetxController{

  List<ActividadEntity> actividades=[];
  List<LaborEntity> labores=[];
  List<SubdivisionEntity> sedes=[];
  List<UsuarioEntity> usuarios=[];
  List<PersonalEmpresaEntity> personal=[];
  List<CentroCostoEntity> centrosCosto=[];

  GetActividadsUseCase _getActividadsUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;
  GetLaborsUseCase _getLaborsUseCase;
  GetUsuariosUseCase _getUsuariosUseCase;
  GetPersonalsEmpresaUseCase _getPersonalsEmpresaUseCase;
  GetCentroCostosUseCase _getCentroCostosUseCase;

  SincronizarController(this._getActividadsUseCase, this._getSubdivisonsUseCase, this._getLaborsUseCase, this._getUsuariosUseCase, this._getPersonalsEmpresaUseCase, this._getCentroCostosUseCase);

  bool validando=false;

  @override
  void onInit(){
    super.onInit();
    PreferenciasUsuario().offLine=false;
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
    await getCentrosCosto();
    await getPersonal();
    validando=false;
    update(['validando']);
    await setLog();
    PreferenciasUsuario().offLine=true;
  }


  Future<bool> getActividades()async{
    actividades=await _getActividadsUseCase.execute();
    Box<ActividadEntity> actividadesSincronizadas = await Hive.openBox<ActividadEntity>('actividades_sincronizar');
    
    await actividadesSincronizadas?.clear();
    await actividadesSincronizadas.addAll(actividades);
    await actividadesSincronizadas.close();
    update(['actividades']);
    return true;
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
    labores= await _getLaborsUseCase.execute();
    var laboresSincronizadas = await Hive.openBox<LaborEntity>('labores_sincronizar');
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
    print(PreferenciasUsuario().lastVersion);
    print(PreferenciasUsuario().lastVersionDate);
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

  Future<void> getPersonal()async{
    personal= await _getPersonalsEmpresaUseCase.execute();
    var personalSincronizadas = await Hive.openBox<PersonalEmpresaEntity>('personal_sincronizar');
    await personalSincronizadas.clear();
    await personalSincronizadas.addAll(personal);
    await personalSincronizadas.close();
    update(['personal_empresa']);
  }

  Future<void> getCentrosCosto()async{
    centrosCosto= await _getCentroCostosUseCase.execute();
    Box<PersonalEmpresaEntity> centrosCostoSincronizados = await Hive.openBox<PersonalEmpresaEntity>('centros_costo_sincronizar');
    await centrosCostoSincronizados.clear();
    await centrosCostoSincronizados.addAll(personal);
    await centrosCostoSincronizados.close();
    update(['centro_costo']);
  }


}