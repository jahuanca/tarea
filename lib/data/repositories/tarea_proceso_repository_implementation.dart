
import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';
import 'package:hive/hive.dart';

class TareaProcesoRepositoryImplementation extends TareaProcesoRepository {
  final urlModule = '/tarea_proceso';

  @override
  Future<void> create(TareaProcesoEntity tareaProcesoEntity) async  {
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    await tareas.add(tareaProcesoEntity);
  }

  @override
  Future<List<TareaProcesoEntity>> getAll() async{
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    return tareas.values.toList();
  }

  @override
  Future<void> delete(int index) async{
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    return await tareas.deleteAt(index);
  }

  @override
  Future<void> update(TareaProcesoEntity tareaProcesoEntity , int index) async{
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    return await tareas.putAt(index, tareaProcesoEntity);
  }

  @override
  Future<void> migrar(TareaProcesoEntity tareaProcesoEntity) async{
    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: tareaProcesoEntity.toJson(),
    );

    return;
  }

}
 