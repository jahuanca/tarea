import 'package:hive/hive.dart';

part 'log_entity.g.dart';

@HiveType(typeId: 8)
class LogEntity {
  LogEntity({
    this.id,
    this.version,
    this.fecha,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String version;
  @HiveField(2)
  DateTime fecha;

  factory LogEntity.fromJson(Map<String, dynamic> json) => LogEntity(
        id: json["id"],
        version: json["version"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "fecha": fecha,
      };
}
