import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class AsistenciaRegistroRepository {
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key);
  Future<AsistenciaRegistroPersonalEntity> create(
      int key, AsistenciaRegistroPersonalEntity detalle);
  Future<bool> update(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle);
  Future<void> delete(int keyBox, int key);
  Future<void> deleteAll(int key);
  Future<ResultType<AsistenciaRegistroPersonalEntity, Failure>> registrar(
      AsistenciaRegistroPersonalEntity data);
}
