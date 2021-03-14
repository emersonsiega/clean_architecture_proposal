import '../validation.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int minLength;
  MinLengthValidation(this.field, this.minLength);

  @override
  String validate(String value) {
    if (value?.isNotEmpty == true) {
      if (value.length < minLength) {
        return "Invalid value. Min length is $minLength";
      }
    }

    return null;
  }
}
