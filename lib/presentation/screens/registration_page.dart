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

  final _formKey = GlobalKey<FormState>();
  bool _isUsernameTaken = false;
  bool _isLoading = false;

  Future<void> _checkUsername(String username) async {
    _isUsernameTaken =
        await context.read<RegistrationCubit>().isUsernameTaken(username);
    setState(() {});
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String guardianPhone = guardianPhoneController.text.trim();
    String guardianEmail = guardianEmailController.text.trim();

    UserModel userModel = UserModel(
      name: name,
      username: username,
      phone: phone,
      email: email,
      password: password,
      guardianPhone: guardianPhone,
      guardianEmail: guardianEmail,
    );

    await context.read<RegistrationCubit>().registerUser(userModel);

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false,
      String? Function(String?)? validator,
      void Function(String)? onChanged}) {
    return TextFormField(
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
      validator: validator,
      onChanged: onChanged,
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
            child: Form(
              key: _formKey,
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
                    child: BlocConsumer<RegistrationCubit, RegistrationState>(
                      listener: (context, state) {
                        if (state is RegistrationSuccess) {
                          print("RegistrationSuccess state received in UI");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Registration Successful")),
                          );
                          context.go('/home'); // Navigate to home page
                        } else if (state is RegistrationFailure) {
                          // print("RegistrationFailure state received in UI");
                          String errorMessage = state.message;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RegistrationLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(
                          children: [
                            const Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor)),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Full Name",
                              nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Username",
                              usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (_isUsernameTaken) {
                                  return 'Username is already taken';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _checkUsername(value);
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Phone",
                              phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Email",
                              emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Password",
                              passwordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Guardian Phone",
                              guardianPhoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your guardian\'s phone number';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              "Guardian Email",
                              guardianEmailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your guardian\'s email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
