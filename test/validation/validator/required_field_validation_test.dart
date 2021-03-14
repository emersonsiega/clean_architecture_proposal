import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

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
