
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';

abstract class CentroCostoRepository{

  Future<List<CentroCostoEntity>> getAll();
  Future<List<CentroCostoEntity>> getAllByValue(Map<String,dynamic> valores);
}