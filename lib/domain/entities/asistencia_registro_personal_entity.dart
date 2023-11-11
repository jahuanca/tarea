// To parse this JSON data, do
//
//     final viaEnvio = viaEnvioFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/utils/colors.dart';

/*import 'package:hive/hive.dart';

part 'via_envio_entity.g.dart';

@HiveType(typeId: 34)*/
class AsistenciaRegistroPersonalEntity {
  AsistenciaRegistroPersonalEntity({
    this.idasistencia,
    this.codigoempresa,
    this.tipomovimiento,
  });

  //@HiveField(0)
  int idasistencia;
  String codigoempresa;
  String tipomovimiento;
  DateTime fechaentrada;
  DateTime horaentrada;
  int idubicacionentrada;
  DateTime fechasalida;
  DateTime horasalida;
  int idubicacionsalida;
  int idturno;
  DateTime fechaturno;
  int idusuario;
  DateTime fechamod;
  String estadoLocal;

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

  factory AsistenciaRegistroPersonalEntity.fromJson(
          Map<String, dynamic> json) =>
      AsistenciaRegistroPersonalEntity(
        idasistencia:
            json["idasistencia"] == null ? null : json["idasistencia"],
        codigoempresa:
            json["codigoempresa"] == null ? null : json["codigoempresa"],
        tipomovimiento:
            json["tipomovimiento"] == null ? null : json["tipomovimiento"],
      );

  Map<String, dynamic> toJson() => {
        "idasistencia": idasistencia == null ? null : idasistencia,
        "codigoempresa": codigoempresa == null ? null : codigoempresa,
        "tipomovimiento": tipomovimiento == null ? null : tipomovimiento,
      };
}

List<AsistenciaRegistroPersonalEntity> asistenciaUbicacionEntityFromJson(
        String str) =>
    List<AsistenciaRegistroPersonalEntity>.from(json
        .decode(str)
        .map((x) => AsistenciaRegistroPersonalEntity.fromJson(x)));

String asistenciaUbicacionEntityToJson(
        List<AsistenciaRegistroPersonalEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
