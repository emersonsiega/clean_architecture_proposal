import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/ui/ui.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class StreamLyricsSearchPresenter implements LyricsSearchPresenter {
  final Validation validation;

  StreamLyricsSearchPresenter({@required this.validation});

  @override
  Stream<String> get artistErrorStream => throw UnimplementedError();

  @override
  void dispose() {}

  @override
  Stream<bool> get isFormValidStream => throw UnimplementedError();

  @override
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Stream<String> get localErrorStream => throw UnimplementedError();

  @override
  Stream<String> get musicErrorStream => throw UnimplementedError();

  @override
  Future<void> search() {
    throw UnimplementedError();
  }

  @override
  void validateArtist(String artist) {
    validation.validate(field: 'artist', value: artist);
  }

  @override
  void validateMusic(String music) {}
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLyricsSearchPresenter sut;
  ValidationSpy validationSpy;
  String artist;

  setUp(() {
    validationSpy = ValidationSpy();
    sut = StreamLyricsSearchPresenter(validation: validationSpy);
    artist = faker.person.name();
  });

  test('Should call validation with correct artist', () async {
    sut.validateArtist(artist);

    verify(
      validationSpy.validate(field: 'artist', value: artist),
    ).called(1);
  });
}
