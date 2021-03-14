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
  String artist;
  String music;
  String artistError;
  String musicError;

  bool get isFormValid =>
      artist?.isNotEmpty == true &&
      artistError?.isNotEmpty == false &&
      music?.isNotEmpty == true &&
      musicError?.isNotEmpty == false;
}

class StreamLyricsSearchPresenter implements LyricsSearchPresenter {
  final Validation validation;
  final _state = LyricsSearchState();
  final _stateController = StreamController<LyricsSearchState>.broadcast();

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
  Stream<bool> get isFormValidStream =>
      _stateController.stream.map((state) => state.isFormValid);

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
    _state.artist = artist;
    final error = validation.validate(field: 'artist', value: artist);
    _state.artistError = error;
    _update();
  }

  @override
  void validateMusic(String music) {
    _state.music = music;
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

  PostExpectation mockValidationCall(String field) =>
      when(validationSpy.validate(
          field: field == null ? anyNamed('field') : field,
          value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validationSpy = ValidationSpy();
    sut = StreamLyricsSearchPresenter(validation: validationSpy);
    artist = faker.person.name();
    music = faker.lorem.sentence();

    mockValidation();
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
    mockValidation(value: 'invalid');

    expectLater(sut.artistErrorStream, emits('invalid'));

    sut.validateArtist(artist);
  });

  test('Should emits null if artist is valid', () async {
    expectLater(sut.artistErrorStream, emits(null));

    sut.validateArtist(artist);
  });

  test('Should present error if music is invalid', () async {
    mockValidation(value: 'invalid');

    expectLater(sut.musicErrorStream, emits('invalid'));

    sut.validateMusic(music);
  });

  test('Should emits null if music is valid', () async {
    expectLater(sut.musicErrorStream, emits(null));

    sut.validateMusic(music);
  });

  test('Should emits invalid form if any field is invalid', () async {
    mockValidation(field: 'music', value: 'invalid');

    expectLater(sut.artistErrorStream, emits(null));
    expectLater(sut.musicErrorStream, emits('invalid'));
    expectLater(sut.isFormValidStream, emits(false));

    sut.validateArtist(artist);
    sut.validateMusic(music);
  });

  test('Should emits invalid form if any field is invalid', () async {
    mockValidation(field: 'artist', value: 'invalid');

    expectLater(sut.artistErrorStream, emits('invalid'));
    expectLater(sut.musicErrorStream, emits(null));
    expectLater(sut.isFormValidStream, emits(false));

    sut.validateArtist(artist);
    sut.validateMusic(music);
  });
}
