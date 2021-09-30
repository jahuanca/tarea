import 'dart:convert';
import 'dart:developer';
import 'package:flutter_tareo/domain/entities/current_time_entity.dart';
import 'package:flutter_tareo/domain/repositories/current_time_repository.dart';
import 'package:http/http.dart' as http;

class CurrentTimeRepositoryImplementation extends CurrentTimeRepository {
  final urlModule = 'http://worldtimeapi.org/api/timezone/America/Lima';

  @override
  Future<CurrentTimeEntity> get() async{

    final res = await http.get(
      urlModule,
    );
    if(res.statusCode==200){
      print('CurrentTime succes, response with:');
      log(res.body.toString());
    }

    return CurrentTimeEntity.fromJson(jsonDecode(res.body));
  }
}
 