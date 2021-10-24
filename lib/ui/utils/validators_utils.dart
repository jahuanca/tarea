String validatorUtilText(dynamic texto, String label, Map<String, dynamic> rules){
  String error;
  if(rules==null) return error;
  for (var i = 0; i < rules.values.length; i++) {
    String key=rules.keys.elementAt(i);
    dynamic value=rules.values.elementAt(i);
    switch (key) {
      case 'required':
        if(texto is String){
          if([null, '', 'null'].contains(texto)){
            return '$label es un valor necesario';
          } 
        }
        if(texto is num){
          if([null, 0].contains(texto)){
            return '$label es un valor necesario';
          }
        }
        break;

      case 'minLength':
        if([null].contains(texto)) break;
        if((texto as String).length<(value as int)){
          return 'Dimension minima $value';
        }
        break;

      case 'maxLength':
        if((texto as String).length>(value as int)){
          return 'Dimension máxima $value';
        } 
        break;

      default:
        break;
    }
    if(error!=null) break;
  }
  return error;
}
