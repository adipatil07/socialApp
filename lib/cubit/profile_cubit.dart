import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/firebase_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseService firebaseService;

  ProfileCubit(this.firebaseService) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      String? userId = firebaseService.currentUserId;
      print("Current user ID in ProfileCubit: $userId");
      if (userId != null) {
        UserModel? user = await firebaseService.getUserProfile(userId);
        if (user != null) {
          emit(ProfileLoaded(user));
        } else {
          emit(ProfileError('User not found'));
        }
      } else {
        emit(ProfileError('No user ID found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }
}
