

import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/repositories/auth_repository.dart';

class SignInUseCase{
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<UsuarioEntity> execute(UsuarioEntity usuarioEntity)async{
    return await _authRepository.login(usuarioEntity);
  } 
}