import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studex/services/login_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double logoRadius = 66; //tamaño de logo

    //variable que se asigna una sola vez a un valor
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    //Definen un tipo formkey es tipo formstate
    //formstate: es para validar y resetar un formulario
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          //Permite ser scroll si el contenido no cabe, ejemplo cuando se abre el teclado
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logotipo
                CircleAvatar(
                  radius: logoRadius,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: logoRadius - 4,
                    backgroundImage: AssetImage("assets/images/logosx.jpg"),
                  ),
                ),

                SizedBox(height: 16),

                //Nombre
                Text(
                  "StudeX",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        //_dec: es una funcion que realizaremos para especificar todo el estilo de nuestros campos de texto.
                        decoration: _dec(
                          label: "Correo",
                          icon: Icons.person_outline,
                        ),
                        //valor ternario
                        //condicion ? valorsicumple : valorsinocumple
                        // "?" signifca "entonces" mi campo de texto recibe un valor,
                        //si ese valor es null o no contiene un @ entonces va a mostrar correo invalido,
                        //si el campo tiene un valor no muestra nada
                        validator: (valor) =>
                            (valor == null || !valor.contains("@")
                            ? "correo invalido"
                            : null),
                      ),
                      SizedBox(height: 14),

                      //Campo contraseña
                      //es un widget creado para nosotros, para el campo de contraseña
                      //_el guion significa que es privado y no se podra utilizar fuera de este archivo login
                      _PasswordField(
                        controller: passCtrl,
                        decoration: _dec(
                          label: "Contraseña",
                          icon: Icons.lock_outline,
                        ),
                      ),

                      SizedBox(height: 22),

                      //boton de ingresar
                      SizedBox(
                        //double.infinity significa que va a abarcar todo el ancho disponible
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          //metodo que se ejecuta al presionar el boton
                          onPressed: () async {
                            // focusscape quita el enfoque del campo que esta activo (Cierra el teclado)
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            try {
                              final login = await AuthApi.login(
                                login: emailCtrl.text.trim(),
                                password: passCtrl.text.trim(),
                              );

                              //Mostramos en consola que el login ya se realizo
                              debugPrint('Login realizo $login');

                              //Validamos que la interfaz este "montada"
                              if (!context.mounted) return;

                              //Si se obtuvo informacion (el login fue exitoso)
                              //redireccionamos a la pantalla de perfil
                              if (login) {
                                context.go('perfil');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Usuario o contraseña invalidos',
                                    ),
                                  ),
                                );

                                //Descongelamos cualquier elemento que tengamos en pantalla
                                WidgetsBinding.instance
                                    .addPersistentFrameCallback((_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(FocusNode());
                                    });
                              }
                            } catch (e, st) {
                              debugPrint('Excepcion en login');
                            }
                          },
                          child: Text(
                            "Ingresar",
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No tienes una cuenta??"),
                          TextButton(
                            onPressed: () => context.push("/register"),
                            child: Text(
                              "registrate",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _dec({required String label, required IconData icon}) {
    // return -> palabra reservada: retorna el valor de la función.
    return InputDecoration(
      // labelText -> texto de etiqueta (aparece como "placeholder").
      labelText: label,
      // prefixIcon -> ícono que aparece al inicio del campo de texto.
      prefixIcon: Icon(icon),
      // filled/fillColor -> pinta el fondo del campo.
      filled: true,
      fillColor: Colors.white,
      // contentPadding -> espacio interno del contenido (texto) respecto a los bordes.
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      // border/enabledBorder/focusedBorder -> definen apariencia del borde en distintos estados.
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        // BorderSide -> describe color/grosor de línea.
        borderSide: const BorderSide(color: Color(0xFFCDD1D5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
    );
  }
}

//widget perosnalizado de contraseña

class _PasswordField extends StatefulWidget {
  // const -> (constructor constante si todos los campos son const/inalterables).
  // {required ...} -> PARÁMETROS NOMBRADOS y OBLIGATORIOS (required).
  const _PasswordField({required this.controller, required this.decoration});

  // final -> palabra reservada: solo asignable una vez (inmutable después de construir el widget).
  final TextEditingController controller; // controla el texto del campo
  final InputDecoration decoration; // decoración base reutilizable

  @override
  // createState -> método de StatefulWidget que debe devolver una instancia de State asociada.
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  // bool -> tipo lógico de Dart (true/false).
  // _obscure -> nombre de variable PRIVADA (por _). Controla si el campo oculta el texto.
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget
          .controller, // "widget" -> referencia a los parámetros del StatefulWidget padre.
      // obscureText -> si true, oculta el texto (••••).
      obscureText: _obscure,
      // decoration -> usamos la decoración que llegó, pero modificamos solo "suffixIcon".
      // copyWith(...) -> Crea una COPIA del objeto con algunos cambios.
      //                  Mantiene lo demás igual.
      decoration: widget.decoration.copyWith(
        // suffixIcon -> ícono al final del campo (ojo para mostrar/ocultar).
        suffixIcon: IconButton(
          // onPressed -> al tocar el ícono, alternamos _obscure y redibujamos con setState.
          onPressed: () => setState(() => _obscure = !_obscure),
          // Icon(...) -> widget de ícono; elige visibilidad según estado.
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      // validator -> si está vacío, muestra error.
      validator: (v) =>
          (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
    );
  }
}
