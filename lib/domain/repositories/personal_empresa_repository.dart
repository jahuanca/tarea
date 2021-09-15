
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';

abstract class PersonalEmpresaRepository{
  Future<List<PersonalEmpresaEntity>> getAll();
  Future<List<PersonalEmpresaEntity>> getAllBySubdivision(int idSubdivision);
}