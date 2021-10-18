
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';

class DeletePreTareoProcesoUvaUseCase{
  final PreTareoProcesoUvaRepository _preTareoProcesoUvaRepository;

  DeletePreTareoProcesoUvaUseCase(this._preTareoProcesoUvaRepository);

  Future<void> execute(int index) async{
    return await _preTareoProcesoUvaRepository.delete(index);
  }

}