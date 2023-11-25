import 'package:flutter_tareo/domain/asignacion_personal/datastores/asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';

class AsignacionPersonalRepositoryImplementation
    implements AsignacionPersonalRepository {
  AsignacionPersonalDataStore _dataStore;

  AsignacionPersonalRepositoryImplementation(
    this._dataStore,
  );

  @override
  Future<List<EsparragoAgrupaPersonalEntity>> getLineaMesas(
      BuscarLineaMesaEntity query) async {
    return await _dataStore.getLineaMesas(query);
  }
}
