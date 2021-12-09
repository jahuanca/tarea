
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';

class GetAllPesadoDetallesUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  GetAllPesadoDetallesUseCase(this._pesadoDetallesRepository);

  Future<List<PreTareaEsparragoDetalleVariosEntity>> execute(String box) async{
    return await _pesadoDetallesRepository.getAll(box);
  }

}