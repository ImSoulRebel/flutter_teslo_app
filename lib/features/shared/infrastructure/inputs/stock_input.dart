import 'package:formz/formz.dart';

// Define input validation errors
enum StockInputError { empty, format, value }

// Extend FormzInput and provide the input type and error type.
class StockInput extends FormzInput<int, StockInputError> {
  // Call super.pure to represent an unmodified form input.
  const StockInput.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const StockInput.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    switch (displayError) {
      case StockInputError.empty:
        return 'El campo es requerido';
      case StockInputError.format:
        return 'No tiene formato válido';
      case StockInputError.value:
        return 'El valor no puede ser negativo';
      default:
        return null;
    }
  }

  // Override validator to handle validating a given input value.
  @override
  StockInputError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return StockInputError.empty;
    }
    RegExp r = RegExp(r'^[0-9]+$');
    if (!r.hasMatch(value.toString())) return StockInputError.format;
    if (value < 0) return StockInputError.value;
    return null;
  }
}
