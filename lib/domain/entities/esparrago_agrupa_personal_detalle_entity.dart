import 'dart:convert';

import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';

class EsparragoAgrupaPersonalDetalleEntity {
  EsparragoAgrupaPersonalDetalleEntity({
    this.itemagruparpersonaldetalle,
    this.itemagruparpersonal,
    this.codigoempresa,
    this.fechamod,
    this.idusuario,
    this.linea,
    this.grupo,
    this.turno,
    this.fecha,
    this.idestado,
    this.documento,
    this.estado,
    this.personal,
  });

  int itemagruparpersonaldetalle;
  int itemagruparpersonal;
  String codigoempresa;
  DateTime fechamod;
  int idusuario;
  int linea;
  int grupo;
  String turno;
  DateTime fecha;
  int idestado;
  String documento;
  String estado;
  PersonalEmpresaEntity personal;

  get getId => this.itemagruparpersonaldetalle;
  set setId(value) => this.itemagruparpersonaldetalle = value;

  factory EsparragoAgrupaPersonalDetalleEntity.fromJson(
          Map<String, dynamic> json) =>
      EsparragoAgrupaPersonalDetalleEntity(
        itemagruparpersonaldetalle: json["itemagruparpersonaldetalle"] == null
            ? null
            : json["itemagruparpersonaldetalle"],
        itemagruparpersonal: json["itemagruparpersonal"] == null
            ? null
            : json["itemagruparpersonal"],
        codigoempresa:
            json["codigoempresa"] == null ? null : json["codigoempresa"],
        fechamod:
            json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        linea: json["linea"] == null ? null : json["linea"],
        grupo: json["grupo"] == null ? null : json["grupo"],
        turno: json["turno"] == null ? null : json["turno"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        idestado: json["idestado"] == null ? null : json["idestado"],
        documento: json["documento"] == null ? null : json["documento"],
        estado: json["estado"] == null ? null : json["estado"],
        personal: json["personal"] == null
            ? null
            : PersonalEmpresaEntity.fromJson(json["personal"]),
      );

  Map<String, dynamic> toJson() => {
        "itemagruparpersonaldetalle": itemagruparpersonaldetalle == null
            ? null
            : itemagruparpersonaldetalle,
        "itemagruparpersonal":
            itemagruparpersonal == null ? null : itemagruparpersonal,
        "codigoempresa": codigoempresa == null ? null : codigoempresa,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "idusuario": idusuario == null ? null : idusuario,
        "linea": linea == null ? null : linea,
        "grupo": grupo == null ? null : grupo,
        "turno": turno == null ? null : turno,
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "idestado": idestado == null ? null : idestado,
        "documento": documento == null ? null : documento,
        "estado": estado == null ? null : estado,
        "personal": personal == null ? null : personal.toJson(),
      };
}

List<EsparragoAgrupaPersonalDetalleEntity>
    EsparragoAgrupaPersonalDetalleEntityFromJson(String str) =>
        List<EsparragoAgrupaPersonalDetalleEntity>.from(json
            .decode(str)
            .map((x) => EsparragoAgrupaPersonalDetalleEntity.fromJson(x)));

String esparragoAgrupaPersonalDetalleEntityToJson(
        List<EsparragoAgrupaPersonalDetalleEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
