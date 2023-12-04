import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/log_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_calibres_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_clientes_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_estados_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_labors_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_sedes_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_turnos_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_ubicacions_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_current_time_world_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_esparrago_agrupa_personal_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_estados_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_pre_tareo_procesos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_tipo_tareas_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';

class SincronizarController extends GetxController {
  List<EsparragoAgrupaPersonalEntity> agrupaPersonals = [];
  List<PreTareoProcesoEntity> preTareos = [];
  List<TipoTareaEntity> tipoTareas = [];
  List<LaboresCultivoPackingEntity> laboresCultivoPacking = [];
  List<ViaEnvioEntity> viaEnvios = [];
  int sizeTurnos = ZERO_INT_VALUE;
  int sizeUbicacions = ZERO_INT_VALUE;
  int sizePersonal = ZERO_INT_VALUE;
  int sizeActividads = ZERO_INT_VALUE;
  int sizeSedes = ZERO_INT_VALUE;
  int sizeLabores = ZERO_INT_VALUE;
  int sizeUsuarios = ZERO_INT_VALUE;
  int sizeCentroCostos = ZERO_INT_VALUE;
  int sizeCalibres = ZERO_INT_VALUE;
  int sizeClientes = ZERO_INT_VALUE;
  int sizeCultivos = ZERO_INT_VALUE;
  int sizeEstados = ZERO_INT_VALUE;

  int sizePreTareoProcesos = ZERO_INT_VALUE;
  int sizeLaboresCultivoPackings = ZERO_INT_VALUE;
  int sizeTipoTareas = ZERO_INT_VALUE;
  int sizeViaEnvios = ZERO_INT_VALUE;
  int sizeEsparragoAgrupaPersonals = ZERO_INT_VALUE;

  final GetCurrentTimeWorldUseCase _getCurrentTimeWorldUseCase;
  final GetPreTareoProcesosUseCase _getPreTareoProcesosUseCase;
  final GetLaboresCultivoPackingUseCase _getLaboresCultivoPackingUseCase;
  final GetTipoTareasUseCase _getTipoTareasUseCase;
  final GetViaEnviosUseCase _getViaEnviosUseCase;
  final GetEsparragoAgrupaPersonalsUseCase _getEsparragoAgrupaPersonalsUseCase;

  final SincronizarTurnosUseCase _sincronizarTurnosUseCase;
  final SincronizarUbicacionsUseCase _sincronizarUbicacionsUseCase;
  final SincronizarPersonalEmpresasUseCase _sincronizarPersonalEmpresasUseCase;
  final SincronizarActividadsUseCase _sincronizarActividadsUseCase;
  final SincronizarSedesUseCase _sincronizarSedesUseCase;
  final SincronizarLaborsUseCase _sincronizarLaborsUseCase;
  final SincronizarUsuariosUseCase _sincronizarUsuariosUseCase;
  final SincronizarCentroCostosUseCase _sincronizarCentroCostosUseCase;
  final SincronizarCalibresUseCase _sincronizarCalibresUseCase;
  final SincronizarClientesUseCase _sincronizarClientesUseCase;
  final SincronizarCultivosUseCase _sincronizarCultivosUseCase;
  final SincronizarEstadosUseCase _sincronizarEstadosUseCase;

  SincronizarController(
    this._sincronizarSedesUseCase,
    this._sincronizarActividadsUseCase,
    this._sincronizarEstadosUseCase,
    this._getViaEnviosUseCase,
    this._sincronizarCalibresUseCase,
    this._sincronizarLaborsUseCase,
    this._sincronizarUsuariosUseCase,
    this._sincronizarCentroCostosUseCase,
    this._getCurrentTimeWorldUseCase,
    this._getPreTareoProcesosUseCase,
    this._getLaboresCultivoPackingUseCase,
    this._sincronizarCultivosUseCase,
    this._sincronizarClientesUseCase,
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

    await getViaEnvios();
    await getTipoTareas();
    await getEsparragoAgrupaPersonal();

    sizeActividads = await _sincronizarActividadsUseCase.execute();
    update([ACTIVIDADS_ID]);
    sizeSedes = await _sincronizarSedesUseCase.execute();
    update([SEDES_ID]);
    sizeLabores = await _sincronizarLaborsUseCase.execute();
    update([LABORS_ID]);
    sizeCentroCostos = await _sincronizarCentroCostosUseCase.execute();
    update([CENTRO_COSTOS_ID]);
    sizeUsuarios = await _sincronizarUsuariosUseCase.execute();
    update([USUARIOS_ID]);
    sizeTurnos = await _sincronizarTurnosUseCase.execute();
    update([TURNOS_ID]);
    sizeUbicacions = await _sincronizarUbicacionsUseCase.execute();
    update([UBICACIONS_ID]);
    sizePersonal = await _sincronizarPersonalEmpresasUseCase.execute();
    update([PERSONAL_EMPRESAS_ID]);
    sizeCultivos = await _sincronizarCultivosUseCase.execute();
    update([CULTIVOS_ID]);
    sizeClientes = await _sincronizarClientesUseCase.execute();
    update([CLIENTES_ID]);
    sizeEstados = await _sincronizarEstadosUseCase.execute();
    update([ESTADOS_ID]);
    sizeCalibres = await _sincronizarCalibresUseCase.execute();
    update([CALIBRES_ID]);

    validando = BOOLEAN_FALSE_VALUE;
    await setLog();
    update([VALIDANDO_ID]);
    PreferenciasUsuario().offLine = BOOLEAN_TRUE_VALUE;
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
}
