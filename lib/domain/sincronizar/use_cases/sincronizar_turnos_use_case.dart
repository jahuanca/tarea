import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarTurnosUseCase {
  final SincronizarRepository _repository;

  SincronizarTurnosUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getTurnos();
  }
}
