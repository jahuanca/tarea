
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';

class ExportEsparragoToExcelUseCase{
  final ExportDataRepository _repository;

  ExportEsparragoToExcelUseCase(this._repository);

  Future<void> execute(int idDB) async{
    return await _repository.exportToExcelPersonalPreTareEsparrago(idDB);
  }
  
}