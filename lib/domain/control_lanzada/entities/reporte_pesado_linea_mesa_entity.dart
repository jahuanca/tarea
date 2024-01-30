// To parse this JSON data, do
//
//     final reportePesadoLineaMesaEntity = reportePesadoLineaMesaEntityFromJson(jsonString);

import 'dart:convert';

ReportePesadoLineaMesaEntity reportePesadoLineaMesaEntityFromJson(String str) =>
    ReportePesadoLineaMesaEntity.fromJson(json.decode(str));

String reportePesadoLineaMesaEntityToJson(ReportePesadoLineaMesaEntity data) =>
    json.encode(data.toJson());

class ReportePesadoLineaMesaEntity {
  Header header;
  List<Labor> labors;

  ReportePesadoLineaMesaEntity({
    this.header,
    this.labors,
  });

  factory ReportePesadoLineaMesaEntity.fromJson(Map<String, dynamic> json) =>
      ReportePesadoLineaMesaEntity(
        header: Header.fromJson(json["header"]),
        labors: List<Labor>.from(json["labors"].map((x) => Labor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "labors": List<dynamic>.from(labors.map((x) => x.toJson())),
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
