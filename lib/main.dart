import 'dart:math'; // Para la aleatoriedad
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 


void main() => runApp(CitaDiariaApp());


class CitaDiariaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frases Inspiradoras',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  
  List<String> lista_frases = [
    "El código es poesía dinámica",
    "Cada error es una nueva lección",
    "La mejor manera de predecir el futuro es crearlo.",
    "Haz lo que puedas, con lo que tienes, dondequiera que estés.",
    "Si puedes imaginarlo, puedes hacerlo." ,
    "No esperes a que todo sea perfecto. Empieza ahora y hazlo posible.",
    "hola como estas",
    "pau y mario son los mejores",
  ];

  List<String> lista_favoritos = []; // Lista para Actividad 2

  final List<Color> lista_colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.pink,
    Colors.amber,   
    
  ];

  int indice_actual = 0;
  Color color_fondo_actual = Colors.white;


  final TextEditingController controlador_texto = TextEditingController();


  void _generar_nueva_frase() {
    setState(() {
      int nuevo_indice;
      do {
        nuevo_indice = Random().nextInt(lista_frases.length);
      } while (nuevo_indice == indice_actual);

      indice_actual = nuevo_indice;

      int indice_color = Random().nextInt(lista_colores.length);
      color_fondo_actual = lista_colores[indice_color];
    });
  }

  void _agregar_a_favoritos() {
    String frase_actual = lista_frases[indice_actual];
    if (!lista_favoritos.contains(frase_actual)) {
      setState(() {
        lista_favoritos.add(frase_actual);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Guardado en favoritos!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya está en favoritos')),
      );
    }
  }


  void _mostrar_dialogo_agregar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Escribe tu inspiración"),
          content: TextField(
            controller: controlador_texto, 
            decoration: InputDecoration(hintText: "Tu frase aquí..."),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            ElevatedButton(
              child: Text("Agregar"),
              onPressed: () {
                if (controlador_texto.text.isNotEmpty) {
                  setState(() {
                    lista_frases.add(controlador_texto.text);
                    indice_actual = lista_frases.length - 1; 
                  });
                  controlador_texto.clear(); 
                  Navigator.of(context).pop(); 
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _ir_a_favoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaFavoritos(favoritos_recibidos: lista_favoritos),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fondo_actual, 
      
      appBar: AppBar(
        title: Text("Motivación Diaria"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: _ir_a_favoritos,
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  lista_frases[indice_actual],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                    fontSize: 28,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _generar_nueva_frase,
                  icon: Icon(Icons.refresh),
                  label: Text("Nueva"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: _agregar_a_favoritos,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      
      // Actividad 3: FloatingActionButton para agregar frases 
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrar_dialogo_agregar,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        tooltip: "Agregar mi frase",
      ),
    );
  }
}


class PaginaFavoritos extends StatefulWidget {
  final List<String> favoritos_recibidos;
  PaginaFavoritos({required this.favoritos_recibidos});
  @override
  _PaginaFavoritosState createState() => _PaginaFavoritosState();
}

class _PaginaFavoritosState extends State<PaginaFavoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Favoritos"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      
      
      body: widget.favoritos_recibidos.isEmpty
          ? Center(child: Text("No tienes favoritos aún"))
          : ListView.builder(
              itemCount: widget.favoritos_recibidos.length,
              itemBuilder: (context, index) {
                final frase = widget.favoritos_recibidos[index];
                return Dismissible(
                  key: Key(frase), 
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      widget.favoritos_recibidos.removeAt(index);
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Frase eliminada")),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.star, color: Colors.amber),
                      title: Text(
                        frase,
                        style: GoogleFonts.montserrat(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
