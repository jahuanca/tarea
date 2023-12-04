import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarClientesUseCase {
  final SincronizarRepository _repository;

  SincronizarClientesUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getClientes();
  }
}
