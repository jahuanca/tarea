

import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/repositories/esparrago_agrupa_personal_repository.dart';

class GetEsparragoAgrupaPersonalsUseCase{
  final EsparragoAgrupaPersonalRepository _esparragoAgrupaPersonalRepository;

  GetEsparragoAgrupaPersonalsUseCase(this._esparragoAgrupaPersonalRepository);

  Future<List<EsparragoAgrupaPersonalEntity>> execute() async{
    return await _esparragoAgrupaPersonalRepository.getAll();
  }
  
}