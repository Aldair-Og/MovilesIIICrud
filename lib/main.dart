import 'package:deber_crud/firebase_options.dart';
import 'package:deber_crud/screens/GuardarScreen.dart';
import 'package:deber_crud/screens/LeerScren.dart';
import 'package:deber_crud/screens/crud.dart';
import 'package:deber_crud/screens/login.dart';
import 'package:deber_crud/screens/registro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const  InicioSesion (),
      routes: {
        '/crud': (context) => const CrudScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/guardar': (context) => const Guardarscreen(),
        '/leer': (context) => const LeerScreen(),

      },
    );
  }
}

class InicioSesion extends StatelessWidget {
  const InicioSesion ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' InicioSesion '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Iniciar sesión'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registro');
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
