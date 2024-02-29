// To parse this JSON data, do
//
//     final ReportePackingEntity = ReportePackingEntityFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';

ReportePackingEntity reportePackingEntityFromJson(String str) =>
    ReportePackingEntity.fromJson(json.decode(str));

String reportePackingEntityToJson(ReportePackingEntity data) =>
    json.encode(data.toJson());

class ReportePackingEntity {
  PreTareoProcesoUvaEntity header;
  PersonalEmpresaEntity personal;
  Map<int, List<PreTareoProcesoUvaDetalleEntity>> labors;
  List<LaborEntity> laborsOnline;

  ReportePackingEntity(
      {this.header, this.personal, this.labors, this.laborsOnline});

  factory ReportePackingEntity.fromJson(Map<String, dynamic> json) =>
      ReportePackingEntity(
        header: PreTareoProcesoUvaEntity.fromJson(json["header"]),
        personal: PersonalEmpresaEntity.fromJson(json["personal"]),
        laborsOnline: json['laborsOnline'] == null
            ? null
            : laborEntityFromJson(json['labornOnline']),
        labors: Map<int, List<PreTareoProcesoUvaDetalleEntity>>.from(
            json["labors"]
                .map((x) => PreTareoProcesoUvaDetalleEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "personal": personal.toJson(),
        "labors": labors,
        "laborOnLine": laborsOnline
      };
}

class Header {
  int itemagruparpersonal;
  DateTime fecha;
  int linea;
  int grupo;
  String turno;
  DateTime fechamod;
  int idusuario;
  int idestado;
  int sizePersonalMesa;
  int sizeDetails;

  Header({
    this.itemagruparpersonal,
    this.fecha,
    this.linea,
    this.grupo,
    this.turno,
    this.fechamod,
    this.idusuario,
    this.idestado,
    this.sizePersonalMesa,
    this.sizeDetails,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        itemagruparpersonal: json["itemagruparpersonal"],
        fecha: DateTime.parse(json["fecha"]),
        linea: json["linea"],
        grupo: json["grupo"],
        turno: json["turno"],
        fechamod: DateTime.parse(json["fechamod"]),
        idusuario: json["idusuario"],
        idestado: json["idestado"],
        sizePersonalMesa: json["sizePersonalMesa"],
        sizeDetails: json["sizeDetails"],
      );

  Map<String, dynamic> toJson() => {
        "itemagruparpersonal": itemagruparpersonal,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "linea": linea,
        "grupo": grupo,
        "turno": turno,
        "fechamod": fechamod.toIso8601String(),
        "idusuario": idusuario,
        "idestado": idestado,
        "sizePersonalMesa": sizePersonalMesa,
        "sizeDetails": sizeDetails,
      };
}

class Labor {
  int idlabor;
  String labor;
  String descripcion;
  int sizeDetails;

  Labor({
    this.idlabor,
    this.labor,
    this.descripcion,
    this.sizeDetails,
  });

  factory Labor.fromJson(Map<String, dynamic> json) => Labor(
        idlabor: json["idlabor"],
        labor: json["labor"],
        descripcion: json["descripcion"],
        sizeDetails: json["sizeDetails"],
      );

  Map<String, dynamic> toJson() => {
        "idlabor": idlabor,
        "labor": labor,
        "descripcion": descripcion,
        "sizeDetails": sizeDetails,
      };
}
