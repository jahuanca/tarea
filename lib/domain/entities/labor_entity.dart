// To parse this JSON data, do
//
//     final laborEntity = laborEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:hive/hive.dart';

part 'labor_entity.g.dart';

@HiveType(typeId: 12)
class LaborEntity {
  LaborEntity(
      {this.idlabor,
      this.idactividad,
      this.labor,
      this.descripcion,
      this.activo,
      this.idusuario,
      this.fechamod,
      this.actividad,
      this.size});

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
  @HiveField(7)
  ActividadEntity actividad;
  int size;

  factory LaborEntity.fromJson(Map<String, dynamic> json) => LaborEntity(
        idlabor: json["idlabor"],
        idactividad: json["idactividad"],
        labor: json["labor"],
        descripcion: json["descripcion"],
        activo: json["activo"],
        size: json["size"] == null ? null : json['size'],
        idusuario: json['usuario'] == null ? null : json["idusuario"],
        fechamod:
            json['fechamod'] == null ? null : DateTime?.parse(json["fechamod"]),
        actividad: json["Actividad"] == null
            ? null
            : ActividadEntity.fromJson(json['Actividad']),
      );

  Map<String, dynamic> toJson() => {
        "idlabor": idlabor,
        "idactividad": idactividad,
        "labor": labor,
        "descripcion": descripcion,
        "activo": activo,
        "size": size == null ? null : size,
        "idusuario": idusuario,
        "fechamod": fechamod?.toIso8601String(),
        "Actividad": actividad?.toJson(),
      };
}

List<LaborEntity> laborEntityFromJson(String str) => List<LaborEntity>.from(
    json.decode(str).map((x) => LaborEntity.fromJson(x)));

String laborEntityToJson(List<LaborEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
