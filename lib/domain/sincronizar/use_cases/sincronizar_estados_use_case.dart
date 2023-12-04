import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarEstadosUseCase {
  final SincronizarRepository _repository;

  SincronizarEstadosUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getEstados();
  }
}
