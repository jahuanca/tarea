import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';

class SincronizarPersonalEmpresasUseCase {
  final SincronizarRepository _repository;

  SincronizarPersonalEmpresasUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getPersonalEmpresas();
  }
}
