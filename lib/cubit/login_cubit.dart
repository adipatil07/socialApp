import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/services/firebase_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseService _firebaseService;

  LoginCubit(this._firebaseService) : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    try {
      emit(LoginLoading());
      var user = await _firebaseService.loginUser(email, password);
      if (user != null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure());
      }
    } catch (e) {
      emit(LoginFailure());
    }
  }
}
