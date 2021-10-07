// To parse this JSON data, do
//
//     final presentacionLineaEntity = presentacionLineaEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'presentacion_linea_entity.g.dart';

@HiveType(typeId: 16)

class PresentacionLineaEntity {
    PresentacionLineaEntity({
        this.idpresentacion,
        this.descripcion,
        this.codigoempresa,
    });

    @HiveField(0)
    int idpresentacion;
    @HiveField(1)
    String descripcion;
    @HiveField(2)
    String codigoempresa;

    factory PresentacionLineaEntity.fromJson(Map<String, dynamic> json) => PresentacionLineaEntity(
        idpresentacion: json["idpresentacion"] == null ? null : json["idpresentacion"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        codigoempresa: json["codigoempresa"] == null ? null : json["codigoempresa"],
    );

    Map<String, dynamic> toJson() => {
        "idpresentacion": idpresentacion == null ? null : idpresentacion,
        "descripcion": descripcion == null ? null : descripcion,
        "codigoempresa": codigoempresa == null ? null : codigoempresa,
    };
}
List<PresentacionLineaEntity> presentacionLineaEntityFromJson(String str) => List<PresentacionLineaEntity>.from(json.decode(str).map((x) => PresentacionLineaEntity.fromJson(x)));

String presentacionLineaEntityToJson(List<PresentacionLineaEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));