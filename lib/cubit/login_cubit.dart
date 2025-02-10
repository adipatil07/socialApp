import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:social_app/services/firebase_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // final FirebaseService _firebaseService;

  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    try {
      emit(LoginLoading());
      // User? user = await _firebaseService.loginUser(email, password);
      // if (user != null) {
      //   emit(LoginSuccess());
      // } else {
      //   emit(LoginFailure());
      // }
      emit(LoginSuccess()); // Temporary success state
    } catch (e) {
      emit(LoginFailure());
    }
  }
}
