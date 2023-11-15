abstract class HiveManager {
  Future<List<dynamic>> getAll({String keyPath});

  Future<List<dynamic>> getAllByValues(
      {String keyPath, Map<String, dynamic> values});

  Future<int> create({String keyPath, dynamic value});

  Future<void> update({String keyPath, dynamic value});

  Future<dynamic> deleteDetail({String keyPath, int keyValue});

  Future<dynamic> deleteMaster(
      {String keyPathMaster, int keyValue, String keyPathDetail});
}
