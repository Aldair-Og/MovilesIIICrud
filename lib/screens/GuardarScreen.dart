import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Guardarscreen extends StatelessWidget {
  const Guardarscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: formulario(context));
  }
}

Widget formulario(context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController genero = TextEditingController();
  TextEditingController plataforma = TextEditingController();
  TextEditingController precio = TextEditingController();

  return Column(
    children: [
      TextField(
        controller: nombre,
        decoration: InputDecoration(label: Text("Ingresar nombre del juego")),
      ),

      TextField(
        controller: genero,
        decoration: InputDecoration(label: Text("Ingresar genero del juego")),
      ),

      TextField(
        controller: plataforma,
        decoration: InputDecoration(label: Text("Ingresar plataforma ")),
      ),

      TextField(
        controller: precio,
        decoration: InputDecoration(label: Text("Ingresar precio del juego")),
      ),

      FilledButton(
        onPressed: () => guardar(context, nombre, genero, plataforma, precio),
        child: const Text("Guardar"),
      ),
    ],
  );
}

Future<void> guardar(
  BuildContext context,
  TextEditingController nombre,
  TextEditingController genero,
  TextEditingController plataforma,
  TextEditingController precio,
) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference ref = FirebaseDatabase.instance.ref('juegos/$uid').push();

    await ref.set({
      'nombre': nombre.text,
      'genero': genero.text,
      'plataforma': plataforma.text,
      'precio': precio.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dato guardado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al guardar'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
