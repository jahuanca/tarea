import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';


class SubdivisionRepositoryImplementation extends SubdivisionRepository {
  final urlModule = '/subdivision';


  @override
  Future<List<SubdivisionEntity>> getSubdivisions() async{
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return subdivisionEntityFromJson((res));
  }
}
 