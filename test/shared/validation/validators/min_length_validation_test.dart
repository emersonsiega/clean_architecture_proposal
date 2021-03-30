import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/validation/validation.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation('any_field', 3);
  });

  test('Should return null if value is empty', () {
    final error = sut.validate('');

    expect(error, isNull);
  });

  test('Should return null if value is null', () {
    final error = sut.validate(null);

    expect(error, isNull);
  });

  test('Should return error if value is invalid', () {
    final error = sut.validate('ab');

    expect(error, 'Invalid value. Min length is 3');
  });

  test('Should return null if value is valid', () {
    final error = sut.validate('abc');

    expect(error, isNull);
  });
}
