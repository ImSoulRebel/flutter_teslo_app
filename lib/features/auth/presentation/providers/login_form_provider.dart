import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

//! 1 - State del provider
class LoginFormState {
  final EmailInput email;
  final PasswordInput password;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  LoginFormState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.isFormPosted = false,
    this.isValid = false,
    this.isPosting = false,
  });

  LoginFormState copyWith({
    EmailInput? email,
    PasswordInput? password,
    bool? isFormPosted,
    bool? isValid,
    bool? isPosting,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isPosting: isPosting ?? this.isPosting,
    );
  }

  @override
  String toString() => '''
    LoginFormState:
    email: $email
    password: $password
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    ''';
}

//! 2 - Como implementamos un notifier
class LoginFormNotifier extends Notifier<LoginFormState> {
  late Future<void> Function(String, String) loginCallback;
  @override
  LoginFormState build() {
    loginCallback = ref.watch(authProvider.notifier).login;
    return LoginFormState();
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    state = state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    );
  }

  Future<void> formSubmitted() async {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    state = state.copyWith(
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
      isFormPosted: true,
    );

    if (!state.isValid) return;

    debugPrint('''
    Formulario enviado correctamente:
      Email: ${state.email.value}
      Password: ${state.password.value}
      state: ${state.toString()}
    ''');

    await loginCallback(state.email.value, state.password.value);
  }

  void formPosted() {
    state = state.copyWith(isFormPosted: true, isPosting: true);
  }

  void formPostFinished() {
    state = state.copyWith(isPosting: false);
  }

  void reset() {
    state = LoginFormState();
  }
}

//! 3 - StateNotifierProvider para exponer el provider
final loginFormProvider =
    NotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
        () => LoginFormNotifier());
