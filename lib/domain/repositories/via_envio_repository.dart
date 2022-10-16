
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';

abstract class ViaEnvioRepository{

  Future<List<ViaEnvioEntity>> getAll();
  Future<List<ViaEnvioEntity>> getAllByValue(Map<String,dynamic> valores);
}