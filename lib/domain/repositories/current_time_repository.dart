
import 'package:flutter_tareo/domain/entities/current_time_entity.dart';

abstract class CurrentTimeRepository{
  Future<CurrentTimeEntity> get();
}