
import 'package:flutter_tareo/domain/entities/personal_empresa_subdivision_entity.dart';

abstract class PersonalEmpresaSubdivisionRepository{
  Future<List<PersonalEmpresaSubdivisionEntity>> getBySubdivision();
}