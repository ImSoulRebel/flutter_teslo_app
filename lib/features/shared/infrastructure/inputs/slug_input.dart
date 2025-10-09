import 'package:formz/formz.dart';

// Define input validation errors
enum SlugInputError { empty, format }

// Extend FormzInput and provide the input type and error type.
class SlugInput extends FormzInput<String, SlugInputError> {
  // Call super.pure to represent an unmodified form input.
  const SlugInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const SlugInput.dirty(String value) : super.dirty(value);

  static final RegExp _slugRegExp = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == SlugInputError.empty) return 'El campo es requerido';
    if (displayError == SlugInputError.format) return 'El formato no es válido';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SlugInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return SlugInputError.empty;
    if (!_slugRegExp.hasMatch(value)) return SlugInputError.format;
    return null;
  }
}
