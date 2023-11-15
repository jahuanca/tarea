import 'dart:async';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/domain/utils/hive_manager.dart';
import 'package:hive/hive.dart';

class AppHiveManager implements HiveManager {
  @override
  Future<List<dynamic>> getAll({String keyPath}) async {
    Box dataHive = await Hive.openBox(keyPath);
    List<dynamic> local = dataHive.values.toList();
    local.sort((a, b) => b?.fechamod?.compareTo(a?.fechamod));
    await dataHive.compact();
    await dataHive.close();
    return local;
  }

  @override
  Future<List<dynamic>> getAllByValues(
      {String keyPath, Map<String, dynamic> values}) async {
    Box dataHive = await Hive.openBox(keyPath);
    List<dynamic> data = [];
    dataHive.values.forEach((e) {
      bool save = BOOLEAN_TRUE_VALUE;
      values.forEach((key, value) {
        if (e.toJson()[key] != value) save = BOOLEAN_FALSE_VALUE;
      });
      if (save) data.add(e);
    });
    await dataHive.close();
    return data;
  }

  @override
  Future<int> create({String keyPath, dynamic value}) async {
    Box dataHive = await Hive.openBox(keyPath);
    int id = await dataHive.add(value);
    value.key = id;
    await dataHive.put(id, value);
    await dataHive.close();
    return id;
  }

  @override
  Future<void> update({
    String keyPath,
    int keyValue,
    dynamic value,
  }) async {
    Box dataHive = await Hive.openBox(keyPath);
    await dataHive.putAt(keyValue, value);
    await dataHive.close();
  }

  @override
  Future<dynamic> deleteDetail({String keyPath, int keyValue}) async {
    Box dataHive = await Hive.openBox(keyPath);
    await dataHive.delete(keyValue);
    await dataHive.close();
  }

  @override
  Future deleteMaster(
      {String keyPathMaster, int keyValue, String keyPathDetail}) async {
    Box master = await Hive.openBox(keyPathMaster);
    await master.delete(keyValue);
    await master.close();

    Box details = await Hive.openBox('${keyPathDetail}_$keyValue');
    await details.deleteFromDisk();
    await details.close();
  }
}
