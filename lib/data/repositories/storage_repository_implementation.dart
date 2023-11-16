import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/repositories/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _pref_token = 'TOKEN';
const _pref_id = '_ID';
const _pref_account = 'ACCOUNT';
const _pref_email = 'EMAIL';
const _pref_display_name = 'DISPLAY_NAME';

class StorageRepositoryImplementation implements StorageRepository {
  @override
  Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(_pref_token);
    sharedPreferences.remove('permanentSession');
    sharedPreferences.remove('id_usuario');
    //sharedPreferences.clear();
  }

  @override
  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_pref_token) ?? null;
  }

  @override
  Future<UsuarioEntity> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return UsuarioEntity(
      alias: sharedPreferences.getString(_pref_account),
      idusuario: sharedPreferences.getInt(_pref_id),
      /* phonenumber: sharedPreferences.getString(_pref_phonenumber), */
      email: sharedPreferences.getString(_pref_email),
      apellidosnombres: sharedPreferences.getString(_pref_display_name),
      /* token: sharedPreferences.getString(_pref_token), */
    );
  }

  @override
  Future<void> saveUser(UsuarioEntity data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(_pref_id, data.idusuario ?? '');
    sharedPreferences.setString(_pref_account, data.alias ?? '');
    sharedPreferences.setString(_pref_email, data.email ?? '');
    /* sharedPreferences.setString(_pref_phonenumber, data.phonenumber ?? ''); */
    sharedPreferences.setString(
        _pref_display_name, data.apellidosnombres ?? '');
    /* sharedPreferences.setString(_pref_token, data.token ?? ''); */
  }

  @override
  Future<void> saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_pref_token, token);
  }
}
