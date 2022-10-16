
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';

abstract class CalibreRepository{

  Future<List<CalibreEntity>> getAll();
  Future<List<CalibreEntity>> getAllByValue(Map<String,dynamic> valores);
}