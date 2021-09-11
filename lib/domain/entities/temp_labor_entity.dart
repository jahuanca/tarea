// To parse this JSON data, do
//
//     final tempLaborEntity = tempLaborEntityFromJson(jsonString);

import 'dart:convert';

List<TempLaborEntity> tempLaborEntityFromJson(String str) => List<TempLaborEntity>.from(json.decode(str).map((x) => TempLaborEntity.fromJson(x)));

String tempLaborEntityToJson(List<TempLaborEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempLaborEntity {
    TempLaborEntity({
        this.labor,
        this.descLabor,
        this.actividad,
        this.sociedad,
        this.fechamod,
        this.horamod,
    });

    String labor;
    String descLabor;
    String actividad;
    Sociedad sociedad;
    DateTime fechamod;
    DateTime horamod;

    factory TempLaborEntity.fromJson(Map<String, dynamic> json) => TempLaborEntity(
        labor: json["LABOR"],
        descLabor: json["DESC_LABOR"],
        actividad: json["ACTIVIDAD"],
        sociedad: sociedadValues.map[json["SOCIEDAD"]],
        fechamod: DateTime.parse(json["Fechamod"]),
        horamod: DateTime.parse(json["Horamod"]),
    );

    Map<String, dynamic> toJson() => {
        "LABOR": labor,
        "DESC_LABOR": descLabor,
        "ACTIVIDAD": actividad,
        "SOCIEDAD": sociedadValues.reverse[sociedad],
        "Fechamod": "${fechamod.year.toString().padLeft(4, '0')}-${fechamod.month.toString().padLeft(2, '0')}-${fechamod.day.toString().padLeft(2, '0')}",
        "Horamod": horamod.toIso8601String(),
    };
}

enum Sociedad { PE10, PE20 }

final sociedadValues = EnumValues({
    "PE10": Sociedad.PE10,
    "PE20": Sociedad.PE20
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
