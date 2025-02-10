import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/cubit/registration_cubit.dart';
import 'package:social_app/core/utils/app_colors.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();
  final TextEditingController guardianEmailController = TextEditingController();

  void _register() {
    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String guardianPhone = guardianPhoneController.text.trim();
    String guardianEmail = guardianEmailController.text.trim();

    if (name.isEmpty ||
        username.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        guardianPhone.isEmpty ||
        guardianEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    UserModel userModel = UserModel(
      name: name,
      username: username,
      phone: phone,
      email: email,
      password: password,
      guardianPhone: guardianPhone,
      guardianEmail: guardianEmail,
    );

    context.read<RegistrationCubit>().registerUser(userModel);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/images/reg.jpg",
                    height: 200), // User provided image
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor)),
                      const SizedBox(height: 16.0),
                      _buildTextField("Full Name", nameController),
                      const SizedBox(height: 16.0),
                      _buildTextField("Username", usernameController),
                      const SizedBox(height: 16.0),
                      _buildTextField("Phone", phoneController),
                      const SizedBox(height: 16.0),
                      _buildTextField("Email", emailController),
                      const SizedBox(height: 16.0),
                      _buildTextField("Password", passwordController,
                          isPassword: true),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          "Guardian Phone", guardianPhoneController),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          "Guardian Email", guardianEmailController),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => context.go('/login'),
                            child: const Text("Log in",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
