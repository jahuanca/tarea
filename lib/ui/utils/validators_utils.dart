import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';

dynamic switchResult(ResultType<dynamic, Failure> result) {
  if (result is Success) {
    return result.data;
  }
  if (result is Error) {
    toast(
        type: TypeToast.ERROR,
        message: (result.error as MessageEntity).message);
  }
}

dynamic switchFuture(Future<ResultType<dynamic, Failure>> promise) async {
  try {
    dynamic result = await promise;
    if (result is Success) {
      return result.data;
    }
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: (result.error as MessageEntity).message);
    }
  } catch (e) {
    print(e);
    toast(type: TypeToast.ERROR, message: ERROR_TRY_CATCH);
  }
}

String validatorUtilText(
    dynamic texto, String label, Map<String, dynamic> rules) {
  String error;
  if (rules == null) return error;
  for (var i = 0; i < rules.values.length; i++) {
    String key = rules.keys.elementAt(i);
    dynamic value = rules.values.elementAt(i);
    switch (key) {
      case 'required':
        if (texto is String) {
          if ([null, '', 'null'].contains(texto)) {
            return '$label es un valor necesario';
          }
        }
        if (texto is num) {
          if ([null, 0].contains(texto)) {
            return '$label es un valor necesario';
          }
        }
        break;

      case 'minLength':
        if ([null].contains(texto)) break;
        if ((texto as String).length < (value as int)) {
          return 'Dimension minima $value';
        }
        break;

      case 'maxLength':
        if ((texto as String).length > (value as int)) {
          return 'Dimension máxima $value';
        }
        break;

      default:
        break;
    }
    if (error != null) break;
  }
  return error;
}
