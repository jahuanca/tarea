// To parse this JSON data, do
//
//     final usuarioEntity = usuarioEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'usuario_entity.g.dart';
@HiveType(typeId : 7)
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
        fechamod: DateTime?.parse(json["fechamod"]),
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

List<UsuarioEntity> usuarioEntityFromJson(String str) => List<UsuarioEntity>.from(json.decode(str).map((x) => UsuarioEntity.fromJson(x)));

String usuarioEntityToJson(List<UsuarioEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));