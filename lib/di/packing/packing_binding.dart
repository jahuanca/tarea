import 'package:flutter_tareo/data/repositories/export_data_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_repository_implementation.dart';
import 'package:flutter_tareo/domain/packing/use_cases/create_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/delete_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/get_all_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/migrar_all_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/update_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/upload_file_of_packing_use_case.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_packing_to_excel_use_case.dart';
import 'package:get/get.dart';

class PackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackingRepository>(
        () => PreTareoProcesoUvaRepositoryImplementation());
    Get.lazyPut<ExportDataRepository>(
        () => ExportDataRepositoryImplementation());

    Get.lazyReplace<CreatePackingUseCase>(
        () => CreatePackingUseCase(Get.find()));
    Get.lazyReplace<GetAllPackingUseCase>(
        () => GetAllPackingUseCase(Get.find()));
    Get.lazyReplace<UpdatePackingUseCase>(
        () => UpdatePackingUseCase(Get.find()));
    Get.lazyReplace<DeletePackingUseCase>(
        () => DeletePackingUseCase(Get.find()));
    Get.lazyReplace<MigrarAllPackingUseCase>(
        () => MigrarAllPackingUseCase(Get.find()));
    Get.lazyReplace<UploadFileOfPackingUseCase>(
        () => UploadFileOfPackingUseCase(Get.find()));
    Get.lazyReplace<ExportPackingToExcelUseCase>(
        () => ExportPackingToExcelUseCase(Get.find()));
  }
}
