
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';

class GetAllClasificadoCajasUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  GetAllClasificadoCajasUseCase(this._clasificadoCajasRepository);

  Future<List<PreTareaEsparragoFormatoEntity>> execute(String box) async{
    return await _clasificadoCajasRepository.getAll(box);
  }

}