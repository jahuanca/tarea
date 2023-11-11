import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/calibre_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cliente_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cultivo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/current_time_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/esparrago_agrupa_personal_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/estado_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labores_cultivo_packing_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/tipo_tarea_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/usuario_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/via_envio_repository_implementation.dart';
import 'package:flutter_tareo/data/sincronizar/repositories/sincronizar_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/calibre_repository.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/domain/repositories/cultivo_repository.dart';
import 'package:flutter_tareo/domain/repositories/current_time_repository.dart';
import 'package:flutter_tareo/domain/repositories/esparrago_agrupa_personal_repository.dart';
import 'package:flutter_tareo/domain/repositories/estado_repository.dart';
import 'package:flutter_tareo/domain/repositories/labores_cultivo_packing_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/tipo_tarea_repository.dart';
import 'package:flutter_tareo/domain/repositories/usuario_repository.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_turnos_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/use_cases/sincronizar_ubicacions_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_current_time_world_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_esparrago_agrupa_personal_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_estados_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_pre_tareo_procesos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_tipo_tareas_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_controller.dart';
import 'package:get/get.dart';

class SincronizarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(
        () => SubdivisionRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<UsuarioRepository>(() => UsuarioRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(
        () => CentroCostoRepositoryImplementation());
    Get.lazyPut<CurrentTimeRepository>(
        () => CurrentTimeRepositoryImplementation());
    Get.lazyPut<PreTareoProcesoRepository>(
        () => PreTareoProcesoRepositoryImplementation());
    Get.lazyPut<LaboresCultivoPackingRepository>(
        () => LaboresCultivoPackingRepositoryImplementation());
    Get.lazyPut<CultivoRepository>(() => CultivoRepositoryImplementation());
    Get.lazyPut<ClienteRepository>(() => ClienteRepositoryImplementation());
    Get.lazyPut<TipoTareaRepository>(() => TipoTareaRepositoryImplementation());
    Get.lazyPut<EstadoRepository>(() => EstadoRepositoryImplementation());
    Get.lazyPut<CalibreRepository>(() => CalibreRepositoryImplementation());
    Get.lazyPut<ViaEnvioRepository>(() => ViaEnvioRepositoryImplementation());
    Get.lazyPut<EsparragoAgrupaPersonalRepository>(
        () => EsparragoAgrupaPersonalRepositoryImplementation());
    Get.lazyPut<SincronizarRepository>(
        () => SincronizarRepositoryImplementation());

    Get.lazyPut<GetActividadsUseCase>(() => GetActividadsUseCase(Get.find()));
    Get.lazyPut<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<GetUsuariosUseCase>(() => GetUsuariosUseCase(Get.find()));
    Get.lazyPut<GetCentroCostosUseCase>(
        () => GetCentroCostosUseCase(Get.find()));
    Get.lazyReplace<GetCurrentTimeWorldUseCase>(
        () => GetCurrentTimeWorldUseCase(Get.find()));
    Get.lazyReplace<GetPreTareoProcesosUseCase>(
        () => GetPreTareoProcesosUseCase(Get.find()));
    Get.lazyReplace<GetLaboresCultivoPackingUseCase>(
        () => GetLaboresCultivoPackingUseCase(Get.find()));
    Get.lazyReplace<GetCultivosUseCase>(() => GetCultivosUseCase(Get.find()));
    Get.lazyReplace<GetClientesUseCase>(() => GetClientesUseCase(Get.find()));
    Get.lazyReplace<GetEstadosUseCase>(() => GetEstadosUseCase(Get.find()));
    Get.lazyReplace<GetCalibresUseCase>(() => GetCalibresUseCase(Get.find()));
    Get.lazyReplace<GetViaEnviosUseCase>(() => GetViaEnviosUseCase(Get.find()));
    Get.lazyReplace<GetTipoTareasUseCase>(
        () => GetTipoTareasUseCase(Get.find()));
    Get.lazyReplace<GetEsparragoAgrupaPersonalsUseCase>(
        () => GetEsparragoAgrupaPersonalsUseCase(Get.find()));
    Get.lazyReplace<SincronizarTurnosUseCase>(
        () => SincronizarTurnosUseCase(Get.find()));
    Get.lazyReplace<SincronizarUbicacionsUseCase>(
        () => SincronizarUbicacionsUseCase(Get.find()));
    Get.lazyReplace<SincronizarPersonalEmpresasUseCase>(
        () => SincronizarPersonalEmpresasUseCase(Get.find()));

    Get.lazyPut<SincronizarController>(() => SincronizarController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find()));
  }
}
