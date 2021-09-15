
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';

abstract class TempActividadRepository{

  Future<List<TempActividadEntity>> getAll();
}