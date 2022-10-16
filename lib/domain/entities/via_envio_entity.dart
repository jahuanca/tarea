// To parse this JSON data, do
//
//     final viaEnvio = viaEnvioFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'via_envio_entity.g.dart';

@HiveType(typeId: 34)
class ViaEnvioEntity {
    ViaEnvioEntity({
        this.idvia,
        this.codigo,
        this.detalle,
    });

    @HiveField(0)
    int idvia;
    @HiveField(1)
    String codigo;
    @HiveField(2)
    String detalle;

    factory ViaEnvioEntity.fromJson(Map<String, dynamic> json) => ViaEnvioEntity(
        idvia: json["idvia"] == null ? null : json["idvia"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        detalle: json["detalle"] == null ? null : json["detalle"],
    );

    Map<String, dynamic> toJson() => {
        "idvia": idvia == null ? null : idvia,
        "codigo": codigo == null ? null : codigo,
        "detalle": detalle == null ? null : detalle,
    };

}

List<ViaEnvioEntity> viaEnvioEntityFromJson(String str) => List<ViaEnvioEntity>.from(json.decode(str).map((x) => ViaEnvioEntity.fromJson(x)));

String viaEnvioEntityToJson(List<ViaEnvioEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));