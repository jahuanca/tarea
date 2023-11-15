import 'package:flutter_tareo/data/control_asistencia/datastores/api_rest/asistencia_datastore_implementation.dart';
import 'package:flutter_tareo/data/control_asistencia/datastores/api_rest/asistencia_registro_datastore_implementation.dart';
import 'package:flutter_tareo/data/control_asistencia/repositories/asistencia_repository_implementation.dart';
import 'package:flutter_tareo/data/control_asistencia/repositories/asistencia_registro_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_data_store.dart';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_registro_data_store.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/create_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/delete_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/export_asistencia_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/get_all_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/migrar_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/update_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/upload_file_of_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/get_all_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/ui/control_asistencia/home_asistencia/home_asistencia_controller.dart';
import 'package:get/get.dart';

class AsistenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AsistenciaDataStore>(() => AsistenciaDataStoreImplementation());
    Get.lazyPut<AsistenciaRegistroDataStore>(
        () => AsistenciaRegistroDataStoreImplementation());

    Get.lazyPut<AsistenciaRepository>(
        () => AsistenciaRepositoryImplementation(Get.find()));
    Get.lazyPut<ExportDataRepository>(
        () => ExportDataRepositoryImplementation());
    Get.lazyPut<AsistenciaRegistroRepository>(
        () => AsistenciaRegistroRepositoryImplementation(Get.find()));

    Get.lazyPut<CreateAsistenciaUseCase>(
        () => CreateAsistenciaUseCase(Get.find()));
    Get.lazyPut<GetAllAsistenciaUseCase>(
        () => GetAllAsistenciaUseCase(Get.find()));
    Get.lazyPut<UpdateAsistenciaUseCase>(
        () => UpdateAsistenciaUseCase(Get.find()));
    Get.lazyPut<DeleteAsistenciaUseCase>(
        () => DeleteAsistenciaUseCase(Get.find()));
    Get.lazyPut<GetAllAsistenciaRegistroUseCase>(
        () => GetAllAsistenciaRegistroUseCase(Get.find()));
    Get.lazyPut<MigrarAsistenciaUseCase>(
        () => MigrarAsistenciaUseCase(Get.find()));
    Get.lazyPut<UploadFileOfAsistenciaUseCase>(
        () => UploadFileOfAsistenciaUseCase(Get.find()));
    Get.lazyPut<ExportAsistenciaToExcelUseCase>(
        () => ExportAsistenciaToExcelUseCase(Get.find()));

    Get.lazyPut<HomeAsistenciaController>(() => HomeAsistenciaController(
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
