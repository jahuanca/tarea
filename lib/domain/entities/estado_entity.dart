// To parse this JSON data, do
//
//     final estadoEntity = estadoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'estado_entity.g.dart';

@HiveType(typeId: 33)

class EstadoEntity {
    EstadoEntity({
        this.idestado,
        this.detalle,
        this.estado,
    });

    @HiveField(0)
    int idestado;
    @HiveField(1)
    String detalle;
    @HiveField(2)
    String estado;

    factory EstadoEntity.fromJson(Map<String, dynamic> json) => EstadoEntity(
        idestado: json["idestado"] == null ? null : json["idestado"],
        detalle: json["detalle"] == null ? null : json["detalle"],
        estado: json["estado"] == null ? null : json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idestado": idestado == null ? null : idestado,
        "detalle": detalle == null ? null : detalle,
        "estado": estado == null ? null : estado,
    };
}

List<EstadoEntity> estadoEntityFromJson(String str) => List<EstadoEntity>.from(json.decode(str).map((x) => EstadoEntity.fromJson(x)));

String estadoEntityToJson(List<EstadoEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));