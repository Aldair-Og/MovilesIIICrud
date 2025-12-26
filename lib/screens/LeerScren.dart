import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeerScreen extends StatelessWidget {
  const LeerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leer")),
      body: lista(),
    );
  }
}

//Leer lista desde FIREBASE
Future<List> leerLista() async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference ref = FirebaseDatabase.instance.ref('juegos/$uid');

  final snapshot = await ref.get();
  final data = snapshot.value;

  List peliculas = [];

  if (data != null) {
    Map mapData = data as Map;
    mapData.forEach((clave, valor) {
      peliculas.add({
        'id': clave,
        'nombre': valor['nombre'],
        'genero': valor['genero'],
        'plataforma': valor['plataforma'],
        'precio': valor['precio'],
      });
    });
  }

  return peliculas;
}

//VER LISTA
Widget lista() {
  return FutureBuilder(
    future: leerLista(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nombre'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Plataforma: ${item['plataforma']}'),
                    Text('Precio: ${item['precio']}'),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            mostrarDialogoActualizar(
                              context,
                              item['id'],
                              item['nombre'],
                              item['plataforma'],
                              item['precio'],
                            );
                          },
                          child: const Text('Actualizar'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            borrarJuego(context, item['id']);
                          },
                          child: const Text('Borrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return const Center(child: Text("NO HAY DATA"));
      }
    },
  );
}

Future<void> actualizarJuego(
  String id,
  String nombre,
  String plataforma,
  String precio,
) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference ref = FirebaseDatabase.instance.ref('juegos/$uid/$id');

  await ref.update({
    'nombre': nombre,
    'plataforma': plataforma,
    'precio': precio,
  });
}

Future<void> borrarJuego(BuildContext context, String id) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference ref = FirebaseDatabase.instance.ref('juegos/$uid/$id');

    await ref.remove();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dato borrado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al borrar'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void mostrarDialogoActualizar(
  BuildContext context,
  String id,
  String nombre,
  String plataforma,
  String precio,
) {
  final nombreCtrl = TextEditingController(text: nombre);
  final plataformaCtrl = TextEditingController(text: plataforma);
  final precioCtrl = TextEditingController(text: precio);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Actualizar juego'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: plataformaCtrl,
            decoration: const InputDecoration(labelText: 'Plataforma'),
          ),
          TextField(
            controller: precioCtrl,
            decoration: const InputDecoration(labelText: 'Precio'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            await actualizarJuego(
              id,
              nombreCtrl.text,
              plataformaCtrl.text,
              precioCtrl.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
