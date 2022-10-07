
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';

class GetCentroCostosByKeyUseCase{
  final CentroCostoRepository _repository;

  GetCentroCostosByKeyUseCase(this._repository);

  Future<List<CentroCostoEntity>> execute(Map<String,dynamic> valores) async{
    return await _repository.getAllByValue(valores);
  }
  
}