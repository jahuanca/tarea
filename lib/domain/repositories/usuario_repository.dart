
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';

abstract class UsuarioRepository{

  Future<List<UsuarioEntity>> getAll();
}