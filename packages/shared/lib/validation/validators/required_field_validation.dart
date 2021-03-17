import '../validation.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    if (value?.isNotEmpty != true) {
      return 'Required field';
    }

    return null;
  }
}
