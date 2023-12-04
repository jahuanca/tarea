import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarCultivosUseCase {
  final SincronizarRepository _repository;

  SincronizarCultivosUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getCultivos();
  }
}
