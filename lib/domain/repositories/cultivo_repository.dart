
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';

abstract class CultivoRepository{

  Future<List<CultivoEntity>> getAll();
  Future<List<CultivoEntity>> getAllByValue(Map<String,dynamic> valores);
}