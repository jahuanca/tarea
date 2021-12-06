
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tarea_esparrago_grupo_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_data_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_seleccion_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/create_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/delete_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/get_all_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/migrar_all_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/update_seleccion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/upload_file_of_seleccion_use_case.dart';
import 'package:flutter_tareo/ui/pages/seleccion/seleccion_controller.dart';
import 'package:get/get.dart';

class SeleccionBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PreTareaEsparragoGrupoRepository>(() => PreTareaEsparragoGrupoRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(() => ExportDataRepositoryImplementation());

    Get.lazyReplace<CreateSeleccionUseCase>(() => CreateSeleccionUseCase(Get.find()));
    Get.lazyReplace<GetAllSeleccionUseCase>(() => GetAllSeleccionUseCase(Get.find()));
    Get.lazyReplace<UpdateSeleccionUseCase>(() => UpdateSeleccionUseCase(Get.find()));
    Get.lazyReplace<DeleteSeleccionUseCase>(() => DeleteSeleccionUseCase(Get.find()));
    Get.lazyReplace<MigrarAllSeleccionUseCase>(() => MigrarAllSeleccionUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfSeleccionUseCase>(() => UploadFileOfSeleccionUseCase(Get.find()));
    Get.lazyReplace<ExportSeleccionToExcelUseCase>(() => ExportSeleccionToExcelUseCase(Get.find()));

    Get.lazyPut<SeleccionController>(() => SeleccionController(Get.find(), Get.find() , Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}