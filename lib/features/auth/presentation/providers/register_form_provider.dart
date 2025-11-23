import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

import 'auth_provider.dart';

//! 1 - State del provider
class RegisterFormState {
  final FullNameInput fullName;
  final EmailInput email;
  final PasswordInput password;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  RegisterFormState({
    this.fullName = const FullNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.isFormPosted = false,
    this.isValid = false,
    this.isPosting = false,
  });

  RegisterFormState copyWith({
    FullNameInput? fullName,
    EmailInput? email,
    PasswordInput? password,
    bool? isFormPosted,
    bool? isValid,
    bool? isPosting,
  }) {
    return RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isPosting: isPosting ?? this.isPosting,
    );
  }

  @override
  String toString() => '''
    RegisterFormState:
    fullName: $fullName
    email: $email
    password: $password
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    ''';
}

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends Notifier<RegisterFormState> {
  late Future<void> Function(String, String, String) registerCallback;

  @override
  RegisterFormState build() {
    registerCallback = ref.watch(authProvider.notifier).register;
    return RegisterFormState();
  }

  void fullNameChanged(String value) {
    final fullName = FullNameInput.dirty(value);
    state = state.copyWith(
      fullName: fullName,
      isValid: Formz.validate([fullName, state.email, state.password]),
    );
  }

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    state = state.copyWith(
      email: email,
      isValid: Formz.validate([state.fullName, email, state.password]),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    state = state.copyWith(
      password: password,
      isValid: Formz.validate([state.fullName, state.email, password]),
    );
  }

  Future<void> formSubmitted() async {
    final fullName = FullNameInput.dirty(state.fullName.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    state = state.copyWith(
      fullName: fullName,
      email: email,
      password: password,
      isValid: Formz.validate([fullName, email, password]),
      isFormPosted: true,
    );

    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);

    debugPrint('''
    Formulario de registro enviado correctamente:
      Full Name: ${state.fullName.value}
      Email: ${state.email.value}
      Password: ${state.password.value}
      state: ${state.toString()}
    ''');

    await registerCallback(
      state.fullName.value,
      state.password.value,
      state.email.value,
    );

    state = state.copyWith(isPosting: false);
  }

  void formPosted() {
    state = state.copyWith(isFormPosted: true, isPosting: true);
  }

  void formPostFinished() {
    state = state.copyWith(isPosting: false);
  }

  void reset() {
    state = RegisterFormState();
  }
}

//! 3 - StateNotifierProvider para exponer el provider
final registerFormProvider =
    NotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        () => RegisterFormNotifier());
