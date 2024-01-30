import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetAllPersonalEsparragoPesadoUseCase {
  final PersonalEsparragoPesadoRepository _repository;

  GetAllPersonalEsparragoPesadoUseCase(this._repository);

  Future<ResultType<List<PersonalPreTareaEsparragoEntity>, Failure>> execute(
      Map<String, dynamic> query) async {
    return await _repository.getAll(query);
  }
}
