import 'package:flutter_tareo/domain/entities/turno_entity.dart';

abstract class TurnoRepository {
  Future<List<TurnoEntity>> getAll();
  Future<List<TurnoEntity>> getAllByValue(Map<String, dynamic> valores);
}
