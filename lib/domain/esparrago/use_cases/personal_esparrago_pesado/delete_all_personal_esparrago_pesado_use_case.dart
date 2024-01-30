import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';

class DeleteAllPersonalEsparragoPesadoUseCase {
  final PersonalEsparragoPesadoRepository _repository;

  DeleteAllPersonalEsparragoPesadoUseCase(this._repository);

  Future<void> execute(String box) async {
    return await _repository.deleteAll(box);
  }
}
