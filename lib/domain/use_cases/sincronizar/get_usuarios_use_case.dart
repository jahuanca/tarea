
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/repositories/usuario_repository.dart';

class GetUsuariosUseCase{
  final UsuarioRepository _usuarioRepository;

  GetUsuariosUseCase(this._usuarioRepository);

  Future<List<UsuarioEntity>> execute() async{
    return await _usuarioRepository.getAll();
  }
}