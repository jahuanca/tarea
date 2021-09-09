

import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/repositories/storage_repository.dart';

class SaveUserUseCase{
  final StorageRepository _storageRepository;

  SaveUserUseCase(this._storageRepository);

  Future<void> execute(UsuarioEntity data) async{
    return await _storageRepository.saveUser(data);
  }
}