// To parse this JSON data, do
//
//     final tempLaborEntity = tempLaborEntityFromJson(jsonString);
import 'package:hive/hive.dart';
import 'dart:convert';

part 'temp_labor_entity.g.dart';

@HiveType(typeId: 2)
class TempLaborEntity {
  TempLaborEntity({
    this.labor,
    this.descLabor,
    this.actividad,
    this.sociedad,
    this.fechamod,
    this.horamod,
  });

  @HiveField(0)
  String labor;
  @HiveField(1)
  String descLabor;
  @HiveField(2)
  String actividad;
  @HiveField(3)
  String sociedad;
  @HiveField(4)
  DateTime fechamod;
  @HiveField(5)
  DateTime horamod;

  factory TempLaborEntity.fromJson(Map<String, dynamic> json) =>
      TempLaborEntity(
        labor: json["LABOR"],
        descLabor: json["DESC_LABOR"],
        actividad: json["ACTIVIDAD"],
        sociedad: json["SOCIEDAD"],
        fechamod: DateTime.parse(json["Fechamod"]),
        horamod: DateTime.parse(json["Horamod"]),
      );

  Map<String, dynamic> toJson() => {
        "LABOR": labor,
        "DESC_LABOR": descLabor,
        "ACTIVIDAD": actividad,
        "SOCIEDAD": sociedad,
        "Fechamod":
            "${fechamod.year.toString().padLeft(4, '0')}-${fechamod.month.toString().padLeft(2, '0')}-${fechamod.day.toString().padLeft(2, '0')}",
        "Horamod": horamod.toIso8601String(),
      };
}

List<TempLaborEntity> tempLaborEntityFromJson(String str) =>
    List<TempLaborEntity>.from(
        json.decode(str).map((x) => TempLaborEntity.fromJson(x)));

String tempLaborEntityToJson(List<TempLaborEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
