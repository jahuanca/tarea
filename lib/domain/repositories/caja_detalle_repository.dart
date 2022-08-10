


import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';

abstract class CajaDetalleRepository{

  Future<List<PreTareaEsparragoDetalleEntity>> getAll(String box);
  Future<List<PreTareaEsparragoDetalleEntity>> getByCaja(int keyCaja);
  Future<int> getAllByCaja();
  Future<List<PreTareaEsparragoDetalleEntity>> getAllRegistrados(String box);
  Future<List<PreTareaEsparragoDetalleEntity>> getAllByValues(String box,Map<String, dynamic> valores);
  Future<int> create(String box, PreTareaEsparragoDetalleEntity detalle);
  Future<void> update(String box, PreTareaEsparragoDetalleEntity detalle , int key);
  Future<void> delete(String box,int key);
}