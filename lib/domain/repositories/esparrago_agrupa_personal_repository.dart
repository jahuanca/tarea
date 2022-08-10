import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';

abstract class EsparragoAgrupaPersonalRepository{

  Future<List<EsparragoAgrupaPersonalEntity>> getAll();
  Future<List<EsparragoAgrupaPersonalEntity>> getAllByValue(Map<String,dynamic> valores);
}