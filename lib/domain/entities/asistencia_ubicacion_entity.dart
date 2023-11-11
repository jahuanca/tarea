import 'dart:convert';
import 'package:hive/hive.dart';

part 'asistencia_ubicacion_entity.g.dart';

@HiveType(typeId: 37)
class AsistenciaUbicacionEntity {
  AsistenciaUbicacionEntity({
    this.idubicacion,
    this.ubicacion,
    this.detallebreve,
  });

  @HiveField(0)
  int idubicacion;
  @HiveField(1)
  String ubicacion;
  @HiveField(2)
  String detallebreve;

  factory AsistenciaUbicacionEntity.fromJson(Map<String, dynamic> json) =>
      AsistenciaUbicacionEntity(
        idubicacion: json["idubicacion"] == null ? null : json["idubicacion"],
        ubicacion: json["ubicacion"] == null ? null : json["ubicacion"],
        detallebreve:
            json["detallebreve"] == null ? null : json["detallebreve"],
      );

  Map<String, dynamic> toJson() => {
        "idubicacion": idubicacion == null ? null : idubicacion,
        "ubicacion": ubicacion == null ? null : ubicacion,
        "detallebreve": detallebreve == null ? null : detallebreve,
      };
}

List<AsistenciaUbicacionEntity> asistenciaUbicacionEntityFromJson(String str) =>
    List<AsistenciaUbicacionEntity>.from(
        json.decode(str).map((x) => AsistenciaUbicacionEntity.fromJson(x)));

String asistenciaUbicacionEntityToJson(List<AsistenciaUbicacionEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
