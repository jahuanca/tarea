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
    _prefs = await SharedPreferences.getInstance();
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

  get lastVersion {
    return 'v'+(_prefs.getString('lastVersion') ?? 'X.X.X');
  }

  set lastVersion(String value) {
    _prefs.setString('lastVersion', value);
  }

  get lastVersionDate {
    return _prefs.getString('lastVersionDate') ?? '-----';
  }

  set lastVersionDate(String value) {
    _prefs.setString('lastVersionDate', value);
  }

  get offLine {
    return _prefs.getBool('offLine') ?? true;
  }

  set offLine(bool value) {
    _prefs.setBool('offLine', value);
  }

  get idSede {
    return _prefs.getInt('id_sede');
  }

  set idSede(int value) {
    _prefs.setInt('id_sede', value);
  }

  get idUsuario {
    return _prefs.getInt('id_usuario');
  }

  set idUsuario(int value) {
    _prefs.setInt('id_usuario', value);
  }

  get idSociedad {
    return _prefs.getInt('id_sociedad');
  }

  set idSociedad(int value) {
    _prefs.setInt('id_sociedad', value);
  }

  get modoDark {
    return _prefs?.getBool('modoDark') ?? false;
  }

  set modoDark(bool value) {
    _prefs.setBool('modoDark', value);
  }


}
