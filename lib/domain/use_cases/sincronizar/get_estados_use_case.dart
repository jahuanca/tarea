
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/repositories/estado_repository.dart';

class GetEstadosUseCase{
  final EstadoRepository _repository;

  GetEstadosUseCase(this._repository);

  Future<List<EstadoEntity>> execute() async{
    return await _repository.getAll();
  }
  
}