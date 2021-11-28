
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';

abstract class PreTareoProcesoUvaDetallesRepository{

  Future<List<PreTareoProcesoUvaDetalleEntity>> getAll(String box);
  Future<int> create(String box, PreTareoProcesoUvaDetalleEntity detalle);
  Future<void> update(String box, int key, PreTareoProcesoUvaDetalleEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}