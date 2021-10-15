
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';

abstract class LaboresCultivoPackingRepository{

  Future<List<LaboresCultivoPackingEntity>> getAll();
  Future<List<LaboresCultivoPackingEntity>> getAllByValue(Map<String,dynamic> valores);
}