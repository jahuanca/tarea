
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/calibre_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cliente_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_pre_tarea_esparrago_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pesado_detalles_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/via_envio_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/calibre_repository.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/delete_peersonal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/update_personal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_calibre_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/create_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_pre_tarea_esparrago/get_all_personal_pre_tarea_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_via_envio_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tarea_esparrago/listado_personas_pre_tarea_esparrago_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasPreTareaEsparragoBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<ClienteRepository>(() => ClienteRepositoryImplementation());
    Get.lazyPut<ViaEnvioRepository>(() => ViaEnvioRepositoryImplementation());
    Get.lazyPut<CalibreRepository>(() => CalibreRepositoryImplementation());
    Get.lazyPut<PesadoDetallesRepository>(() => PesadoDetallesRepositoryImplementation());
    Get.lazyPut<PersonalPreTareaEsparragoRepository>(() => PersonalPreTareaEsparragoRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdatePesadoUseCase>(() => UpdatePesadoUseCase(Get.find()));
    
    Get.lazyPut<GetCalibresUseCase>(() => GetCalibresUseCase(Get.find()));
    Get.lazyPut<GetViaEnviosUseCase>(() => GetViaEnviosUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<GetClientesUseCase>(() => GetClientesUseCase(Get.find()));
    
    Get.lazyPut<GetAllPersonalPreTareaEsparragoUseCase>(() => GetAllPersonalPreTareaEsparragoUseCase(Get.find()));
    Get.lazyPut<CreatePersonalPreTareaEsparragoUseCase>(() => CreatePersonalPreTareaEsparragoUseCase(Get.find()));
    Get.lazyPut<DeletePersonalPreTareaEsparragoUseCase>(() => DeletePersonalPreTareaEsparragoUseCase(Get.find()));
    Get.lazyPut<UpdatePersonalPreTareaEsparragoUseCase>(() => UpdatePersonalPreTareaEsparragoUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasPreTareaEsparragoController>(() => ListadoPersonasPreTareaEsparragoController(
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