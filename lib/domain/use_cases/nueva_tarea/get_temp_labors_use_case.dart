


import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';


class GetTempLaborsUseCase{
  final TempLaborRepository _tempLaborRepository;

  GetTempLaborsUseCase(this._tempLaborRepository);

  Future<List<TempLaborEntity>> execute() async{
    return await _tempLaborRepository.getAll();
  }
  
}