import 'dart:async';

import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/ui/ui.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class LyricsSearchState {
  String emailError;
}

class StreamLyricsSearchPresenter implements LyricsSearchPresenter {
  final Validation validation;
  final _state = LyricsSearchState();
  final _stateController = StreamController<LyricsSearchState>();

  StreamLyricsSearchPresenter({@required this.validation}) {
    _stateController.add(_state);
  }

  @override
  Stream<String> get artistErrorStream =>
      _stateController.stream.map((state) => state.emailError);

  @override
  void dispose() {
    _stateController.close();
  }

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
    final error = validation.validate(field: 'artist', value: artist);
    _state.emailError = error;
    _stateController.add(_state);
  }

  @override
  void validateMusic(String music) {
    validation.validate(field: 'music', value: music);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLyricsSearchPresenter sut;
  ValidationSpy validationSpy;
  String artist;
  String music;

  setUp(() {
    validationSpy = ValidationSpy();
    sut = StreamLyricsSearchPresenter(validation: validationSpy);
    artist = faker.person.name();
    music = faker.lorem.sentence();
  });

  test('Should call validation with correct artist', () async {
    sut.validateArtist(artist);

    verify(
      validationSpy.validate(field: 'artist', value: artist),
    ).called(1);
  });

  test('Should call validation with correct music', () async {
    sut.validateMusic(music);

    verify(
      validationSpy.validate(field: 'music', value: music),
    ).called(1);
  });

  test('Should present error if artist is invalid', () async {
    when(validationSpy.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn('invalid');

    expectLater(sut.artistErrorStream, emits('invalid'));

    sut.validateArtist(artist);
  });
}
