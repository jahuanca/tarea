
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';

abstract class SubdivisionRepository{

  Future<List<SubdivisionEntity>> getAll();
}