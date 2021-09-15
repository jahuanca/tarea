import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';


class PersonalEmpresaRepositoryImplementation extends PersonalEmpresaRepository {
  final urlModule = '/personal_empresa';


  @override
  Future<List<PersonalEmpresaEntity>> getAll() async{
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return personalEmpresaEntityFromJson((res));
  }

  @override
  Future<List<PersonalEmpresaEntity>> getAllBySubdivision(int idSubdivision) async{
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: '$urlModule/subdivision/$idSubdivision',
    );

    return personalEmpresaEntityFromJson((res));
  }
}
 