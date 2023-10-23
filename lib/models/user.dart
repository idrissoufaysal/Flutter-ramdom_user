// ignore_for_file: empty_constructor_bodies


class User {
  final int? id;
  final String gender;
  final String email;
  final String phone;
 

  User({
     this.id,
    required this.gender,
    required this.email,
    required this.phone,
  });

  // Méthode pour convertir un Map en un objet User.
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] is int ? data['id'] : '',
      gender: data['gender'] is String ? data['gender'] : '',
      email: data['email'] is String ? data['email'] : '',
      phone: data['phone'] is String ? data['phone'] : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gender': gender,
      'email': email,
      'phone': phone,
      
    };
  }
}
