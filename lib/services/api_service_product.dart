import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:compras/models/product.dart';

class ProductApiService {
  static const String baseUrl = "https://comprasapi.onrender.com/api/product";

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> productsData = jsonData['products'];
        return productsData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Error obteniendo los datos de productos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo los datos de productos: $e');
    }
  }

  Future<void> createProduct({
    required String name,
    required String category,
    required double price,
    required int stock,
    required int minimumStock,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          'category': category,
          'price': price,
          'stock': stock,
          'minimumStock': minimumStock,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception("Error al registrar producto: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al registrar producto: $e");
    }
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String category,
    required double price,
    required int stock,
    required int minimumStock,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': name,
          'category': category,
          'price': price,
          'stock': stock,
          'minimumStock': minimumStock,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Error al editar producto: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al actualizar producto: $e");
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception("Error al eliminar producto: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al eliminar producto: $e");
    }
  }
}