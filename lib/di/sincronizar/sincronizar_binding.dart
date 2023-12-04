import 'package:flutter_tareo/data/repositories/current_time_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/esparrago_agrupa_personal_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/estado_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labores_cultivo_packing_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/tipo_tarea_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/via_envio_repository_implementation.dart';
import 'package:flutter_tareo/data/sincronizar/repositories/sincronizar_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/current_time_repository.dart';
import 'package:flutter_tareo/domain/repositories/esparrago_agrupa_personal_repository.dart';
import 'package:flutter_tareo/domain/repositories/estado_repository.dart';
import 'package:flutter_tareo/domain/repositories/labores_cultivo_packing_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';
import 'package:flutter_tareo/domain/repositories/tipo_tarea_repository.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';
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
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_controller.dart';
import 'package:get/get.dart';

class SincronizarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentTimeRepository>(
        () => CurrentTimeRepositoryImplementation());
    Get.lazyPut<PreTareoProcesoRepository>(
        () => PreTareoProcesoRepositoryImplementation());
    Get.lazyPut<LaboresCultivoPackingRepository>(
        () => LaboresCultivoPackingRepositoryImplementation());
    Get.lazyPut<TipoTareaRepository>(() => TipoTareaRepositoryImplementation());
    Get.lazyPut<ViaEnvioRepository>(() => ViaEnvioRepositoryImplementation());
    Get.lazyPut<EsparragoAgrupaPersonalRepository>(
        () => EsparragoAgrupaPersonalRepositoryImplementation());
    Get.lazyPut<SincronizarRepository>(
        () => SincronizarRepositoryImplementation());

    Get.lazyReplace<GetCurrentTimeWorldUseCase>(
        () => GetCurrentTimeWorldUseCase(Get.find()));
    Get.lazyReplace<GetPreTareoProcesosUseCase>(
        () => GetPreTareoProcesosUseCase(Get.find()));
    Get.lazyReplace<GetLaboresCultivoPackingUseCase>(
        () => GetLaboresCultivoPackingUseCase(Get.find()));
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
    Get.lazyReplace<SincronizarActividadsUseCase>(
        () => SincronizarActividadsUseCase(Get.find()));
    Get.lazyReplace<SincronizarSedesUseCase>(
        () => SincronizarSedesUseCase(Get.find()));
    Get.lazyReplace<SincronizarLaborsUseCase>(
        () => SincronizarLaborsUseCase(Get.find()));
    Get.lazyReplace<SincronizarUsuariosUseCase>(
        () => SincronizarUsuariosUseCase(Get.find()));
    Get.lazyReplace<SincronizarCentroCostosUseCase>(
        () => SincronizarCentroCostosUseCase(Get.find()));
    Get.lazyReplace<SincronizarCalibresUseCase>(
        () => SincronizarCalibresUseCase(Get.find()));
    Get.lazyReplace<SincronizarClientesUseCase>(
        () => SincronizarClientesUseCase(Get.find()));
    Get.lazyReplace<SincronizarCultivosUseCase>(
        () => SincronizarCultivosUseCase(Get.find()));
    Get.lazyReplace<SincronizarEstadosUseCase>(
        () => SincronizarEstadosUseCase(Get.find()));

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
