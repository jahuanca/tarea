import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarUbicacionsUseCase {
  final SincronizarRepository _repository;

  SincronizarUbicacionsUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getUbicacions();
  }
}
