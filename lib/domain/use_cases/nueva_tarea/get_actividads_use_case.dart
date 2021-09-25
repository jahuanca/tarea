
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';

class GetActividadsUseCase{
  final ActividadRepository _actividadRepository;

  GetActividadsUseCase(this._actividadRepository);

  Future<List<ActividadEntity>> execute() async{
    return await _actividadRepository.getAll();
  }
  
}