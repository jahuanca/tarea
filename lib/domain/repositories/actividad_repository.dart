
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';

abstract class ActividadRepository{

  Future<List<ActividadEntity>> getAll();
  Future<List<ActividadEntity>> getAllByValue(String key, dynamic value);
}