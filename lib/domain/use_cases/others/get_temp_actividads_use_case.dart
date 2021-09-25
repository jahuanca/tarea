
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';

class GetTempActividadsUseCase{
  final TempActividadRepository _tempActividadRepository;

  GetTempActividadsUseCase(this._tempActividadRepository);

  Future<List<TempActividadEntity>> execute() async{
    return await _tempActividadRepository.getAll();
  }
  
}