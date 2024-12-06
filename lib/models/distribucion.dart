class Distribucion {
  final String id;
  final String name;
  final int contactNumber;
  final String address;
  final String email;
  final int personalPhone;
  final String status;

  Distribucion({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.address,
    required this.email,
    required this.personalPhone,
    required this.status,
  });

  factory Distribucion.fromJson(Map<String, dynamic> json) {
    return Distribucion(
      id: json['_id'] as String,
      name: json['name'] as String,
      contactNumber: json['contact_number'] as int,
      address: json['address'] as String,
      email: json['email'] as String,
      personalPhone: json['personal_phone'] as int,
      status: json['status'] as String,
    );
  }
}
