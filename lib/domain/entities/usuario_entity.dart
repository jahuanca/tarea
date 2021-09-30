// To parse this JSON data, do
//
//     final usuarioEntity = usuarioEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_tareo/domain/entities/usuario_perfil_entity.dart';
import 'package:hive/hive.dart';

part 'usuario_entity.g.dart';

@HiveType(typeId: 7)
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
    this.idsubdivision,
    this.usuarioPerfils,
  });

  @HiveField(0)
  int idusuario;
  @HiveField(1)
  int idtipodocumento;
  @HiveField(2)
  String alias;
  @HiveField(3)
  String password;
  @HiveField(4)
  String apellidosnombres;
  @HiveField(5)
  String nrodocumento;
  @HiveField(6)
  String email;
  @HiveField(7)
  String area;
  @HiveField(8)
  int activo;
  @HiveField(9)
  DateTime fechamod;
  @HiveField(10)
  int idsubdivision;
  @HiveField(11)
  List<UsuarioPerfilEntity> usuarioPerfils;

  

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
        idsubdivision: json["idsubdivision"],
        fechamod: DateTime?.parse(json["fechamod"]),
        usuarioPerfils: json["Usuario_Perfils"] == null ? null : List<UsuarioPerfilEntity>.from(json["Usuario_Perfils"].map((x) => UsuarioPerfilEntity.fromJson(x))),
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
        "idsubdivision": idsubdivision,
        "fechamod": fechamod?.toIso8601String(),
        "Usuario_Perfils": usuarioPerfils == null ? null : List<dynamic>.from(usuarioPerfils.map((x) => x.toJson())),
      };
}

List<UsuarioEntity> usuarioEntityFromJson(String str) =>
    List<UsuarioEntity>.from(
        json.decode(str).map((x) => UsuarioEntity.fromJson(x)));

String usuarioEntityToJson(List<UsuarioEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
