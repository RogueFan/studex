import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PerfilService {
  //EndpOINT PARA OBTENER INFORMACION DE PERFIL
  static const String _perfil =
      'https://www.abigailslz.com/apiStudex/api/profile';

  //Creamos el objeto _secure que es el almacenamiento
  // del telefono para obtener el token guardado del loign
  static const _secure = FlutterSecureStorage();

  //Creamos la funcion para hacer la peticion al endpoint
  static Future<Map<String, dynamic>?> getPerfil() async {
    // 1 OBTENEMOS EL TOKEN GUARDADO
    final token = await _secure.read(key: 'studex_token');
    if (token == null) return null;

    //2 Relaizamos la peticion´
    final resultado = await http.get(
      Uri.parse(_perfil),
      headers: {"Authorization": 'Bearer $token'},
    );

    //3 Validamos la respuesta
    if (resultado.statusCode < 200 || resultado.statusCode >= 300) return null;

    //4 Obtenemos la informacion del body
    final Map<String, dynamic> json = jsonDecode(resultado.body);

    //5 Validamos el JSon
    if (json["ok"] == true && json["user"] != null) {
      return json["user"];
    }

    return null;
  }
}
