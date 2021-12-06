
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportSeleccionToExcelUseCase{
  final ExportDataRepository _exportDataRepository;

  ExportSeleccionToExcelUseCase(this._exportDataRepository);

  Future<void> execute(int key) async{
    return await _exportDataRepository.exportToExcelSeleccion(key);
  }
  
}