import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

//Este lo movi fuera para que la funcion de abajo pudiera detectarlo xd
final fechaN =
    TextEditingController(); //Fecha de nacimiento a modo variable vivi v:

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double logoRadius = 40; //tamaño de logo
    //VARIABLES PARA EL APARTADO DE REGISTROS
    final nombre = TextEditingController();
    final apellidoP = TextEditingController();
    final apellidoM = TextEditingController();
    final apodo = TextEditingController();
    final usuario = TextEditingController();
    final contra = TextEditingController();
    final correo = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: logoRadius,
                    backgroundColor: const Color.fromARGB(255, 165, 161, 161),
                    child: CircleAvatar(
                      radius: logoRadius - 2,
                      backgroundImage: AssetImage("assets/images/logosx.jpg"),
                    ),
                  ),

                  SizedBox(width: 12),

                  Text(
                    "StudeX",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              //Ya aqui empieza la edicion v:
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Aqui empiezan los apartados XD

                    //Este es el apartado de nombre, basicamente nos guiamos en el de correo pero le quitamos lo de la validacion XD
                    TextFormField(
                      controller: nombre,
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Nombre",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) =>
                          (valor == null ||
                              valor
                                  .isEmpty //La opcion de valor.isEmpty basicamanete checa si el apartado esta vacio
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //este es el de apellido paterno JSAKJASKJA
                    TextFormField(
                      controller: apellidoP,
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Apellido Paterno",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //Y este es el del materno Ekizde
                    TextFormField(
                      controller: apellidoM,
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Apellido Materno",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //Nombre de Usuario
                    TextFormField(
                      controller: usuario,
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Nombre de Usuario",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //Para el apodo
                    TextFormField(
                      controller: apodo,
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Apodo",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //Fecha de nacimiento xD
                    TextFormField(
                      controller: fechaN,
                      keyboardType: TextInputType.datetime,
                      decoration: _dec(
                        label: "Fecha de Nacimiento",
                        icon: Icons.today,
                      ),
                      onTap: () => _fechaN(context, fechaN),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //Para la contraseña
                    TextFormField(
                      controller:
                          contra, //controlador que guarda el texto que el usuario escribe
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Confirmar Contraseña",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    TextFormField(
                      //se usa el mismo controlador par mas versatilidad
                      controller:
                          contra, //(Esto para que se escriba lo mismo y no haya errores de escritura en las dos capturas)
                      keyboardType: TextInputType.text,
                      decoration: _dec(
                        label: "Confirmar Contraseña",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return "No se ha ingresado un valor valido";
                        }
                        if (valor != contra.text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    //Para el Correo
                    TextFormField(
                      controller: correo,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _dec(
                        label: "Correo",
                        icon: Icons.person_outline,
                      ),
                      validator: (valor) =>
                          (valor == null || !valor.contains("@")
                          ? "No se ha ingresado un valor valido"
                          : null),
                    ),

                    SizedBox(height: 16),

                    //AQUI EMPIEZA EL BOTON
                    SizedBox(
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
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (formKey.currentState?.validate() ?? false) {}
                        },
                        child: Text(
                          "Registrarme",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    //PREGUNTAS AGREGADAS EN CLASE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('¿Ya tienes una cuenta?'),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Inicia sesión',
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

  void _fechaN(BuildContext context, TextEditingController controller) async {
    //Con ShowDataPicker Mostramos el calendario y pues el await solo mantiene el formulario a la vista a que el usuario lo deja de usar xd
    final fecha = await showDatePicker(
      context:
          context, //los context solo le indican al formulario la ubicacion, osea para que la funcion sepa que estan reyenando el apartado de fecha XD (No se explicarme espero que me entienda JAJA)
      initialDate:
          DateTime.now(), //Este dice que pues el formato empieza en la fecha actual
      firstDate: DateTime(
        1900,
      ), //Este basicamente prohibe que pongan fechas con años menores a 1900 xd
      lastDate:
          DateTime.now(), //Y este no deja que pongan fechas futuras Ekizde
    );
    //El basicamente dice que si el calendario no se le selecciona una fecha o asi pues deja el campo vacio xd
    if (fecha != null) {
      fechaN.text = DateFormat('dd/MM/yyyy').format(
        fecha,
      ); //Ya esto de aqui solo indica como ira el formato de la fecha que pusimos dentro del apartado
    }
  }
}
