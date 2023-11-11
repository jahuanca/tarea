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

    List<TurnoEntity> turnos = turnoEntityFromJson(res);
    await setData(TURNO_HIVE_STRING, turnos);
    return turnos.length;
  }

  @override
  Future<int> getUbicacions() async {
    final res = await http.get(
      url: '/asistencia_ubicacion',
    );

    List<AsistenciaUbicacionEntity> ubicacions =
        asistenciaUbicacionEntityFromJson(res);
    await setData(UBICACION_HIVE_STRING, ubicacions);
    return ubicacions.length;
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

    await setData(PERSONAL_HIVE_STRING, personal);
    return personal.length;
  }

  Future<void> setData(String pathBox, List<dynamic> values) async {
    final box = await Hive.openBox(pathBox);
    await box?.clear();
    await box.addAll(values);
    await box.compact();
    await box.close();
  }
}
