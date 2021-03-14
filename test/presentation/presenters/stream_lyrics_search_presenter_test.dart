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
  String artistError;
  String musicError;
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
      _stateController.stream.map((state) => state.artistError);

  @override
  Stream<String> get musicErrorStream =>
      _stateController.stream.map((state) => state.musicError);

  @override
  Stream<bool> get isFormValidStream => throw UnimplementedError();

  @override
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Stream<String> get localErrorStream => throw UnimplementedError();

  @override
  Future<void> search() {
    throw UnimplementedError();
  }

  void _update() => _stateController.add(_state);

  @override
  void validateArtist(String artist) {
    final error = validation.validate(field: 'artist', value: artist);
    _state.artistError = error;
    _update();
  }

  @override
  void validateMusic(String music) {
    final error = validation.validate(field: 'music', value: music);
    _state.musicError = error;
    _update();
  }

  @override
  void dispose() {
    _stateController.close();
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLyricsSearchPresenter sut;
  ValidationSpy validationSpy;
  String artist;
  String music;

  PostExpectation mockValidationCall() => when(validationSpy.validate(
      field: anyNamed('field'), value: anyNamed('value')));

  void mockValidationError() {
    mockValidationCall().thenReturn('invalid');
  }

  void mockValidationSuccess() {
    mockValidationCall().thenReturn(null);
  }

  setUp(() {
    validationSpy = ValidationSpy();
    sut = StreamLyricsSearchPresenter(validation: validationSpy);
    artist = faker.person.name();
    music = faker.lorem.sentence();

    mockValidationSuccess();
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
    mockValidationError();

    expectLater(sut.artistErrorStream, emits('invalid'));

    sut.validateArtist(artist);
  });

  test('Should emits null if artist is valid', () async {
    expectLater(sut.artistErrorStream, emits(null));

    sut.validateArtist(artist);
  });

  test('Should present error if music is invalid', () async {
    mockValidationError();

    expectLater(sut.musicErrorStream, emits('invalid'));

    sut.validateMusic(music);
  });

  test('Should emits null if music is valid', () async {
    expectLater(sut.musicErrorStream, emits(null));

    sut.validateMusic(music);
  });
}
