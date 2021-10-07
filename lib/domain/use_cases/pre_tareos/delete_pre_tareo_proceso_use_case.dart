
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';

class DeletePreTareoProcesoUseCase{
  final PreTareoProcesoRepository _preTareoProcesoRepository;

  DeletePreTareoProcesoUseCase(this._preTareoProcesoRepository);

  Future<void> execute(int index) async{
    return await _preTareoProcesoRepository.delete(index);
  }

}