import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarUsuariosUseCase {
  final SincronizarRepository _repository;

  SincronizarUsuariosUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getUsuarios();
  }
}
