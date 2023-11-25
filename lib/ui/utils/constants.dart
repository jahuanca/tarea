import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:honeywell_scanner/code_format.dart';

List<CodeFormat> _getCodeFormats() {
  List<CodeFormat> codeFormats = [];
  codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
  codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);
  return codeFormats;
}

Map<String, dynamic> getPropertiesHoneyWell = {
  ...CodeFormatUtils.getAsPropertiesComplement(_getCodeFormats()),
  'DEC_CODABAR_START_STOP_TRANSMIT': BOOLEAN_TRUE_VALUE,
  'DEC_EAN13_CHECK_DIGIT_TRANSMIT': BOOLEAN_TRUE_VALUE,
};
