import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/firebase_service.dart';
// import 'package:social_app/services/firebase_service.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirebaseService _firebaseService;

  RegistrationCubit(this._firebaseService) : super(RegistrationInitial());

  Future<void> registerUser(UserModel userModel) async {
    emit(RegistrationLoading());
    print("RegistrationLoading state emitted");

    try {
      User? user = await _firebaseService.registerUser(userModel);
      if (user != null) {
        emit(RegistrationSuccess());
        print("RegistrationSuccess state emitted");
      } else {
        emit(RegistrationFailure("User creation failed. Please try again."));
        print("RegistrationFailure state emitted: User is null");
      }
    } catch (e) {
      emit(RegistrationFailure("Error: ${e.toString()}"));
      print("RegistrationFailure state emitted: $e");
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    return await _firebaseService.isUsernameTaken(username);
  }
}
