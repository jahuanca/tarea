import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';

import 'package:hive/hive.dart';

part 'asistencia_registro_personal_entity.g.dart';

@HiveType(typeId: 39)
class AsistenciaRegistroPersonalEntity {
  AsistenciaRegistroPersonalEntity({
    this.idasistencia,
    this.codigoempresa,
    this.tipomovimiento,
    this.fechaentrada,
    this.horaentrada,
    this.idubicacionentrada,
    this.fechasalida,
    this.horasalida,
    this.idubicacionsalida,
    this.idturno,
    this.fechaturno,
    this.idusuario,
    this.fechamod,
    this.estadoLocal,
    this.key,
    this.personal,
    this.idasistenciaturno,
  });

  @HiveField(0)
  int idasistencia;
  @HiveField(1)
  String codigoempresa;
  @HiveField(2)
  String tipomovimiento;
  @HiveField(3)
  DateTime fechaentrada;
  @HiveField(4)
  DateTime horaentrada;
  @HiveField(5)
  int idubicacionentrada;
  @HiveField(6)
  DateTime fechasalida;
  @HiveField(7)
  DateTime horasalida;
  @HiveField(8)
  int idubicacionsalida;
  @HiveField(9)
  int idturno;
  @HiveField(10)
  DateTime fechaturno;
  @HiveField(11)
  int idusuario;
  @HiveField(12)
  DateTime fechamod;
  @HiveField(13)
  String estadoLocal;
  @HiveField(14)
  int key;
  @HiveField(15)
  PersonalEmpresaEntity personal;
  @HiveField(16)
  int idasistenciaturno;

  Color get colorEstado {
    switch (estadoLocal) {
      case 'P':
        return alertColor;
        break;
      case 'A':
        return successColor;
        break;
      case 'M':
        return infoColor;
        break;
      default:
        return primaryColor;
        break;
    }
  }

  get getId => this.idasistencia;

  set setId(value) => this.idasistencia = value;

  factory AsistenciaRegistroPersonalEntity.fromJson(
          Map<String, dynamic> json) =>
      AsistenciaRegistroPersonalEntity(
        idasistencia:
            json["idasistencia"] == null ? null : json["idasistencia"],
        idasistenciaturno: json["idasistenciaturno"] == null
            ? null
            : json["idasistenciaturno"],
        codigoempresa:
            json["codigoempresa"] == null ? null : json["codigoempresa"],
        tipomovimiento:
            json["tipomovimiento"] == null ? null : json["tipomovimiento"],
        fechaentrada: json["fechaentrada"] == null
            ? null
            : DateTime.parse(json["fechaentrada"]),
        horaentrada: json["horaentrada"] == null
            ? null
            : DateTime.parse(json["horaentrada"]),
        idubicacionentrada: json["idubicacionentrada"] == null
            ? null
            : json["idubicacionentrada"],
        fechasalida: json["fechasalida"] == null
            ? null
            : DateTime.parse(json["fechasalida"]),
        horasalida: json["horasalida"] == null
            ? null
            : DateTime.parse(json["horasalida"]),
        idubicacionsalida: json["idubicacionsalida"] == null
            ? null
            : json["idubicacionsalida"],
        idturno: json["idturno"] == null ? null : json["idturno"],
        fechaturno: json["fechaturno"] == null
            ? null
            : DateTime.parse(json["fechaturno"]),
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        fechamod:
            json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        estadoLocal: json["estado"] == null ? null : json["estado"],
        key: json["key"] == null ? null : json["key"],
        personal: json["personal"] == null
            ? null
            : PersonalEmpresaEntity.fromJson(json["personal"]),
      );

  Map<String, dynamic> toJson() => {
        "idasistencia": idasistencia == null ? null : idasistencia,
        "idasistenciaturno":
            idasistenciaturno == null ? null : idasistenciaturno,
        "codigoempresa": codigoempresa == null ? null : codigoempresa,
        "tipomovimiento": tipomovimiento == null ? null : tipomovimiento,
        "fechaentrada":
            fechaentrada == null ? null : fechaentrada.toIso8601String(),
        "horaentrada":
            horaentrada == null ? null : horaentrada.toIso8601String(),
        "idubicacionentrada":
            idubicacionentrada == null ? null : idubicacionentrada,
        "fechasalida":
            fechasalida == null ? null : fechasalida.toIso8601String(),
        "horasalida": horasalida == null ? null : horasalida.toIso8601String(),
        "idubicacionsalida":
            idubicacionsalida == null ? null : idubicacionsalida,
        "idturno": idturno == null ? null : idturno,
        "fechaturno": fechaturno == null ? null : fechaturno.toIso8601String(),
        "idusuario": idusuario == null ? null : idusuario,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "estado": estadoLocal == null ? null : estadoLocal,
        "key": key == null ? null : key,
        "personal": personal == null ? null : personal.toJson(),
      };
}

List<AsistenciaRegistroPersonalEntity> asistenciaRegistroPersonalEntityFromJson(
        String str) =>
    List<AsistenciaRegistroPersonalEntity>.from(json
        .decode(str)
        .map((x) => AsistenciaRegistroPersonalEntity.fromJson(x)));

String asistenciaRegistroPersonalEntityToJson(
        List<AsistenciaRegistroPersonalEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
