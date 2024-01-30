import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class DeletePackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  DeletePackingUseCase(this._preTareoProcesoUvaRepository);

  Future<void> execute(int index) async {
    return await _preTareoProcesoUvaRepository.delete(index);
  }
}
