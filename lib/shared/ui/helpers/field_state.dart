import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:meta/meta.dart';

import './base_state.dart';

part 'field_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class FieldState extends BaseState {
  @CopyWithField(immutable: true)
  final String name;
  final String value;
  final String error;

  FieldState({
    @required this.name,
    this.value,
    this.error,
  });

  bool get isEmpty => value == null || value.isEmpty;

  bool get hasError => error != null && error.isNotEmpty;

  @override
  List<Object> get props => [value, error];
}
