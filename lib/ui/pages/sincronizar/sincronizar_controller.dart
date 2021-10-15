
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/get_current_time_world_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_pre_tareo_procesos_use_case.dart';
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
  List<PreTareoProcesoEntity> preTareos=[];
  List<CentroCostoEntity> centrosCosto=[];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking=[];

  final GetActividadsUseCase _getActividadsUseCase;
  final GetSubdivisonsUseCase _getSubdivisonsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  final GetUsuariosUseCase _getUsuariosUseCase;
  final GetPersonalsEmpresaUseCase _getPersonalsEmpresaUseCase;
  final GetCentroCostosUseCase _getCentroCostosUseCase;
  final GetCurrentTimeWorldUseCase _getCurrentTimeWorldUseCase;
  final GetPreTareoProcesosUseCase _getPreTareoProcesosUseCase;
  final GetLaboresCultivoPackingUseCase _getLaboresCultivoPackingUseCase;

  SincronizarController(this._getActividadsUseCase, this._getSubdivisonsUseCase, this._getLaborsUseCase, this._getUsuariosUseCase, this._getPersonalsEmpresaUseCase, this._getCentroCostosUseCase, this._getCurrentTimeWorldUseCase, this._getPreTareoProcesosUseCase, this._getLaboresCultivoPackingUseCase);

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
    await getLabores();
    await getCentrosCosto();
    await getUsuarios();
    await getPersonal();
    await getPreTareos();
    await getLaboresCultivoPacking();
    validando=false;
    update(['validando']);
    await setLog();
    PreferenciasUsuario().offLine=true;
  }


  Future<bool> getPreTareos()async{
    preTareos=await _getPreTareoProcesosUseCase.execute();
    Box<PreTareoProcesoEntity> preTareosSincronizados = await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
    
    await preTareosSincronizados?.clear();
    await preTareosSincronizados.addAll(preTareos);
    await preTareosSincronizados.close();
    update(['pre_tareos']);
    return true;
  }

  Future<bool> getLaboresCultivoPacking()async{
    laboresCultivoPacking=await _getLaboresCultivoPackingUseCase.execute();
    Box<LaboresCultivoPackingEntity> laboresCultivoPackingSincronizados = await Hive.openBox<LaboresCultivoPackingEntity>('labores_cultivo_packing_sincronizar');
    
    await laboresCultivoPackingSincronizados?.clear();
    await laboresCultivoPackingSincronizados.addAll(laboresCultivoPacking);
    await laboresCultivoPackingSincronizados.close();
    update(['labores_cultivo_packing']);
    return true;
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
    PreferenciasUsuario().lastVersionDate=formatoFechaHora((await _getCurrentTimeWorldUseCase.execute()).datetime);
    print(PreferenciasUsuario().lastVersion);
    print(PreferenciasUsuario().lastVersionDate);
    await logs.add(
      new LogEntity(
        id: DateTime.now().microsecond,
        fecha: DateTime.now(),
        version: version,
      )
    );
    await logs.close();
    update(['version']);
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
    Box<CentroCostoEntity> centrosCostoSincronizados = await Hive.openBox<CentroCostoEntity>('centros_costo_sincronizar');
    await centrosCostoSincronizados.clear();
    await centrosCostoSincronizados.addAll(centrosCosto);
    await centrosCostoSincronizados.close();
    update(['centro_costo']);
  }


}