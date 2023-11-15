import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_turnos_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_ubicacions_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_current_time_world_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_esparrago_agrupa_personal_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_estados_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_pre_tareo_procesos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_tipo_tareas_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

class SincronizarController extends GetxController {
  List<LaborEntity> labores = [];
  List<EsparragoAgrupaPersonalEntity> agrupaPersonals = [];
  List<SubdivisionEntity> sedes = [];
  List<UsuarioEntity> usuarios = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PreTareoProcesoEntity> preTareos = [];
  List<ClienteEntity> clientes = [];
  List<TipoTareaEntity> tipoTareas = [];
  List<CentroCostoEntity> centrosCosto = [];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking = [];
  List<CultivoEntity> cultivos = [];
  List<EstadoEntity> estados = [];
  List<CalibreEntity> calibres = [];
  List<ViaEnvioEntity> viaEnvios = [];
  int sizeTurnos = ZERO_INT_VALUE;
  int sizeUbicacions = ZERO_INT_VALUE;
  int sizePersonal = ZERO_INT_VALUE;
  int sizeActividads = ZERO_INT_VALUE;

  final GetSubdivisonsUseCase _getSubdivisonsUseCase;
  final GetLaborsUseCase _getLaborsUseCase;
  final GetUsuariosUseCase _getUsuariosUseCase;
  final GetCentroCostosUseCase _getCentroCostosUseCase;
  final GetCurrentTimeWorldUseCase _getCurrentTimeWorldUseCase;
  final GetPreTareoProcesosUseCase _getPreTareoProcesosUseCase;
  final GetLaboresCultivoPackingUseCase _getLaboresCultivoPackingUseCase;
  final GetCultivosUseCase _getCultivosUseCase;
  final GetEstadosUseCase _getEstadosUseCase;
  final GetClientesUseCase _getClientesUseCase;
  final GetTipoTareasUseCase _getTipoTareasUseCase;
  final GetViaEnviosUseCase _getViaEnviosUseCase;
  final GetEsparragoAgrupaPersonalsUseCase _getEsparragoAgrupaPersonalsUseCase;
  final GetCalibresUseCase _getCalibresUseCase;
  final SincronizarTurnosUseCase _sincronizarTurnosUseCase;
  final SincronizarUbicacionsUseCase _sincronizarUbicacionsUseCase;
  final SincronizarPersonalEmpresasUseCase _sincronizarPersonalEmpresasUseCase;
  final SincronizarActividadsUseCase _sincronizarActividadsUseCase;

  SincronizarController(
    this._sincronizarActividadsUseCase,
    this._getEstadosUseCase,
    this._getViaEnviosUseCase,
    this._getCalibresUseCase,
    this._getSubdivisonsUseCase,
    this._getLaborsUseCase,
    this._getUsuariosUseCase,
    this._getCentroCostosUseCase,
    this._getCurrentTimeWorldUseCase,
    this._getPreTareoProcesosUseCase,
    this._getLaboresCultivoPackingUseCase,
    this._getCultivosUseCase,
    this._getClientesUseCase,
    this._getTipoTareasUseCase,
    this._getEsparragoAgrupaPersonalsUseCase,
    this._sincronizarTurnosUseCase,
    this._sincronizarUbicacionsUseCase,
    this._sincronizarPersonalEmpresasUseCase,
  );

  bool validando = false;

  @override
  void onInit() {
    super.onInit();
    PreferenciasUsuario().offLine = false;
    validando = true;
    update(['validando']);
  }

  @override
  void onReady() async {
    super.onReady();

    await getSedes();
    await getLabores();
    await getCentrosCosto();
    await getUsuarios();
    await getCultivos();
    await getClientes();
    await getEstados();
    await getCalibres();
    await getViaEnvios();
    await getTipoTareas();
    await getEsparragoAgrupaPersonal();

    sizeTurnos = await _sincronizarTurnosUseCase.execute();
    sizeUbicacions = await _sincronizarUbicacionsUseCase.execute();
    sizePersonal = await _sincronizarPersonalEmpresasUseCase.execute();
    sizeActividads = await _sincronizarActividadsUseCase.execute();
    validando = BOOLEAN_FALSE_VALUE;
    await setLog();
    update([VALIDANDO_ID]);
    PreferenciasUsuario().offLine = BOOLEAN_TRUE_VALUE;
  }

  Future<bool> getClientes() async {
    clientes = await _getClientesUseCase.execute();
    Box<ClienteEntity> clientesSincronizados =
        await Hive.openBox<ClienteEntity>('clientes_sincronizar');

    await clientesSincronizados?.clear();
    await clientesSincronizados.addAll(clientes);
    await clientesSincronizados.compact();
    await clientesSincronizados.close();
    update(['clientes']);
    return true;
  }

  Future<bool> getCalibres() async {
    calibres = await _getCalibresUseCase.execute();
    Box<CalibreEntity> calibresSincronizados =
        await Hive.openBox<CalibreEntity>('calibres_sincronizar');

    await calibresSincronizados?.clear();
    await calibresSincronizados.addAll(calibres);
    await calibresSincronizados.compact();
    await calibresSincronizados.close();
    update(['calibres']);
    return true;
  }

  Future<bool> getViaEnvios() async {
    viaEnvios = await _getViaEnviosUseCase.execute();
    Box<ViaEnvioEntity> viaEnviosSincronizados =
        await Hive.openBox<ViaEnvioEntity>('via_envios_sincronizar');

    await viaEnviosSincronizados?.clear();
    await viaEnviosSincronizados.addAll(viaEnvios);
    await viaEnviosSincronizados.compact();
    await viaEnviosSincronizados.close();
    update(['via_envios']);
    return true;
  }

