import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class ClienteRepositoryImplementation extends ClienteRepository {
  final urlModule = '/cliente';

  @override
  Future<List<ClienteEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<ClienteEntity>('clientes_sincronizar');
      List<ClienteEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return clienteEntityFromJson((res));
  }

  @override
  Future<List<ClienteEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<ClienteEntity> dataHive =
          await Hive.openBox<ClienteEntity>('clientes_sincronizar');
      List<ClienteEntity> local = [];

      dataHive.values.forEach((e) {
        bool guardar = true;
        valores.forEach((key, value) {
          if (e.toJson()[key] != value) {
            guardar = false;
          }
        });
        if (guardar) local.add(e);
      });
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    return [];
  }
}
