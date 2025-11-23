import 'package:formz/formz.dart';

// Define input validation errors
enum FullNameInputError { empty, tooShort }

// Extend FormzInput and provide the input type and error type.
class FullNameInput extends FormzInput<String, FullNameInputError> {
  // Call super.pure to represent an unmodified form input.
  const FullNameInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const FullNameInput.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case FullNameInputError.empty:
        return 'El campo es requerido';
      case FullNameInputError.tooShort:
        return 'El nombre debe tener al menos 3 caracteres';
      default:
        return null;
    }
  }

  // Override validator to handle validating a given input value.
  @override
  FullNameInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return FullNameInputError.empty;
    if (value.trim().length < 3) return FullNameInputError.tooShort;

    return null;
  }
}
