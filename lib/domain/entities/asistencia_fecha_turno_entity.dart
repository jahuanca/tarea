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

  factory AsistenciaFechaTurnoEntity.fromJson(Map<String, dynamic> json) =>
      AsistenciaFechaTurnoEntity(
        idasistenciaturno: json["idasistenciaturno"] == null
            ? null
            : json["idasistenciaturno"],
        idubicacion: json["idubicacion"] == null ? null : json["idubicacion"],
        idturno: json["idturno"] == null ? null : json["idturno"],
        idestado: json["idestado"] == null ? null : json["idestado"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        fecha: json["fecha"] == null ? null : json["fecha"],
        fechamod: json["fechamod"] == null ? null : json["fechamod"],
        ipmovil: json["ipmovil"] == null ? null : json["ipmovil"],
        estadoLocal: json["estadoLocal"] == null ? null : json["estadoLocal"],
        pathUrl: json["pathUrl"] == null ? null : json["pathUrl"],
        firmaSupervisor:
            json["firmaSupervisor"] == null ? null : json["firmaSupervisor"],
        key: json["key"] == null ? null : json["key"],
        sizeDetails: json["sizeDetails"] == null ? null : json["sizeDetails"],
        turno:
            json["turno"] == null ? null : TurnoEntity.fromJson(json["turno"]),
        ubicacion: json["ubicacion"] == null
            ? null
            : AsistenciaUbicacionEntity.fromJson(json["ubicacion"]),
        detalles: json['detalles'] == null
            ? null
            : List<AsistenciaRegistroPersonalEntity>.from(json["detalles"]
                .map((x) => AsistenciaRegistroPersonalEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idasistenciaturno":
            idasistenciaturno == null ? null : idasistenciaturno,
        "idubicacion": idubicacion == null ? null : idubicacion,
        "idturno": idturno == null ? null : idturno,
        "idestado": idestado == null ? null : idestado,
        "idusuario": idusuario == null ? null : idusuario,
        "fecha": fecha == null ? null : fecha,
        "fechamod": fechamod == null ? null : fechamod,
        "pathUrl": pathUrl == null ? null : pathUrl,
        "firmaSupervisor": firmaSupervisor == null ? null : firmaSupervisor,
        "ipmovil": ipmovil == null ? null : ipmovil,
        "key": key == null ? null : key,
        "estadoLocal": estadoLocal == null ? null : estadoLocal,
        "sizeDetails": sizeDetails == null ? null : sizeDetails,
        "turno": turno == null ? null : turno.toJson(),
        "ubicacion": ubicacion == null ? null : ubicacion.toJson(),
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
