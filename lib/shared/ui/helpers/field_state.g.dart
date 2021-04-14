// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension FieldStateCopyWith on FieldState {
  FieldState copyWith({
    String error,
    String value,
  }) {
    return FieldState(
      error: error ?? this.error,
      name: name,
      value: value ?? this.value,
    );
  }

  FieldState copyWithNull({
    bool error = false,
    bool value = false,
  }) {
    return FieldState(
      error: error == true ? null : this.error,
      name: name,
      value: value == true ? null : this.value,
    );
  }
}
