import 'dart:convert';

import 'package:hive/hive.dart';

part 'cultivo_entity.g.dart';

@HiveType(typeId: 15)
class CultivoEntity {
    CultivoEntity({
        this.idcultivo,
        this.detallecultivo,
        this.cultivo,
    });

    @HiveField(1)
    int idcultivo;
    @HiveField(2)
    String detallecultivo;
    @HiveField(3)
    String cultivo;

    factory CultivoEntity.fromJson(Map<String, dynamic> json) => CultivoEntity(
        idcultivo: json["idcultivo"] == null ? null : json["idcultivo"],
        detallecultivo: json["detallecultivo"] == null ? null : json["detallecultivo"],
        cultivo: json["cultivo"] == null ? null : json["cultivo"],
    );

    Map<String, dynamic> toJson() => {
        "idcultivo": idcultivo == null ? null : idcultivo,
        "detallecultivo": detallecultivo == null ? null : detallecultivo,
        "cultivo": cultivo == null ? null : cultivo,
    };
}

List<CultivoEntity> cultivoEntityFromJson(String str) => List<CultivoEntity>.from(json.decode(str).map((x) => CultivoEntity.fromJson(x)));

String cultivoEntityToJson(List<CultivoEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
