// To parse this JSON data, do
//
//     final personalEmpresaEntity = personalEmpresaEntityFromJson(jsonString);

import 'dart:convert';

List<PersonalEmpresaEntity> personalEmpresaEntityFromJson(String str) => List<PersonalEmpresaEntity>.from(json.decode(str).map((x) => PersonalEmpresaEntity.fromJson(x)));

String personalEmpresaEntityToJson(List<PersonalEmpresaEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonalEmpresaEntity {
    PersonalEmpresaEntity({
        this.codigoempresa,
        this.apellidopaterno,
        this.apellidomaterno,
        this.nombres,
        this.nrodocumento,
        this.fechamod,
        this.idtipodocumento,
        this.fechaingreso,
        this.bloqueado,
        this.fechacese,
        this.idusuario,
    });

    String codigoempresa;
    String apellidopaterno;
    String apellidomaterno;
    String nombres;
    String nrodocumento;
    DateTime fechamod;
    int idtipodocumento;
    DateTime fechaingreso;
    bool bloqueado;
    DateTime fechacese;
    int idusuario;

    factory PersonalEmpresaEntity.fromJson(Map<String, dynamic> json) => PersonalEmpresaEntity(
        codigoempresa: json["codigoempresa"],
        apellidopaterno: json["apellidopaterno"],
        apellidomaterno: json["apellidomaterno"],
        nombres: json["nombres"],
        nrodocumento: json["nrodocumento"],
        fechamod: DateTime?.parse(json["fechamod"]),
        idtipodocumento: json["idtipodocumento"],
        fechaingreso: DateTime?.parse(json["fechaingreso"]),
        bloqueado: json["bloqueado"],
        fechacese: DateTime?.parse(json["fechacese"]),
        idusuario: json["idusuario"],
    );

    String get nombreCompleto{
      return apellidopaterno+' '+apellidomaterno+' , '+nombres;
    }

    Map<String, dynamic> toJson() => {
        "codigoempresa": codigoempresa,
        "apellidopaterno": apellidopaterno,
        "apellidomaterno": apellidomaterno,
        "nombres": nombres,
        "nrodocumento": nrodocumento,
        "fechamod": fechamod.toIso8601String(),
        "idtipodocumento": idtipodocumento,
        "fechaingreso": "${fechaingreso.year.toString().padLeft(4, '0')}-${fechaingreso.month.toString().padLeft(2, '0')}-${fechaingreso.day.toString().padLeft(2, '0')}",
        "bloqueado": bloqueado,
        "fechacese": "${fechacese.year.toString().padLeft(4, '0')}-${fechacese.month.toString().padLeft(2, '0')}-${fechacese.day.toString().padLeft(2, '0')}",
        "idusuario": idusuario,
    };
}
