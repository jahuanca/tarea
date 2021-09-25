
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';

abstract class ActividadRepository{

  Future<List<ActividadEntity>> getAll();
}