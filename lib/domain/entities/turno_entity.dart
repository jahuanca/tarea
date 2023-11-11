// To parse this JSON data, do

import 'dart:convert';
import 'package:hive/hive.dart';

part 'turno_entity.g.dart';

@HiveType(typeId: 36)
class TurnoEntity {
  TurnoEntity({
    this.idturno,
    this.detalleturno,
    this.turno,
  });

  @HiveField(0)
  int idturno;
  @HiveField(1)
  String detalleturno;
  @HiveField(2)
  String turno;

  factory TurnoEntity.fromJson(Map<String, dynamic> json) => TurnoEntity(
        idturno: json["idturno"] == null ? null : json["idturno"],
        detalleturno:
            json["detalleturno"] == null ? null : json["detalleturno"],
        turno: json["turno"] == null ? null : json["turno"],
      );

  Map<String, dynamic> toJson() => {
        "idturno": idturno == null ? null : idturno,
        "detalleturno": detalleturno == null ? null : detalleturno,
        "turno": turno == null ? null : turno,
      };
}

List<TurnoEntity> turnoEntityFromJson(String str) => List<TurnoEntity>.from(
    json.decode(str).map((x) => TurnoEntity.fromJson(x)));

String turnoEntityToJson(List<TurnoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
