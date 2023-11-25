import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';

abstract class AsignacionPersonalRepository {
  Future<List<EsparragoAgrupaPersonalEntity>> getLineaMesas(
      BuscarLineaMesaEntity query);
}
