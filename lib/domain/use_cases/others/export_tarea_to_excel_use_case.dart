
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportTareaToExcelUseCase{
  final ExportDataRepository _exportDataRepository;

  ExportTareaToExcelUseCase(this._exportDataRepository);

  Future<void> execute(int key) async{
    return await _exportDataRepository.exportToExcelTarea(key);
  }
  
}