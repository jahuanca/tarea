
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';

abstract class AuthRepository{
  Future<UsuarioEntity> login(UsuarioEntity usuarioEntity);
}