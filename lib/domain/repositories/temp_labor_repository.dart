
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';

abstract class TempLaborRepository{

  Future<List<TempLaborEntity>> getAll();
}