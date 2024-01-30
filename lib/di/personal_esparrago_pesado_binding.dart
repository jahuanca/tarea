import 'package:flutter_tareo/data/esparrago/datastores/personal_esparrago_pesado_datastore_implementation.dart';
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/calibre_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cliente_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/esparrago/repositories/personal_esparrago_pesado_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pesado_detalles_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/via_envio_repository_implementation.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/personal_esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/create_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/delete_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/get_all_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/esparrago/use_cases/personal_esparrago_pesado/update_personal_esparrago_pesado_use_case.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/calibre_repository.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/ui/pages/personal_esparrago_pesado/personal_esparrago_pesado_controller.dart';
import 'package:get/get.dart';

class PersonalEsparragoPesadoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<ClienteRepository>(() => ClienteRepositoryImplementation());
    Get.lazyPut<ViaEnvioRepository>(() => ViaEnvioRepositoryImplementation());
    Get.lazyPut<CalibreRepository>(() => CalibreRepositoryImplementation());
    Get.lazyPut<PesadoDetallesRepository>(
        () => PesadoDetallesRepositoryImplementation());

    Get.lazyPut<PersonalEsparragoPesadoDatastore>(
        () => PersonalEsparragoPesadoDatastoreImplementation());

    Get.lazyPut<PersonalEsparragoPesadoRepository>(
        () => PersonalEsparragoPesadoRepositoryImplementation(Get.find()));

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdatePesadoUseCase>(() => UpdatePesadoUseCase(Get.find()));

    Get.lazyPut<GetCalibresUseCase>(() => GetCalibresUseCase(Get.find()));
    Get.lazyPut<GetViaEnviosUseCase>(() => GetViaEnviosUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<GetClientesUseCase>(() => GetClientesUseCase(Get.find()));

    Get.lazyPut<GetAllPersonalEsparragoPesadoUseCase>(
        () => GetAllPersonalEsparragoPesadoUseCase(Get.find()));
    Get.lazyPut<CreatePersonalEsparragoPesadoUseCase>(
        () => CreatePersonalEsparragoPesadoUseCase(Get.find()));
    Get.lazyPut<DeletePersonalEsparragoPesadoUseCase>(
        () => DeletePersonalEsparragoPesadoUseCase(Get.find()));
    Get.lazyPut<UpdatePersonalEsparragoPesadoUseCase>(
        () => UpdatePersonalEsparragoPesadoUseCase(Get.find()));

    Get.lazyPut<PersonalEsparragoPesadoController>(
        () => PersonalEsparragoPesadoController(
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
              Get.find(),
            ));
  }
}
