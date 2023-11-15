import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
import 'package:hive/hive.dart';

part 'asistencia_fecha_turno_entity.g.dart';

@HiveType(typeId: 38)
class AsistenciaFechaTurnoEntity {
  AsistenciaFechaTurnoEntity({
    this.idasistenciaturno,
    this.key,
    this.idubicacion,
    this.idturno,
    this.idestado,
    this.idusuario,
    this.fecha,
    this.fechamod,
    this.ipmovil,
    this.estadoLocal,
    this.turno,
    this.ubicacion,
    this.sizeDetails,
    this.detalles,
    this.pathUrl,
    this.firmaSupervisor,
    this.sizeEntradas,
    this.sizeSalidas,
  });

  @HiveField(0)
  int key;
  @HiveField(1)
  int idasistenciaturno;
  @HiveField(2)
  int idubicacion;
  @HiveField(3)
  int idturno;
  @HiveField(4)
  int idestado;
  @HiveField(5)
  int idusuario;
  @HiveField(6)
  DateTime fecha;
  @HiveField(7)
  DateTime fechamod;
  @HiveField(8)
  String ipmovil;
  @HiveField(9)
  String estadoLocal;
  @HiveField(10)
  TurnoEntity turno;
  @HiveField(11)
  AsistenciaUbicacionEntity ubicacion;

  List<AsistenciaRegistroPersonalEntity> detalles = [];

  @HiveField(12)
  int sizeDetails;
  @HiveField(13)
  String pathUrl;
  @HiveField(14)
  String firmaSupervisor;
  @HiveField(15)
  int sizeEntradas;
  @HiveField(16)
  int sizeSalidas;

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

  get getId => this.idasistenciaturno;

  set setId(value) => this.idasistenciaturno = value;

  factory AsistenciaFechaTurnoEntity.fromJson(Map<String, dynamic> json) =>
      AsistenciaFechaTurnoEntity(
        idasistenciaturno: json["idasistenciaturno"] == null
            ? null
            : json["idasistenciaturno"],
        idubicacion: json["idubicacion"] == null ? null : json["idubicacion"],
        sizeSalidas: json["sizeSalidas"] == null ? null : json["sizeSalidas"],
        sizeEntradas:
            json["sizeEntradas"] == null ? null : json["sizeEntradas"],
        idturno: json["idturno"] == null ? null : json["idturno"],
        idestado: json["idestado"] == null ? null : json["idestado"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        fechamod:
            json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        ipmovil: json["ipmovil"] == null ? null : json["ipmovil"],
        estadoLocal: json["estado"] == null ? null : json["estado"],
        pathUrl: json["pathUrl"] == null ? null : json["pathUrl"],
        firmaSupervisor:
            json["firmaSupervisor"] == null ? null : json["firmaSupervisor"],
        key: json["key"] == null ? null : json["key"],
        sizeDetails: json["sizeDetails"] == null
            ? (json["sizeEntradas"] ?? 0) + (json["sizeSalidas"] ?? 0)
            : json["sizeDetails"],
        turno:
            json["Turno"] == null ? null : TurnoEntity.fromJson(json["Turno"]),
        ubicacion: json["Ubicacion"] == null
            ? null
            : AsistenciaUbicacionEntity.fromJson(json["Ubicacion"]),
        detalles: json['detalles'] == null
            ? null
            : List<AsistenciaRegistroPersonalEntity>.from(json["detalles"]
                .map((x) => AsistenciaRegistroPersonalEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idasistenciaturno":
            idasistenciaturno == null ? null : idasistenciaturno,
        "idubicacion": idubicacion == null ? null : idubicacion,
        "sizeEntradas": sizeEntradas == null ? null : sizeEntradas,
        "sizeSalidas": sizeSalidas == null ? null : sizeSalidas,
        "idturno": idturno == null ? null : idturno,
        "idestado": idestado == null ? null : idestado,
        "idusuario": idusuario == null ? null : idusuario,
        "fecha": fecha == null ? null : fecha.toIso8601String(),
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "pathUrl": pathUrl == null ? null : pathUrl,
        "firmaSupervisor": firmaSupervisor == null ? null : firmaSupervisor,
        "ipmovil": ipmovil == null ? null : ipmovil,
        "key": key == null ? null : key,
        "estado": estadoLocal == null ? null : estadoLocal,
        "sizeDetails": sizeDetails == null
            ? (sizeEntradas ?? 0) + (sizeSalidas ?? 0)
            : sizeDetails,
        "Turno": turno == null ? null : turno.toJson(),
        "Ubicacion": ubicacion == null ? null : ubicacion.toJson(),
        "detalles": detalles == null
            ? null
            : List<dynamic>.from(detalles.map((x) => x.toJson())),
      };
}

List<AsistenciaFechaTurnoEntity> asistenciaFechaTurnoEntityFromJson(
        String str) =>
    List<AsistenciaFechaTurnoEntity>.from(
        json.decode(str).map((x) => AsistenciaFechaTurnoEntity.fromJson(x)));

String asistenciaFechaTurnoEntityToJson(
        List<AsistenciaFechaTurnoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
