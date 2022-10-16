
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/repositories/labores_cultivo_packing_repository.dart';

class GetLaboresCultivoPackingUseCase{
  final LaboresCultivoPackingRepository _laboresCultivoPackingRepository;

  GetLaboresCultivoPackingUseCase(this._laboresCultivoPackingRepository);

  Future<List<LaboresCultivoPackingEntity>> execute() async{
    return await _laboresCultivoPackingRepository.getAll();
  }
  
}