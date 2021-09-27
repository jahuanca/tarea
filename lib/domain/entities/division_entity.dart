// To parse this JSON data, do
//
//     final divisionEntity = divisionEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'division_entity.g.dart';

@HiveType(typeId: 11)
class DivisionEntity {
  DivisionEntity({
    this.iddivision,
    this.detalledivision,
    this.idsociedad,
    this.division,
  });

  @HiveField(0)
  int iddivision;
  @HiveField(1)
  String detalledivision;
  @HiveField(2)
  int idsociedad;
  @HiveField(3)
  String division;

  factory DivisionEntity.fromJson(Map<String, dynamic> json) => DivisionEntity(
        iddivision: json["iddivision"],
        detalledivision: json["detalledivision"],
        idsociedad: json["idsociedad"],
        division: json["division"],
      );

  Map<String, dynamic> toJson() => {
        "iddivision": iddivision,
        "detalledivision": detalledivision,
        "idsociedad": idsociedad,
        "division": division,
      };
}

List<DivisionEntity> divisionEntityFromJson(String str) =>
    List<DivisionEntity>.from(
        json.decode(str).map((x) => DivisionEntity.fromJson(x)));

String divisionEntityToJson(List<DivisionEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
