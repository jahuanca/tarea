
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportPesadoToExcelUseCase{
  final ExportDataRepository _exportDataRepository;

  ExportPesadoToExcelUseCase(this._exportDataRepository);

  Future<void> execute(int key) async{
    return await _exportDataRepository.exportToExcelPesado(key);
  }
  
}