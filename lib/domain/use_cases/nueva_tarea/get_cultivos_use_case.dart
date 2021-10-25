
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/repositories/cultivo_repository.dart';

class GetCultivosUseCase{
  final CultivoRepository _cultivoRepository;

  GetCultivosUseCase(this._cultivoRepository);

  Future<List<CultivoEntity>> execute() async{
    return await _cultivoRepository.getAll();
  }
  
}