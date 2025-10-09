import 'package:formz/formz.dart';

// Define input validation errors
enum PriceInputError { empty, format, value }

// Extend FormzInput and provide the input type and error type.
class PriceInput extends FormzInput<double, PriceInputError> {
  // Call super.pure to represent an unmodified form input.
  const PriceInput.pure() : super.pure(0.0);

  // Call super.dirty to represent a modified form input.
  const PriceInput.dirty(double value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    switch (displayError) {
      case PriceInputError.empty:
        return 'El campo es requerido';
      case PriceInputError.format:
        return 'No tiene formato válido';
      case PriceInputError.value:
        return 'El valor no puede ser negativo';
      default:
        return null;
    }
  }

  // Override validator to handle validating a given input value.
  @override
  PriceInputError? validator(double value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return PriceInputError.empty;
    }
    RegExp r = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!r.hasMatch(value.toString())) return PriceInputError.format;
    if (value < 0) return PriceInputError.value;

    return null;
  }
}
