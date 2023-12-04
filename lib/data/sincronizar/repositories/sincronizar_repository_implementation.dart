import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/sincronizar/repositories/sincronizar_repository.dart';
import 'package:hive/hive.dart';

class SincronizarRepositoryImplementation extends SincronizarRepository {
  AppHttpManager http;

  SincronizarRepositoryImplementation({
    this.http,
  }) {
    http = AppHttpManager();
  }

  @override
  Future<int> getTurnos() async {
    final res = await http.get(
      url: '/turno',
    );

    return await setData(TURNO_HIVE_STRING, turnoEntityFromJson(res));
  }

  @override
  Future<int> getUbicacions() async {
    final res = await http.get(
      url: '/asistencia_ubicacion',
    );
    return await setData(
        UBICACION_HIVE_STRING, asistenciaUbicacionEntityFromJson(res));
  }

  @override
  Future<int> getSedes() async {
    final res = await http.get(
      url: '/subdivision',
    );
    return await setData(SEDE_HIVE_STRING, subdivisionEntityFromJson(res));
  }

  @override
  Future<int> getLabors() async {
    final res = await http.get(
      url: '/labor',
    );
    return await setData(LABOR_HIVE_STRING, laborEntityFromJson(res));
  }

  @override
  Future<int> getUsuarios() async {
    final res = await http.get(
      url: '/usuario',
    );
    return await setData(USUARIO_HIVE_STRING, usuarioEntityFromJson(res));
  }

  @override
  Future<int> getCentroCostos() async {
    final res = await http.get(
      url: '/centro_costo',
    );
    return await setData(
        CENTRO_COSTOS_HIVE_STRING, centroCostoEntityFromJson(res));
  }

  @override
  Future<int> getPersonalEmpresas() async {
    String resCount = await http.get(
      url: '/personal_empresa/count',
    );
    int count = int.parse(resCount);
    int limit = 8000;
    int times = (count / limit).ceil();

    List<PersonalEmpresaEntity> personal = [];

    for (int i = 0; i < times; i++) {
      final res = await http.get(url: '/personal_empresa/range', query: {
        'limit': limit,
        'offset': (i * limit),
      });
      personal.addAll(personalEmpresaEntityFromJson(res));
    }
    return await setData(PERSONAL_HIVE_STRING, personal);
  }

  @override
  Future<int> getActividads() async {
    final res = await http.get(
      url: '/actividad',
    );

    return await setData(ACTIVIDAD_HIVE_STRING, actividadEntityFromJson(res));
  }

  @override
  Future<int> getCalibres() async {
    final res = await http.get(
      url: '/calibre',
    );
    return await setData(CALIBRES_HIVE_STRING, calibreEntityFromJson(res));
  }

  @override
  Future<int> getEstados() async {
    final res = await http.get(
      url: '/estado',
    );
    return await setData(ESTADOS_HIVE_STRING, estadoEntityFromJson(res));
  }

  @override
  Future<int> getClientes() async {
    final res = await http.get(
      url: '/cliente',
    );
    return await setData(CLIENTES_HIVE_STRING, clienteEntityFromJson(res));
  }

  @override
  Future<int> getCultivos() async {
    final res = await http.get(
      url: '/cultivo',
    );
    return await setData(CULTIVOS_HIVE_STRING, cultivoEntityFromJson(res));
  }

  Future<int> setData(String pathBox, List<dynamic> values) async {
    final box = await Hive.openBox(pathBox);
    await box?.clear();
    await box.addAll(values);
    await box.compact();
    await box.close();
    return values.length;
  }
}
