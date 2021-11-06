
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';

class GetClientesUseCase{
  final ClienteRepository _clienteRepository;

  GetClientesUseCase(this._clienteRepository);

  Future<List<ClienteEntity>> execute() async{
    return await _clienteRepository.getAll();
  }
  
}