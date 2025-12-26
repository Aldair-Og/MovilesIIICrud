import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();

  Future<void> registrar() async {
    try {
      UserCredential credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: correoController.text.trim(),
            password: contraseniaController.text.trim(),
          );

      String uid = credencial.user!.uid;

      DatabaseReference ref = FirebaseDatabase.instance.ref('usuarios/$uid');

      await ref.set({
        'correo': correoController.text.trim(),
        'uid': uid,
        'fecha': DateTime.now().toIso8601String(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro exitoso'),
        backgroundColor: Colors.green,
      ),
    );


      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');

    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('Error al Registrar'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: contraseniaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: registrar,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
