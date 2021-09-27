// To parse this JSON data, do
//
//     final actividadEntity = actividadEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'actividad_entity.g.dart';

@HiveType(typeId: 9)
class ActividadEntity {
  ActividadEntity({
    this.idactividad,
    this.actividad,
    this.descripcion,
    this.activo,
    this.esrendimiento,
    this.esjornal,
    this.idsociedad,
    this.idusuario,
    this.fechamod,
  });

  @HiveField(0)
  int idactividad;
  @HiveField(1)
  String actividad;
  @HiveField(2)
  String descripcion;
  @HiveField(3)
  bool activo;
  @HiveField(4)
  bool esrendimiento;
  @HiveField(5)
  bool esjornal;
  @HiveField(6)
  int idsociedad;
  @HiveField(7)
  int idusuario;
  @HiveField(8)
  DateTime fechamod;

  factory ActividadEntity.fromJson(Map<String, dynamic> json) =>
      ActividadEntity(
        idactividad: json["idactividad"],
        actividad: json["actividad"],
        descripcion: json["descripcion"],
        activo: json["activo"],
        esrendimiento: json["esrendimiento"],
        esjornal: json["esjornal"],
        idsociedad: json["idsociedad"],
        idusuario: json["idusuario"],
        fechamod: DateTime.parse(json["fechamod"]),
      );

  Map<String, dynamic> toJson() => {
        "idactividad": idactividad,
        "actividad": actividad,
        "descripcion": descripcion,
        "activo": activo,
        "esrendimiento": esrendimiento,
        "esjornal": esjornal,
        "idsociedad": idsociedad,
        "idusuario": idusuario,
        "fechamod": fechamod.toIso8601String(),
      };
}

List<ActividadEntity> actividadEntityFromJson(String str) =>
    List<ActividadEntity>.from(
        json.decode(str).map((x) => ActividadEntity.fromJson(x)));

String actividadEntityToJson(List<ActividadEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
