import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  final String email;
  final String authNumber;
  final String password;
  final String confirmPassword;
  final String major1;
  final String major2;

  SignupState({
    this.email = '',
    this.authNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.major1 = '',
    this.major2 = '',
  });

  SignupState copyWith({
    String? email,
    String? authNumber,
    String? password,
    String? confirmPassword,
    String? major1,
    String? major2,
  }) {
    return SignupState(
      email: email ?? this.email,
      authNumber: authNumber ?? this.authNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      major1: major1 ?? this.major1,
      major2: major2 ?? this.major2,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateAuthNumber(String authNumber) {
    state = state.copyWith(authNumber: authNumber);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void updateMajor1(String major1) {
    state = state.copyWith(major1: major1);
  }

  void updateMajor2(String major2) {
    state = state.copyWith(major2: major2);
  }
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((ref) {
  return SignupNotifier();
});
