//LOS SERVICIOS SON PARA CONECTAR CON EL BACKEND
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApi {
  //1.Definimos el endpoint a llamar
  static const String _baseLogin =
      'https://abigailslz.com/apiStudex/routes/login.php';

  //Creamos un objeto para el almacenamiento del token y los datos del usuario, este almacenamiento es en el telefono.
  static const _secure = FlutterSecureStorage();

  //Creamos la funcion para conectanos al endpoint
  static Future<bool> login({
    required String login,
    required String password,
  }) async {
    //Hacemos la peticion mediante el protocolo http,
    //Enviamos cabeceras (Headers), el metodo es post
    //Await: se espera a que termine para continuar ejecutando el codigo
    final resultado = await http.post(
      Uri.parse(_baseLogin),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'login': login, 'password': password}),
    );

    if (resultado.statusCode < 200 || resultado.statusCode > 300) {
      return false;
    }

    //Obtenemos los datos del token y del usuario de la respuesta a la peticion
    //Y los guardamos en el almacenamiento del telefono (los datos son encriptados)
    final Map<String, dynamic> datos = jsonDecode(resultado.body);
    //Valido que la respuesta del login sea true
    if (datos["ok"] == true && datos["token"] != null) {
      await _secure.write(key: 'studex_token', value: datos["token"]);
      await _secure.write(key: 'studex_user', value: jsonEncode(datos['user']));
      return true;
    }

    return false;
  }
}
