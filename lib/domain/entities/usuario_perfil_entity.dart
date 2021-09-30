import 'package:hive/hive.dart';

part 'usuario_perfil_entity.g.dart';

@HiveType(typeId: 13)
class UsuarioPerfilEntity {
    UsuarioPerfilEntity({
        this.idusuario,
        this.idPerfil,
        this.idsubdivision,
    });

    @HiveField(0)
    int idusuario;
    @HiveField(1)
    int idPerfil;
    @HiveField(2)
    int idsubdivision;

    factory UsuarioPerfilEntity.fromJson(Map<String, dynamic> json) => UsuarioPerfilEntity(
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        idPerfil: json["idPerfil"] == null ? null : json["idPerfil"],
        idsubdivision: json["idsubdivision"] == null ? null : json["idsubdivision"],
    );

    Map<String, dynamic> toJson() => {
        "idusuario": idusuario == null ? null : idusuario,
        "idPerfil": idPerfil == null ? null : idPerfil,
        "idsubdivision": idsubdivision == null ? null : idsubdivision,
    };
}
