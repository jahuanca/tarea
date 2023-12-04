import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarSedesUseCase {
  final SincronizarRepository _repository;

  SincronizarSedesUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getSedes();
  }
}
