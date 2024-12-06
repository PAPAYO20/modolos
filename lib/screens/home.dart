import 'package:flutter/material.dart';
import '../screens/product.dart';
import 'distribucion.dart';
import '../screens/login_page.dart'; // Asegúrate de importar la página de login

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribucion'),
        backgroundColor: const Color.fromARGB(255, 55, 3, 65),
        foregroundColor: Colors.white,
        actions: [
          // Tooltip con el mensaje 'Salir' cuando el usuario pase el cursor sobre el ícono
          Tooltip(
            message: 'Cerrar Sesión',
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Redirige a la página de login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ),

          const Divider(),
        ],
      ),
      body: Column(
        children: [
          // Contenido principal con las opciones
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Distribuciones'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListDistribucionsScreen()),
                    );
                  },
                ),

                const Divider(), // Separador entre las opciones y el contacto

                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Productos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListProductsScreen()),
                    );
                  },
                ),
                // Aquí puedes agregar más opciones si es necesario
              ],
            ),
          ),

          // Sección Footer con contacto del desarrollador
          Container(
            color: const Color.fromARGB(255, 22, 0, 26),
            padding: const EdgeInsets.all(10),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contacto del Desarrollador',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 5),
                ExpansionTile(
                  leading: Icon(Icons.contact_page), // Ícono de contacto
                  title: Text(
                    'Ver contacto',
                    style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 236, 236, 236)),
                  ),
                  children: [
                    ListTile(
                      title: Text('Nombre: david'),
                    ),
                    ListTile(
                      title: Text('Apellido: castro sanchez'),
                    ),
                    ListTile(
                      title: Text('Celular: +57 3155254613'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
