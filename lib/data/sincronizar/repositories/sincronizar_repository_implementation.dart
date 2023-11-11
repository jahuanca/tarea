import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
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

    return await setData(
        ACTIVIDAD_HIVE_STRING, asistenciaUbicacionEntityFromJson(res));
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
