class UserModel {
  final String name;
  final String username;
  final String phone;
  final String email;
  final String password;
  final String guardianPhone;
  final String guardianEmail;

  UserModel({
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.guardianPhone,
    required this.guardianEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'guardianPhone': guardianPhone,
      'guardianEmail': guardianEmail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      username: map['username'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      guardianPhone: map['guardianPhone'],
      guardianEmail: map['guardianEmail'],
    );
  }
}
