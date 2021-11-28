
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportPackingToExcelUseCase{
  final ExportDataRepository _exportDataRepository;

  ExportPackingToExcelUseCase(this._exportDataRepository);

  Future<void> execute(int key) async{
    return await _exportDataRepository.exportToExcelPacking(key);
  }
  
}