import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get permanentSession {
    return _prefs.getBool('permanentSession') ?? false;
  }

  set permanentSession(bool value) {
    _prefs.setBool('permanentSession', value);
  }

  get offLine {
    return _prefs.getBool('offLine') ?? false;
  }

  set offLine(bool value) {
    _prefs.setBool('offLine', value);
  }

  get modoDark {
    return _prefs?.getBool('modoDark') ?? false;
  }

  set modoDark(bool value) {
    _prefs.setBool('modoDark', value);
  }


}
