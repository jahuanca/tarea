
  // To parse this JSON data, do
//
//     final subdivisionEntity = subdivisionEntityFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'subdivision_entity.g.dart';

@HiveType(typeId : 4)
class SubdivisionEntity {
    SubdivisionEntity({
        this.idsubdivision,
        this.detallesubdivision,
        this.iddivision,
        this.subdivision,
    });

    @HiveField(0)
    int idsubdivision;
    @HiveField(1)
    String detallesubdivision;
    @HiveField(2)
    int iddivision;
    @HiveField(3)
    String subdivision;

    factory SubdivisionEntity.fromJson(Map<String, dynamic> json) => SubdivisionEntity(
        idsubdivision: json["idsubdivision"],
        detallesubdivision: json["detallesubdivision"],
        iddivision: json["iddivision"],
        subdivision: json["subdivision"],
    );

    Map<String, dynamic> toJson() => {
        "idsubdivision": idsubdivision,
        "detallesubdivision": detallesubdivision,
        "iddivision": iddivision,
        "subdivision": subdivision,
    };
}

List<SubdivisionEntity> subdivisionEntityFromJson(String str) => List<SubdivisionEntity>.from(json.decode(str).map((x) => SubdivisionEntity.fromJson(x)));

String subdivisionEntityToJson(List<SubdivisionEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));