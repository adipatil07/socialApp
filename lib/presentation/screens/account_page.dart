// import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// class AccountPage extends StatefulWidget {
//   const AccountPage({super.key});

//   @override
//   _AccountPageState createState() => _AccountPageState();
// }

// class _AccountPageState extends State<AccountPage> {
//   bool _isSigningOut = false;

//   void _signOut(BuildContext context) async {
//     setState(() {
//       _isSigningOut = true;
//     });

//     // await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacementNamed('/login');

//     setState(() {
//       _isSigningOut = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Account"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _isSigningOut ? null : () => _signOut(context),
//           child: _isSigningOut
//               ? CircularProgressIndicator(color: Colors.white)
//               : Text("Sign Out"),
//         ),
//       ),
//     );
//   }
// }
