
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';

abstract class TempActividadRepository{

  Future<List<TempActividadEntity>> getTempActividads();
}