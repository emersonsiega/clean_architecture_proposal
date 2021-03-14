import 'package:test/test.dart';

import 'package:clean_architecture_proposal/validation/validation.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, isNull);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, 'Required field');
  });

  test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, 'Required field');
  });
}
