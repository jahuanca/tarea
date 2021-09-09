// To parse this JSON data, do
//
//     final usuarioEntity = usuarioEntityFromJson(jsonString);

import 'dart:convert';

List<UsuarioEntity> usuarioEntityFromJson(String str) => List<UsuarioEntity>.from(json.decode(str).map((x) => UsuarioEntity.fromJson(x)));

String usuarioEntityToJson(List<UsuarioEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsuarioEntity {
    UsuarioEntity({
        this.idusuario,
        this.idtipodocumento,
        this.alias,
        this.password,
        this.apellidosnombres,
        this.nrodocumento,
        this.email,
        this.area,
        this.activo,
        this.fechamod,
        this.token,
    });

    int idusuario;
    int idtipodocumento;
    String alias;
    String password;
    String apellidosnombres;
    String nrodocumento;
    String email;
    String area;
    int activo;
    DateTime fechamod;


    String token;

    factory UsuarioEntity.fromJson(Map<String, dynamic> json) => UsuarioEntity(
        idusuario: json["idusuario"],
        idtipodocumento: json["idtipodocumento"],
        alias: json["alias"],
        password: json["password"],
        apellidosnombres: json["apellidosnombres"],
        nrodocumento: json["nrodocumento"],
        email: json["email"],
        area: json["area"],
        activo: json["activo"],
        token: json["token"],
        fechamod: DateTime.parse(json["fechamod"]),
    );

    Map<String, dynamic> toJson() => {
        "idusuario": idusuario,
        "idtipodocumento": idtipodocumento,
        "alias": alias,
        "password": password,
        "apellidosnombres": apellidosnombres,
        "nrodocumento": nrodocumento,
        "email": email,
        "area": area,
        "activo": activo,
        
        "fechamod": fechamod?.toIso8601String(),
    };
}
