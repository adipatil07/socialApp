class UserModel {
  final String name;
  final String username;
  final String phone;
  final String email;
  final String guardianPhone;
  final String guardianEmail;
  final String? uid;
  final String password;

  UserModel({
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.guardianPhone,
    required this.guardianEmail,
    this.uid,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      guardianPhone: map['guardianPhone'] ?? '',
      guardianEmail: map['guardianEmail'] ?? '',
      uid: map['uid'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'guardianPhone': guardianPhone,
      'guardianEmail': guardianEmail,
      'password': password,
    };
  }
}
