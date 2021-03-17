import '../../shared.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;

  ValidationBuilder._();

  String fieldName;
  List<FieldValidation> validations = [];

  static ValidationBuilder forField(String fieldName) {
    _instance = ValidationBuilder._();

    _instance.fieldName = fieldName;

    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder minLength(int minLength) {
    validations.add(MinLengthValidation(fieldName, minLength));
    return this;
  }

  List<FieldValidation> build() {
    return validations;
  }
}
