
import 'package:flutter_tareo/domain/entities/estado_entity.dart';

abstract class EstadoRepository{

  Future<List<EstadoEntity>> getAll();
  Future<List<EstadoEntity>> getAllByValue(Map<String,dynamic> valores);
}