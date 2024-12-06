import 'package:flutter/material.dart';
import '../services/api_service_product.dart';
import '../models/product.dart';

class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final ProductApiService apiService = ProductApiService();
  List<Product> products = [];
  List<Product> filteredProducts = []; // Lista para almacenar los productos filtrados
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController.addListener(_filterProducts); // Escucha cambios en el campo de búsqueda
  }

  Future<void> _loadProducts() async {
    try {
      final fetchedProducts = await apiService.getProducts();
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts; // Inicialmente, muestra todos los productos
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando productos: $e')),
        );
      }
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query))
          .toList();
    });
  }

  void _registerProduct(String name, double price, String category, int stock, int minimumStock) async {
    try {
      await apiService.createProduct(
        name: name,
        price: price,
        category: category,
        stock: stock,
        minimumStock: minimumStock,
      );
      await _loadProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto registrado con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registrando el producto: $e')),
        );
      }
    }
  }

  void _editProduct(String id, String name, double price, String category, int stock, int minimumStock) async {
    try {
      await apiService.updateProduct(
        id: id,
        name: name,
        price: price,
        category: category,
        stock: stock,
        minimumStock: minimumStock,
      );
      await _loadProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto actualizado con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error actualizando el producto: $e')),
        );
      }
    }
  }

  void _deleteProduct(String id) async {
    try {
      await apiService.deleteProduct(id);
      await _loadProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto eliminado con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error eliminando el producto: $e')),
        );
      }
    }
  }

  void showProductFormDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final minimumStockController = TextEditingController(text: product?.minimumStock.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Registrar Producto' : 'Editar Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingrese el nombre',
                    icon: Icon(Icons.shopping_cart),
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    hintText: 'Ingrese el precio',
                    icon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    hintText: 'Ingrese la categoría',
                    icon: Icon(Icons.category),
                  ),
                ),
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Ingrese el stock disponible',
                    icon: Icon(Icons.inventory),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: minimumStockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Mínimo',
                    hintText: 'Ingrese el stock mínimo',
                    icon: Icon(Icons.warning),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    stockController.text.isEmpty ||
                    minimumStockController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, complete todos los campos')),
                  );
                  return;
                }

                try {
                  final name = nameController.text.trim();
                  final price = double.parse(priceController.text.trim());
                  final category = categoryController.text.trim();
                  final stock = int.parse(stockController.text.trim());
                  final minimumStock = int.parse(minimumStockController.text.trim());

                  if (product == null) {
                    _registerProduct(name, price, category, stock, minimumStock);
                  } else {
                    _editProduct(product.id, name, price, category, stock, minimumStock);
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, ingrese valores válidos')),
                  );
                }
              },
              child: Text(product == null ? 'Registrar' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        backgroundColor: const Color.fromARGB(255, 22, 0, 26),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                hintText: 'Buscar por nombre o categoría',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                              'Precio: \$${product.price}\nCategoría: ${product.category}\nStock: ${product.stock}\nStock Mínimo: ${product.minimumStock}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showProductFormDialog(product: product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text('¿Está seguro que desea eliminar este producto?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _deleteProduct(product.id);
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 23, 0, 27),
        child: const Icon(Icons.add),
        onPressed: () => showProductFormDialog(),
      ),
    );
  }
}