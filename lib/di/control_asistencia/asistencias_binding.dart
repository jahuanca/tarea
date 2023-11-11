import 'package:flutter_tareo/data/control_asistencia/repositories/asistencia_repository_implementation.dart';
import 'package:flutter_tareo/data/control_asistencia/repositories/registro_asistencia_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/create_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/delete_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/export_asistencia_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/get_all_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/migrar_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/update_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/home_asistencia/upload_file_of_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/registro_asistencia/create_registro_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/registro_asistencia/get_all_registro_asistencia_use_case.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/ui/control_asistencia/controllers/home_asistencia_controller.dart';
import 'package:get/get.dart';

class AsistenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AsistenciaRepository>(
        () => AsistenciaRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(
        () => ExportDataRepositoryImplementation());
    Get.lazyPut<RegistroAsistenciaRepository>(
        () => RegistroAsistenciaRepositoryImplementation());

    Get.lazyPut<CreateAsistenciaUseCase>(
        () => CreateAsistenciaUseCase(Get.find()));
    Get.lazyPut<GetAllAsistenciaUseCase>(
        () => GetAllAsistenciaUseCase(Get.find()));
    Get.lazyPut<UpdateAsistenciaUseCase>(
        () => UpdateAsistenciaUseCase(Get.find()));
    Get.lazyPut<DeleteAsistenciaUseCase>(
        () => DeleteAsistenciaUseCase(Get.find()));
    Get.lazyPut<GetAllRegistroAsistenciaUseCase>(
        () => GetAllRegistroAsistenciaUseCase(Get.find()));

    Get.lazyPut<MigrarAsistenciaUseCase>(
        () => MigrarAsistenciaUseCase(Get.find()));
    Get.lazyPut<UploadFileOfAsistenciaUseCase>(
        () => UploadFileOfAsistenciaUseCase(Get.find()));
    Get.lazyPut<ExportAsistenciaToExcelUseCase>(
        () => ExportAsistenciaToExcelUseCase(Get.find()));
    Get.lazyPut<CreateRegistroAsistenciaUseCase>(
        () => CreateRegistroAsistenciaUseCase(Get.find()));

    Get.lazyPut<HomeAsistenciaController>(() => HomeAsistenciaController(
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
