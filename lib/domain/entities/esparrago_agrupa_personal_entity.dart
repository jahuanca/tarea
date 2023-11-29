import 'package:hive/hive.dart';
import 'dart:convert';

part 'esparrago_agrupa_personal_entity.g.dart';

@HiveType(typeId: 31)
class EsparragoAgrupaPersonalEntity {
  EsparragoAgrupaPersonalEntity({
    this.itemagruparpersonal,
    this.fecha,
    this.linea,
    this.grupo,
    this.turno,
    this.fechamod,
    this.idusuario,
    this.idestado,
    this.estadoLocal,
    this.sizeDetails,
  });

  @HiveField(0)
  int itemagruparpersonal;
  @HiveField(1)
  DateTime fecha;
  @HiveField(2)
  int linea;
  @HiveField(3)
  int grupo;
  @HiveField(4)
  String turno;
  @HiveField(5)
  DateTime fechamod;
  @HiveField(6)
  int idusuario;
  @HiveField(7)
  int idestado;
  String estadoLocal;
  int sizeDetails;

  get getId => this.itemagruparpersonal;

  factory EsparragoAgrupaPersonalEntity.fromJson(Map<String, dynamic> json) =>
      EsparragoAgrupaPersonalEntity(
        itemagruparpersonal: json["itemagruparpersonal"] == null
            ? null
            : json["itemagruparpersonal"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        linea: json["linea"] == null ? null : json["linea"],
        grupo: json["grupo"] == null ? null : json["grupo"],
        turno: json["turno"] == null ? null : json["turno"],
        sizeDetails: json["sizeDetails"] == null ? null : json["sizeDetails"],
        fechamod:
            json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        idestado: json["idestado"] == null ? null : json["idestado"],
      );

  Map<String, dynamic> toJson() => {
        "itemagruparpersonal":
            itemagruparpersonal == null ? null : itemagruparpersonal,
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "linea": linea == null ? null : linea,
        "grupo": grupo == null ? null : grupo,
        "turno": turno == null ? null : turno,
        "sizeDetails": sizeDetails == null ? null : sizeDetails,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "idusuario": idusuario == null ? null : idusuario,
        "idestado": idestado == null ? null : idestado,
      };
}

List<EsparragoAgrupaPersonalEntity> esparragoAgrupaPersonalEntityFromJson(
        String str) =>
    List<EsparragoAgrupaPersonalEntity>.from(
        json.decode(str).map((x) => EsparragoAgrupaPersonalEntity.fromJson(x)));

String esparragoAgrupaPersonalEntityToJson(
        List<EsparragoAgrupaPersonalEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
