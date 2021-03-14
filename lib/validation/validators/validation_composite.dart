import '../../presentation/presentation.dart';

import '../validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({String field, String value}) {
    final fieldValidations =
        validations.where((validation) => validation.field == field);

    for (var validation in fieldValidations) {
      final error = validation.validate(value);

      if (error?.isNotEmpty != false) {
        return error;
      }
    }

    return null;
  }
}
