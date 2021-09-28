import 'dart:convert';

import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final urlModule = '/auth';

  

  @override
  Future<UsuarioEntity> login(UsuarioEntity usuarioEntity) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.post(
      url: '$urlModule/signIn',
      body: usuarioEntity.toJson(),
    );

    return res!=null ? UsuarioEntity.fromJson(jsonDecode(res)) : null;
  }

  
}
