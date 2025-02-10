import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  void _signOut(BuildContext context) async {
    // await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signOut(context),
          child: Text("Sign Out"),
        ),
      ),
    );
  }
}
