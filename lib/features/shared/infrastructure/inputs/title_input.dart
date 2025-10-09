import 'package:formz/formz.dart';

// Define input validation errors
enum TitleInputError { empty }

// Extend FormzInput and provide the input type and error type.
class TitleInput extends FormzInput<String, TitleInputError> {
  // Call super.pure to represent an unmodified form input.
  const TitleInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const TitleInput.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == TitleInputError.empty) return 'El campo es requerido';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TitleInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TitleInputError.empty;

    return null;
  }
}
