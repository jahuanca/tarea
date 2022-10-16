
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/repositories/calibre_repository.dart';

class GetCalibresUseCase{
  final CalibreRepository _repository;

  GetCalibresUseCase(this._repository);

  Future<List<CalibreEntity>> execute() async{
    return await _repository.getAll();
  }
  
}