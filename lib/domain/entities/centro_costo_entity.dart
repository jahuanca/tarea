// To parse this JSON data, do
//
//     final centroCostoEntity = centroCostoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'centro_costo_entity.g.dart';

@HiveType(typeId: 10)
class CentroCostoEntity {
  CentroCostoEntity({
    this.idcentrocosto,
    this.detallecentrocosto,
    this.idsociedad,
    this.idtipocentrocosto,
    this.homologacion,
    this.activo,
    this.fechamod,
    this.idusuario,
    this.codigoempresa,
  });

  @HiveField(0)
  int idcentrocosto;
  @HiveField(1)
  String detallecentrocosto;
  @HiveField(2)
  int idsociedad;
  @HiveField(3)
  int idtipocentrocosto;
  @HiveField(4)
  String homologacion;
  @HiveField(5)
  bool activo;
  @HiveField(6)
  DateTime fechamod;
  @HiveField(7)
  int idusuario;
  @HiveField(8)
  String codigoempresa;

  factory CentroCostoEntity.fromJson(Map<String, dynamic> json) =>
      CentroCostoEntity(
        idcentrocosto: json["idcentrocosto"],
        detallecentrocosto: json["detallecentrocosto"],
        idsociedad: json["idsociedad"],
        idtipocentrocosto: json["idtipocentrocosto"],
        homologacion: json["homologacion"],
        activo: json["activo"],
        fechamod: DateTime.parse(json["fechamod"]),
        idusuario: json["idusuario"],
        codigoempresa: json["codigoempresa"],
      );

  Map<String, dynamic> toJson() => {
        "idcentrocosto": idcentrocosto,
        "detallecentrocosto": detallecentrocosto,
        "idsociedad": idsociedad,
        "idtipocentrocosto": idtipocentrocosto,
        "homologacion": homologacion,
        "activo": activo,
        "fechamod": fechamod.toIso8601String(),
        "idusuario": idusuario,
        "codigoempresa": codigoempresa,
      };
}

List<CentroCostoEntity> centroCostoEntityFromJson(String str) =>
    List<CentroCostoEntity>.from(
        json.decode(str).map((x) => CentroCostoEntity.fromJson(x)));

String centroCostoEntityToJson(List<CentroCostoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
