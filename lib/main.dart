import 'package:flutter/material.dart';
// import '../screens/home.dart';
import '../screens/login_page.dart';

void main(List<String> args) {
  runApp(const distribucion());
}

class distribucion extends StatelessWidget {
  const distribucion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distribucion',
      home: LoginPage(), // Cambiado de Menu() a LoginPage()
    );
  }
}