
import 'package:flutter_tareo/domain/entities/current_time_entity.dart';
import 'package:flutter_tareo/domain/repositories/current_time_repository.dart';


class GetCurrentTimeWorldUseCase{
  final CurrentTimeRepository _currentTimeRepository;

  GetCurrentTimeWorldUseCase(this._currentTimeRepository);

  Future<CurrentTimeEntity> execute() async{
    return await _currentTimeRepository.get();
  }
  
}