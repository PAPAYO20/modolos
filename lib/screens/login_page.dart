import 'package:flutter/material.dart';
import 'home.dart'; // Asegúrate de tener este archivo para el Menú Principal

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Llave para manejar la validación del formulario
  bool _showRecoveryForm = false; // Estado para alternar entre el formulario de recuperación y login
  bool _showRegisterForm = false; // Estado para alternar entre el formulario de registro y login

  // Controladores de texto para capturar los datos de usuario y contraseña
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: _showRecoveryForm
                ? _buildRecoveryForm()
                : _showRegisterForm
                    ? _buildRegisterForm()
                    : _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  // Construcción del formulario de inicio de sesión
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de usuario
          Icon(
            Icons.account_circle,
            size: 100,
            color: const Color.fromARGB(255, 22, 3, 26), // Color actualizado
          ),
          const SizedBox(height: 20),
          // Campo para ingresar usuario o email
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Usuario o Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su usuario o email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Campo para ingresar contraseña
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true, // Oculta el texto para contraseñas
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          // Opciones de registro y recuperación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showRegisterForm = true; // Muestra el formulario de registro
                  });
                },
                child: const Text('Registrarse'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showRecoveryForm = true; // Muestra el formulario de recuperación
                  });
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Botón para iniciar sesión
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Verifica si el usuario y contraseña son correctos
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();

                if ((username == '1000896840' || username == 'davidalexander@gamil.com') &&
                    password == 'castro') {
                  // Si las credenciales son válidas, navega al menú principal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()), // Asegúrate de que Menu esté bien definido
                  );
                } else {
                  // Muestra un mensaje de error si las credenciales no son válidas
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciales incorrectas')),
                  );
                }
              }
            },
            child: const Text('Ingresar'),
          ),
        ],
      ),
    );
  }

  // Construcción del formulario de registro
  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.app_registration,
            size: 100,
            color: const Color.fromARGB(255, 22, 1, 26), // Color actualizado
          ),
          const SizedBox(height: 20),
          // Campo para ingresar usuario
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Usuario',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un usuario';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Campo para ingresar correo electrónico
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              if (!value.contains('@')) {
                return 'Por favor ingrese un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Campo para ingresar contraseña
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Campo para confirmar contraseña
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirmar Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirme su contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Lógica de registro
                print('Registrando usuario...');
              }
            },
            child: const Text('Registrarse'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _showRegisterForm = false; // Vuelve al formulario de inicio de sesión
              });
            },
            child: const Text('Volver al inicio de sesión'),
          ),
        ],
      ),
    );
  }

  // Construcción del formulario de recuperación
  Widget _buildRecoveryForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.password_rounded,
            size: 100,
            color: const Color.fromARGB(255, 22, 0, 26), // Color actualizado
          ),
          const SizedBox(height: 20),
          // Campo para ingresar correo electrónico
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              if (!value.contains('@')) {
                return 'Por favor ingrese un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una contraseña';
              }
              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Lógica de recuperación de contraseña
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recuperación de contraseña solicitada')),
                );
              }
            },
            child: const Text('Recuperar Contraseña'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _showRecoveryForm = false; // Volver al inicio de sesión
              });
            },
            child: const Text('Volver al inicio de sesión'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}