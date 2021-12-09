
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cliente_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pesado_detalles_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/create_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/delete_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/get_all_pesado_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados_seleccion/update_pesado_detalle_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pesado/listado_personas_pesado_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasPesadoBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<ClienteRepository>(() => ClienteRepositoryImplementation());
    Get.lazyPut<PesadoDetallesRepository>(() => PesadoDetallesRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdatePesadoUseCase>(() => UpdatePesadoUseCase(Get.find()));
    Get.lazyPut<GetActividadsUseCase>(() => GetActividadsUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<GetClientesUseCase>(() => GetClientesUseCase(Get.find()));
    
    Get.lazyPut<GetAllPesadoDetallesUseCase>(() => GetAllPesadoDetallesUseCase(Get.find()));
    Get.lazyPut<CreatePesadoDetalleUseCase>(() => CreatePesadoDetalleUseCase(Get.find()));
    Get.lazyPut<UpdatePesadoDetalleUseCase>(() => UpdatePesadoDetalleUseCase(Get.find()));
    Get.lazyPut<DeletePesadoDetalleUseCase>(() => DeletePesadoDetalleUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasPesadoController>(() => ListadoPersonasPesadoController(Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}