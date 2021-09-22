// To parse this JSON data, do
//
//     final personalEmpresaSubdivisionEntity = personalEmpresaSubdivisionEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';

part 'personal_empresa_subdivision_entity.g.dart';

@HiveType(typeId : 6)
class PersonalEmpresaSubdivisionEntity {
    PersonalEmpresaSubdivisionEntity({
        this.codigoempresa,
        this.idsubdivision,
        this.fechadesde,
        this.fechahasta,
        this.activo,
        this.fechamod,
        this.idusuario,
        this.personalEmpresa,
    });

    @HiveField(0)
    String codigoempresa;
    @HiveField(1)
    int idsubdivision;
    @HiveField(2)
    DateTime fechadesde;
    @HiveField(3)
    DateTime fechahasta;
    @HiveField(4)
    bool activo;
    @HiveField(5)
    DateTime fechamod;
    @HiveField(6)
    int idusuario;
    @HiveField(7)
    PersonalEmpresaEntity personalEmpresa;

    factory PersonalEmpresaSubdivisionEntity.fromJson(Map<String, dynamic> json) => PersonalEmpresaSubdivisionEntity(
        codigoempresa: json["codigoempresa"],
        idsubdivision: json["idsubdivision"],
        fechadesde: DateTime.parse(json["fechadesde"]),
        fechahasta: DateTime.parse(json["fechahasta"]),
        activo: json["activo"],
        fechamod: DateTime.parse(json["fechamod"]),
        idusuario: json["idusuario"],
        personalEmpresa: json['Personal_Empresa']== null ? null : PersonalEmpresaEntity.fromJson(json["Personal_Empresa"]),
    );

    Map<String, dynamic> toJson() => {
        "codigoempresa": codigoempresa,
        "idsubdivision": idsubdivision,
        "fechadesde": fechadesde?.toIso8601String(),
        "fechahasta": fechahasta?.toIso8601String(),
        "activo": activo,
        "fechamod": fechamod?.toIso8601String(),
        "idusuario": idusuario,
        "Personal_Empresa": personalEmpresa?.toJson(),
    };
}

List<PersonalEmpresaSubdivisionEntity> personalEmpresaSubdivisionEntityFromJson(String str) => List<PersonalEmpresaSubdivisionEntity>.from(json.decode(str).map((x) => PersonalEmpresaSubdivisionEntity.fromJson(x)));

String personalEmpresaSubdivisionEntityToJson(List<PersonalEmpresaSubdivisionEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));