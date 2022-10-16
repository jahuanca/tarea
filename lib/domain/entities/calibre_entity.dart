// To parse this JSON data, do
//
//     final calibre = calibreFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'calibre_entity.g.dart';

@HiveType(typeId: 32)
class CalibreEntity {
    CalibreEntity({
        this.idcalibre,
        this.codigo,
        this.detalle,
    });

    @HiveField(0)
    int idcalibre;
    @HiveField(1)
    String codigo;
    @HiveField(2)
    String detalle;

    factory CalibreEntity.fromJson(Map<String, dynamic> json) => CalibreEntity(
        idcalibre: json["idcalibre"] == null ? null : json["idcalibre"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        detalle: json["detalle"] == null ? null : json["detalle"],
    );

    Map<String, dynamic> toJson() => {
        "idcalibre": idcalibre == null ? null : idcalibre,
        "codigo": codigo == null ? null : codigo,
        "detalle": detalle == null ? null : detalle,
    };
}

List<CalibreEntity> calibreEntityFromJson(String str) => List<CalibreEntity>.from(json.decode(str).map((x) => CalibreEntity.fromJson(x)));

String calibreEntityToJson(List<CalibreEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
