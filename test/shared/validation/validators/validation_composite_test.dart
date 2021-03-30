import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/validation/validation.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation(FieldValidationSpy validation,
      {String field: 'any_field', String error}) {
    when(validation.field).thenReturn(field);
    when(validation.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    mockValidation(validation1);

    validation2 = FieldValidationSpy();
    mockValidation(validation2);

    validation3 = FieldValidationSpy();
    mockValidation(validation3, field: 'other_field');

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation(validation2, error: '');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, isNull);
  });

  test('Should return the first error found', () {
    mockValidation(validation1, error: 'error_1');
    mockValidation(validation2, error: 'error_2');
    mockValidation(validation3, error: 'error_3', field: 'other_field');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error_1');
  });

  test('Should return the first error of the correct field', () {
    mockValidation(validation1, error: 'error_1');
    mockValidation(validation2, error: 'error_2');
    mockValidation(validation3, error: 'error_3', field: 'other_field');

    final error = sut.validate(field: 'other_field', value: 'any_value');

    expect(error, 'error_3');
  });
}
