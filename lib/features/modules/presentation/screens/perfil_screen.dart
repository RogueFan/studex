import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:studex/features/shared/menu_nav.dart';
import 'package:studex/services/perfil_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  //Definimos el tab(Opcion del menú)
  int _tabActual = 0;

  //Definimos el controlador/Objeto para el modelo 3D
  final Flutter3DController _avatarCtrl = Flutter3DController();

  //definimos la ruta donde se encuentra el avatar
  final String avatarGlb = 'assets/avatar/avatarVivi.glb';

  //Definimos un timer (tIEMPO)de animación
  Timer? _finalTimer;

  //DEFINIMOS VARIABLES PARA EL MANEJO DE LOS DATOS DEL USUARIO
  Map<String, dynamic>? _user;
  bool _loading = true;
  String? _error;

  @override
  //Creamos el método initState para manejar el estado de la  pantalla
  //y cargar el modelo en 3D
  void initState() {
    super.initState();

    //llamamos al metodo para cargar los datos del perfil
    _loadPerfil();

    //Configuramos que el avatar se ejecute en automatico junto con la animacion
    try {
      _avatarCtrl.onModelLoaded.addListener(() {
        //Cuando escuchemos que el modelo se carga validamos recibirlo y si tiene animacion la aejecutamos
        if (_avatarCtrl.onModelLoaded.value == true) {
          //ejecutamos el modelo para play
          _playAnimacion();
        }
      });
    } catch (_) {
      //SI no existe el modelo no muetsra nada
    }
    //Ponemos un tiempo para ejecutar el play de la animación
    _finalTimer = Timer(const Duration(milliseconds: 700), _playAnimacion);
  }

  //TODO: CARGAR INFORMACION DE PERFIL DE USUARIO
  Future<void> _loadPerfil() async {
    try {
      //1 Llamamos al servicio para ejecutar el metodo de cargar perfil
      final datos = await PerfilService.getPerfil();
      //2 Validamos que esta la pantalla montada
      if (!mounted) return;
      //3 Actualizamos la interfaz con los  nuevos valores
      setState(() {
        _user = datos;
        _loading = false;
        if (datos == null) {
          _error = "No se pudo obtener el perfil";
        }
      });
    } catch (error) {
      //Validamos que este "montada" la pantalla
      if (!mounted) return;
      //si esta la pantalla actualizamos el estado de la app  y mostramos el error
      setState(() {
        _error = 'Error: $error';
        _loading = false;
      });
    }
  }

  //creamos el método para ejecutar la animación
  void _playAnimacion() {
    try {
      _avatarCtrl.playAnimation();
      _avatarCtrl.startRotation(rotationSpeed: 12);
      _avatarCtrl.setCameraOrbit(0, 70, 160);
    } catch (error) {
      debugPrint('Error al ejecutar animación $error');
    }
  }

  //metodo para detener el timer
  @override
  void detener() {
    _finalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: OBTENER LA INFORMACION DEL USUARIO

    //1. manejar la pantalla de carga
    if (_loading) {
      //Si la pantalla esta cargando
      return Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    //2 Manejamos los errores
    //Si hubo un error, meuestra un mensaje
    if (_error != null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      );
    }

    // =======================================cargar datos del usuario =======================================
    // ?? signfica que se tomara como un mapa json vacio para que no tumbe la app
    final u =
        _user ?? {}; //Si _user viene vacio ENTONCES tomalo como un json vacio

    //Declaramos todos los campos recibidos y los validamos
    final nombre = (u["nombre"] ?? '') as String;
    final apellidoPaterno = (u["apellido_paterno"] ?? '') as String;
    final apellidoMaterno = (u["apellido_materno"] ?? '') as String;
    final apodo = (u["apodo"] ?? '') as String;
    final nombreGrupo = (u["nombre_grupo"] ?? '') as String;
    final nombreGrupoAbr = (u["grupo_abreviatura"] ?? '') as String;
    final nombreCarrera = (u["nombre_carrera"] ?? '') as String;
    final fechaNacimiento = (u["fecha_nacimiento"] ?? '').toString();
    //final cuatrimestre = ((u["cuatrimestre"] ?? 1) as num).toInt();
    final cuatrimestre = int.tryParse(u["cuatrimestre"]?.toString() ?? '') ?? 1;

    //Validamos el cuatrimestre para ser usado en la barra de progreso
    final progreso = cuatrimestre / 10.0;
    //Validamos que el cuatrimestre se ponga en pantalla como 01,02,03....
    final cuatrimestreLabel = cuatrimestre.toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //CABECERA "SliverToBoxAdapter" sirve para dividir la cabecera en un recuardo y recibe un hijo (child:)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    //ENCABEZADO PERFIL

                    //Este es un Contenedor al que le estamos aplicando padding
                    Container(
                      padding: const EdgeInsets.symmetric(
                        //Y el "EdgeInsets.symmetric" sirve para que el contenedor se separe de los bordes
                        horizontal: 18,
                        vertical: 19,
                      ),

                      //ESTE ES PARA EL TEXTO
                      child: Text(
                        'PERFIL',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //NOMBRE Y MODELO 3D
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, //Para que este centrado al inicio
                  children: [
                    Text(
                      '$nombre $apellidoPaterno $apellidoMaterno',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //Espacio
                    SizedBox(height: 8),

                    //Avatar
                    SizedBox(
                      height: 260,
                      child: Flutter3DViewer(
                        src: avatarGlb,
                        controller: _avatarCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Cuatrimestre
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cuatrimestreLabel,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                        //Espacio
                        SizedBox(height: 2),
                        Text(
                          'cuatrimestre',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                    //Espacio horizontal
                    SizedBox(width: 18),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progreso,
                          minHeight: 8,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation(Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Datos personales
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 22, 24, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      children: [
                        Text(
                          "Datos",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Personales",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Datos del perfil
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    _Informacionfila(
                      label: 'Nombre',
                      value: '$nombre $apellidoPaterno $apellidoMaterno',
                    ),
                    _Informacionfila(label: 'Carrera', value: nombreCarrera),
                    _Informacionfila(label: 'Grupo', value: nombreGrupoAbr),
                    _Informacionfila(
                      label: 'Cumpleaños',
                      value: fechaNacimiento,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //MENU
      //oNDESTINATIONSELECTED
      //Se ejecuta cuando el usuario toca una pestaña i = es el numero del boton (0,1,2...)
      //SetState = Actualiza el estado de la aplicacion marca la nueva pestaña como seleccionada
      bottomNavigationBar: MenuNav(
        tabActual: _tabActual,
        onTap: (i) {
          setState(() => _tabActual = i);
          //Validamos cada ocpion del menu
          if (i == 0) return; //Ya estamos en la opcion del perfil
          if (i == 1) context.go('/grupo');
        },
      ),
    );
  }
}

//Widget personalizado para pintar informacion del perfil
class _Informacionfila extends StatelessWidget {
  //dECLARAMOS LOS PARAMETROS OBLIGATORIOS A RECIBIR
  const _Informacionfila({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
