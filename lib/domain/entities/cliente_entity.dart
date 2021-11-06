
import 'dart:convert';
import 'package:hive/hive.dart';

part 'cliente_entity.g.dart';

@HiveType(typeId: 30)

class ClienteEntity {
    ClienteEntity({
        this.idcliente,
        this.idtipocliente,
        this.abreviatura,
        this.descripcion,
    });


    @HiveField(0)
    int idcliente;
    @HiveField(1)
    int idtipocliente;
    @HiveField(2)
    String abreviatura;
    @HiveField(3)
    String descripcion;

    factory ClienteEntity.fromJson(Map<String, dynamic> json) => ClienteEntity(
        idcliente: json["idcliente"] == null ? null : json["idcliente"],
        idtipocliente: json["idtipocliente"] == null ? null : json["idtipocliente"],
        abreviatura: json["abreviatura"] == null ? null : json["abreviatura"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "idcliente": idcliente == null ? null : idcliente,
        "idtipocliente": idtipocliente == null ? null : idtipocliente,
        "abreviatura": abreviatura == null ? null : abreviatura,
        "descripcion": descripcion == null ? null : descripcion,
    };
}

List<ClienteEntity> clienteEntityFromJson(String str) => List<ClienteEntity>.from(json.decode(str).map((x) => ClienteEntity.fromJson(x)));

String clienteEntityToJson(List<ClienteEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));