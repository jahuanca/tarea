import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarCentroCostosUseCase {
  final SincronizarRepository _repository;

  SincronizarCentroCostosUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getCentroCostos();
  }
}