  Future<bool> getEstados() async {
    estados = await _getEstadosUseCase.execute();
    Box<EstadoEntity> estadosSincronizados =
        await Hive.openBox<EstadoEntity>('estados_sincronizar');

    await estadosSincronizados?.clear();
    await estadosSincronizados.addAll(estados);
    await estadosSincronizados.compact();
    await estadosSincronizados.close();
    update(['estados']);
    return true;
  }

  Future<bool> getTipoTareas() async {
    tipoTareas = await _getTipoTareasUseCase.execute();
    Box<TipoTareaEntity> tipoTareasSincronizados =
        await Hive.openBox<TipoTareaEntity>('tipo_tareas_sincronizar');

    await tipoTareasSincronizados?.clear();
    await tipoTareasSincronizados.addAll(tipoTareas);
    await tipoTareasSincronizados.compact();
    await tipoTareasSincronizados.close();
    update(['tipo_tareas']);
    return true;
  }

  Future<bool> getPreTareos() async {
    preTareos = await _getPreTareoProcesosUseCase.execute();
    Box<PreTareoProcesoEntity> preTareosSincronizados =
        await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');

    await preTareosSincronizados?.clear();
    await preTareosSincronizados.addAll(preTareos);
    await preTareosSincronizados.compact();
    await preTareosSincronizados.close();
    update(['pre_tareos']);
    return true;
  }

  Future<bool> getLaboresCultivoPacking() async {
    laboresCultivoPacking = await _getLaboresCultivoPackingUseCase.execute();
    Box<LaboresCultivoPackingEntity> laboresCultivoPackingSincronizados =
        await Hive.openBox<LaboresCultivoPackingEntity>(
            'labores_cultivo_packing_sincronizar');

    await laboresCultivoPackingSincronizados?.clear();
    await laboresCultivoPackingSincronizados.addAll(laboresCultivoPacking);
    await laboresCultivoPackingSincronizados.compact();
    await laboresCultivoPackingSincronizados.close();
    update(['labores_cultivo_packing']);
    return true;
  }

  Future<void> getSedes() async {
    sedes = await _getSubdivisonsUseCase.execute();
    var sedesSincronizadas =
        await Hive.openBox<SubdivisionEntity>('sedes_sincronizar');
    await sedesSincronizadas.clear();
    await sedesSincronizadas.addAll(sedes);
    await sedesSincronizadas.compact();
    await sedesSincronizadas.close();
    update(['sedes']);
  }

  Future<void> getCultivos() async {
    cultivos = await _getCultivosUseCase.execute();
    var cultivosSincronizadas =
        await Hive.openBox<CultivoEntity>('cultivos_sincronizar');
    await cultivosSincronizadas.clear();
    await cultivosSincronizadas.addAll(cultivos);
    await cultivosSincronizadas.compact();
    await cultivosSincronizadas.close();
    update(['cultivos']);
  }

  Future<void> getLabores() async {
    labores = await _getLaborsUseCase.execute();
    var laboresSincronizadas =
        await Hive.openBox<LaborEntity>('labores_sincronizar');
    await laboresSincronizadas.clear();
    await laboresSincronizadas.addAll(labores);
    await laboresSincronizadas.compact();
    await laboresSincronizadas.close();
    update(['labores']);
  }

  Future<void> getEsparragoAgrupaPersonal() async {
    agrupaPersonals = await _getEsparragoAgrupaPersonalsUseCase.execute();
    var agrupaPersonalSincronizar =
        await Hive.openBox<EsparragoAgrupaPersonalEntity>(
            'esparrago_agrupa_sincronizar');
    await agrupaPersonalSincronizar.clear();
    await agrupaPersonalSincronizar.addAll(agrupaPersonals);
    await agrupaPersonalSincronizar.compact();
    await agrupaPersonalSincronizar.close();
    update(['esparrago_agrupa']);
  }

  Future<void> setLog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var logs = await Hive.openBox<LogEntity>('log_sincronizar');
    PreferenciasUsuario().lastVersion = version;
    PreferenciasUsuario().lastVersionDate = formatoFechaHora(
        (await _getCurrentTimeWorldUseCase.execute()).datetime);
    await logs.add(new LogEntity(
      id: DateTime.now().microsecond,
      fecha: DateTime.now(),
      version: version,
    ));
    await logs.close();
    update(['version']);
  }

  Future<void> getUsuarios() async {
    usuarios = await _getUsuariosUseCase.execute();
    var usuariosSincronizadas =
        await Hive.openBox<UsuarioEntity>('usuarios_sincronizar');
    await usuariosSincronizadas.clear();
    await usuariosSincronizadas.addAll(usuarios);
    await usuariosSincronizadas.compact();
    await usuariosSincronizadas.close();
    update(['usuarios']);
  }

  Future<void> getCentrosCosto() async {
    centrosCosto = await _getCentroCostosUseCase.execute();
    Box<CentroCostoEntity> centrosCostoSincronizados =
        await Hive.openBox<CentroCostoEntity>('centros_costo_sincronizar');
    await centrosCostoSincronizados.clear();
    await centrosCostoSincronizados.addAll(centrosCosto);
    await centrosCostoSincronizados.compact();
    await centrosCostoSincronizados.close();
    update(['centro_costo']);
  }
}
