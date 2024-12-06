import 'package:flutter/material.dart';
import '../models/distribucion.dart';
import '../services/api_service_distribucion.dart';

class ListDistribucionsScreen extends StatefulWidget {
  const ListDistribucionsScreen({super.key});

  @override
  State<ListDistribucionsScreen> createState() => _ListDistribucionsScreenState();
}

class _ListDistribucionsScreenState extends State<ListDistribucionsScreen> {
  final DistribucionApiService apiService = DistribucionApiService();
  List<Distribucion> distribucions = [];
  List<Distribucion> filteredDistribucions = []; // Lista para almacenar los productos filtrados
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDistribucions();
    searchController.addListener(_filterDistribucions); // Escucha cambios en el campo de búsqueda
  }

  Future<void> _loadDistribucions() async {
    try {
      final fetchedDistribucions = await apiService.getDistribuciones();
      setState(() {
        distribucions = fetchedDistribucions;
        filteredDistribucions = fetchedDistribucions; // Inicialmente, muestra todos los productos
      });
    } catch (e) {
      print('Error cargando sucursales: $e');
    }
  }

  void _filterDistribucions() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDistribucions = distribucions
          .where((distribucion) =>
              distribucion.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _registerDistribucion(String name, int contactNumber, String address,
      String email, int personalPhone, String status) async {
    try {
      await apiService.createDistribucion(
        name: name,
        contactNumber: contactNumber,
        address: address,
        email: email,
        personalPhone: personalPhone,
        status: status,
      );
      await _loadDistribucions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Sucursal registrada con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error registrando la sucursal')),
        );
      }
    }
  }

  void _editDistribucion(String id, String name, int contactNumber, String address,
      String email, int personalPhone, String status) async {
    try {
      await apiService.updateDistribucion(
        id: id,
        name: name,
        contactNumber: contactNumber,
        address: address,
        email: email,
        personalPhone: personalPhone,
        status: status,
      );
      await _loadDistribucions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Sucursal actualizada con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error actualizando la sucurla')),
        );
      }
    }
  }

  void _deleteDistribucion(String id) async {
    try {
      await apiService.deleteDistribucion(id);
      await _loadDistribucions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Sucursal eliminada con éxito!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error eliminando la sucursales')),
        );
      }
    }
  }

  void showDistribucionFormDialog({Distribucion? distribucion}) {
    final nameController = TextEditingController(text: distribucion?.name ?? '');
    final contactNumberController = TextEditingController(
        text: distribucion?.contactNumber.toString() ?? '');
    final addressController = TextEditingController(text: distribucion?.address ?? '');
    final emailController = TextEditingController(text: distribucion?.email ?? '');
    final personalPhoneController = TextEditingController(
        text: distribucion?.personalPhone.toString() ?? '');
    final statusController = TextEditingController(text: distribucion?.status ?? 'disponible');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(distribucion == null ? 'Registrar Sucursales ' : 'Editar suscursales '),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingrese el nombre',
                    icon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  controller: contactNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Número de contacto',
                    hintText: 'Ingrese el número de contacto',
                    icon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    hintText: 'Ingrese la dirección',
                    icon: Icon(Icons.location_on),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ingrese el email',
                    icon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  controller: personalPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono personal',
                    hintText: 'Ingrese el teléfono personal',
                    icon: Icon(Icons.phone_android),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: statusController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    hintText: 'Ingrese el estado',
                    icon: Icon(Icons.info),
                  ),
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
                    contactNumberController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    personalPhoneController.text.isEmpty ||
                    statusController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, complete todos los campos')),
                  );
                  return;
                }

                try {
                  final name = nameController.text.trim();
                  final contactNumber = int.parse(contactNumberController.text.trim());
                  final address = addressController.text.trim();
                  final email = emailController.text.trim();
                  final personalPhone = int.parse(personalPhoneController.text.trim());
                  final status = statusController.text.trim();

                  if (distribucion == null) {
                    // Registrar nueva distribución
                    _registerDistribucion(name, contactNumber, address, email,
                        personalPhone, status);
                  } else {
                    // Actualizar distribución existente
                    _editDistribucion(distribucion.id, name, contactNumber, address,
                        email, personalPhone, status);
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Por favor, ingrese números válidos en los campos numéricos')),
                  );
                }
              },
              child: Text(distribucion == null ? 'Registrar' : 'Actualizar'),
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
        title: const Text('Lista de sucursales'),
        backgroundColor: const Color.fromARGB(255, 23, 0, 27),
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
            child: filteredDistribucions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredDistribucions.length,
                    itemBuilder: (context, index) {
                      final distribucion = filteredDistribucions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(distribucion.name),
                          subtitle: Text(
                              'Email: ${distribucion.email}\nTeléfono: ${distribucion.contactNumber}\nEstado: ${distribucion.status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showDistribucionFormDialog(distribucion: distribucion),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text('¿Está seguro que desea eliminar esta distribución?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _deleteDistribucion(distribucion.id);
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 248, 1, 1),
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
        backgroundColor: const Color.fromARGB(255, 22, 0, 26),
        child: const Icon(Icons.add),
        onPressed: () => showDistribucionFormDialog(),
      ),
    );
  }
}