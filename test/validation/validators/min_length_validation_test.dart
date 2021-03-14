import 'package:test/test.dart';

import 'package:clean_architecture_proposal/validation/validation.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  MinLengthValidation(this.field);

  @override
  String validate(String value) {
    return null;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation('any_field');
  });

  test('Should return null if value is empty', () {
    final error = sut.validate('');

    expect(error, isNull);
  });
}
