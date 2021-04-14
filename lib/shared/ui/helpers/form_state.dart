import 'package:equatable/equatable.dart';

import 'field_state.dart';

class FormState extends Equatable {
  final List<FieldState> fields;

  FormState(this.fields);

  ///
  /// Get the specific field value.
  ///
  /// If the [fieldName] doesn't exists, an [ArgumentError] will be thrown.
  ///
  String value(String fieldName) {
    final index = _indexOf(fieldName);
    return fields[index]?.value;
  }

  ///
  /// Get the specific field error text.
  ///
  /// If the [fieldName] doesn't exists, an [ArgumentError] will be thrown.
  ///
  String error(String fieldName) {
    final index = _indexOf(fieldName);
    return fields[index]?.error;
  }

  ///
  /// Check if at least one field is empty or contains error.
  ///
  bool get hasError {
    return fields?.any((field) => field.isEmpty || field.hasError) ?? true;
  }

  ///
  /// Change the [fieldName] data. If [value] and [error] are provided,
  /// keep [clearValue] and [clearError] as false, otherwise value and error
  /// will not be applyed.
  ///
  /// If the [fieldName] doesn't exists, an [ArgumentError] will be thrown.
  ///
  FormState copyWith(String fieldName,
      {String value,
      String error,
      bool clearValue: false,
      bool clearError: false}) {
    int index = _indexOf(fieldName);

    var newState = List<FieldState>.from(fields);

    newState[index] = fields[index]
        .copyWith(value: value, error: error)
        .copyWithNull(error: clearError, value: clearValue);

    return this._copyWith(newState);
  }

  int _indexOf(String name) {
    final index = fields.indexWhere((field) => field.name == name);

    if (index < 0) {
      throw ArgumentError("Invalid field name $name ");
    }

    return index;
  }

  FormState _copyWith(List<FieldState> state) {
    return FormState(state ?? this.fields);
  }

  @override
  List<Object> get props => [fields];
}
