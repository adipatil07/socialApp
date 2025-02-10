import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/models/user_model.dart';
// import 'package:social_app/services/firebase_service.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  // final FirebaseService _firebaseService;

  RegistrationCubit() : super(RegistrationInitial());

  Future<void> registerUser(UserModel userModel) async {
    try {
      emit(RegistrationLoading());
      // User? user = await _firebaseService.registerUser(userModel);
      // if (user != null) {
      //   emit(RegistrationSuccess());
      // } else {
      //   emit(RegistrationFailure());
      // }
      emit(RegistrationSuccess()); // Temporary success state
    } catch (e) {
      emit(RegistrationFailure());
    }
  }
}
