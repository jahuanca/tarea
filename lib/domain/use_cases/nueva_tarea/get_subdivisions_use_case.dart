
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';

class GetSubdivisonsUseCase{
  final SubdivisionRepository _subdivisionRepository;

  GetSubdivisonsUseCase(this._subdivisionRepository);

  Future<List<SubdivisionEntity>> execute() async{
    return await _subdivisionRepository.getSubdivisions();
  }
  
}