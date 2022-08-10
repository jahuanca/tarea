
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';

class UpdateClasificadoCajaUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  UpdateClasificadoCajaUseCase(this._clasificadoCajasRepository);

  Future<void> execute(String box, int key, PreTareaEsparragoFormatoEntity detalle) async{
    return await _clasificadoCajasRepository.update(box, key, detalle);
  }

}