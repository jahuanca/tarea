import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportAsistenciaToExcelUseCase {
  final ExportDataRepository _exportDataRepository;

  ExportAsistenciaToExcelUseCase(this._exportDataRepository);

  Future<void> execute(int key) async {
    return await _exportDataRepository.exportToExcel(key);
  }
}
