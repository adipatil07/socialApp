import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/cubit/profile_cubit.dart';
import 'package:social_app/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/comment_cubit.dart';
import 'package:social_app/cubit/login_cubit.dart';
import 'package:social_app/cubit/post_cubit.dart';
import 'package:social_app/cubit/registration_cubit.dart';
import 'package:social_app/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseService firebaseService = FirebaseService();
  runApp(MyApp(firebaseService: firebaseService));
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService;

  MyApp({required this.firebaseService, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationCubit(firebaseService)),
        BlocProvider(create: (context) => LoginCubit(firebaseService)),
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => CommentCubit()),
        BlocProvider(create: (context) => ProfileCubit(firebaseService)),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.quicksand(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: GoogleFonts.quicksand(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: GoogleFonts.quicksand(
              fontSize: 12.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
