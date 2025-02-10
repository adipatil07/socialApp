import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/comment_cubit.dart';
import 'package:social_app/cubit/login_cubit.dart';
import 'package:social_app/cubit/post_cubit.dart';
import 'package:social_app/cubit/registration_cubit.dart';
// import 'package:social_app/services/firebase_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final FirebaseService _firebaseService = FirebaseService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegistrationCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => CommentCubit()),
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
