import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarCalibresUseCase {
  final SincronizarRepository _repository;

  SincronizarCalibresUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getCalibres();
  }
}
