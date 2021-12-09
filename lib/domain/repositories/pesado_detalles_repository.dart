
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';

abstract class PesadoDetallesRepository{

  Future<List<PreTareaEsparragoDetalleVariosEntity>> getAll(String box);
  Future<int> create(String box, PreTareaEsparragoDetalleVariosEntity detalle);
  Future<void> update(String box, int key, PreTareaEsparragoDetalleVariosEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}