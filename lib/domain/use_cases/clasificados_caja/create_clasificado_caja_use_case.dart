
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';

class CreateClasificadoCajaUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  CreateClasificadoCajaUseCase(this._clasificadoCajasRepository);

  Future<int> execute(String box, PreTareaEsparragoFormatoEntity detalle) async{
    return await _clasificadoCajasRepository.create(box, detalle);
  }
}