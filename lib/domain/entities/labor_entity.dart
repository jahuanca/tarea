// To parse this JSON data, do
//
//     final laborEntity = laborEntityFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'labor_entity.g.dart';

@HiveType(typeId: 12)
class LaborEntity {
  LaborEntity({
    this.idlabor,
    this.idactividad,
    this.labor,
    this.descripcion,
    this.activo,
    this.idusuario,
    this.fechamod,
  });

  @HiveField(0)
  int idlabor;
  @HiveField(1)
  int idactividad;
  @HiveField(2)
  String labor;
  @HiveField(3)
  String descripcion;
  @HiveField(4)
  bool activo;
  @HiveField(5)
  int idusuario;
  @HiveField(6)
  DateTime fechamod;

  factory LaborEntity.fromJson(Map<String, dynamic> json) => LaborEntity(
        idlabor: json["idlabor"],
        idactividad: json["idactividad"],
        labor: json["labor"],
        descripcion: json["descripcion"],
        activo: json["activo"],
        idusuario: json["idusuario"],
        fechamod: DateTime?.parse(json["fechamod"]),
      );

  Map<String, dynamic> toJson() => {
        "idlabor": idlabor,
        "idactividad": idactividad,
        "labor": labor,
        "descripcion": descripcion,
        "activo": activo,
        "idusuario": idusuario,
        "fechamod": fechamod?.toIso8601String(),
      };
}

List<LaborEntity> laborEntityFromJson(String str) => List<LaborEntity>.from(
    json.decode(str).map((x) => LaborEntity.fromJson(x)));

String laborEntityToJson(List<LaborEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
