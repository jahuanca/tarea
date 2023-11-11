import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarActividadsUseCase {
  final SincronizarRepository _repository;

  SincronizarActividadsUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getActividads();
  }
}
