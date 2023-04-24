import 'package:firebase/constants/firebase_instances.dart';
import 'package:firebase/models/common_state.dart';
import 'package:firebase/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final authStream = StreamProvider.autoDispose(
    (ref) => FirebaseInstances.firebaseAuth.authStateChanges());

final authProvider = StateNotifierProvider<AuthProvider, CommonState>(
  (ref) => AuthProvider(
    CommonState(
      isLoad: false,
      isSuccess: false,
      isError: false,
      errMessage: '',
    ),
  ),
);

class AuthProvider extends StateNotifier<CommonState> {
  AuthProvider(super.state);

  Future<void> userSignUp(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userSignUp(
        email: email, password: password, username: username, image: image);
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    },
        (r) => {
              state = state.copyWith(
                  isLoad: false, isError: false, isSuccess: r, errMessage: '')
            });
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogin(
      email: email,
      password: password,
    );
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    },
        (r) => {
              state = state.copyWith(
                  isLoad: false, isError: true, isSuccess: r, errMessage: '')
            });
  }

  Future<void> userLogout() async {
    state = state.copyWith(
        isLoad: true, isError: false, isSuccess: false, errMessage: '');
    final response = await AuthService.userLogout();
    response.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    },
        (r) => {
              state = state.copyWith(
                  isLoad: false, isError: false, isSuccess: r, errMessage: '')
            });
  }
}
