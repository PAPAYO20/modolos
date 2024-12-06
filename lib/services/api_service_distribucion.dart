import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:compras/models/distribucion.dart';

class DistribucionApiService {
  static const String baseUrl = "https://comprasapi.onrender.com/api/distribucion";

  // Listar todas las distribuciones
 Future<List<Distribucion>> getDistribuciones() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> distribucionesData = jsonData['distribucions']; // Cambiado a 'distribucions'

    return distribucionesData.map((item) => Distribucion.fromJson(item)).toList();
  } else {
    throw Exception('Error obteniendo los datos de distribuciones');
  }
}


  // Registrar una distribución
  Future<void> createDistribucion({
    required String name,
    required int contactNumber,
    required String address,
    required String email,
    required int personalPhone,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'contact_number': contactNumber,
        'address': address,
        'email': email,
        'personal_phone': personalPhone,
        'status': status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al registrar distribución");
    }
  }

  // Actualizar una distribución
  Future<void> updateDistribucion({
    required String id,
    required String name,
    required int contactNumber,
    required String address,
    required String email,
    required int personalPhone,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'contact_number': contactNumber,
        'address': address,
        'email': email,
        'personal_phone': personalPhone,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al editar distribución: ${response.body}");
    }
  }

  // Eliminar una distribución
  Future<void> deleteDistribucion(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception("Error al eliminar distribución");
    }
  }
}
