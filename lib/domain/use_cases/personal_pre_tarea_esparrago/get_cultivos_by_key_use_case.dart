
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/repositories/cultivo_repository.dart';

class GetCultivoByKeyUseCase{
  final CultivoRepository _repository;

  GetCultivoByKeyUseCase(this._repository);

  Future<List<CultivoEntity>> execute(Map<String,dynamic> valores) async{
    return await _repository.getAllByValue(valores);
  }
  
}