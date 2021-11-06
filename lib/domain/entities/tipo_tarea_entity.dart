
import 'dart:convert';
import 'package:hive/hive.dart';

part 'tipo_tarea_entity.g.dart';

@HiveType(typeId: 29)

class TipoTareaEntity {
    TipoTareaEntity({
        this.idtipotarea,
        this.descripcion,
    });

    @HiveField(0)
    int idtipotarea;
    @HiveField(1)
    String descripcion;

    factory TipoTareaEntity.fromJson(Map<String, dynamic> json) => TipoTareaEntity(
        idtipotarea: json["idtipotarea"] == null ? null : json["idtipotarea"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "idtipotarea": idtipotarea == null ? null : idtipotarea,
        "descripcion": descripcion == null ? null : descripcion,
    };
}

List<TipoTareaEntity> tipoTareaEntityFromJson(String str) => List<TipoTareaEntity>.from(json.decode(str).map((x) => TipoTareaEntity.fromJson(x)));

String tipoTareaEntityToJson(List<TipoTareaEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));