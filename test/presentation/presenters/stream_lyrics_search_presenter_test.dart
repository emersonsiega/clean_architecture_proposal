import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/presentation/presentation.dart';

class ValidationSpy extends Mock implements Validation {}

class LyricsSearchSpy extends Mock implements LyricsSearch {}

void main() {
  StreamLyricsSearchPresenter sut;
  ValidationSpy validationSpy;
  LyricsSearchSpy lyricsSearchSpy;
  String artist;
  String music;

  PostExpectation mockValidationCall(String field) =>
      when(validationSpy.validate(
          field: field == null ? anyNamed('field') : field,
          value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockSearchCall() => when(lyricsSearchSpy.search(any));

  void mockLyricsSearchError({DomainError error: DomainError.unexpected}) {
    mockSearchCall().thenThrow(error);
  }

  setUp(() {
    validationSpy = ValidationSpy();
    lyricsSearchSpy = LyricsSearchSpy();
    sut = StreamLyricsSearchPresenter(
      validation: validationSpy,
      lyricsSearch: lyricsSearchSpy,
    );
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

  test('Should emits form valid if all fields are valid', () async {
    expectLater(sut.artistErrorStream, emits(null));
    expectLater(sut.musicErrorStream, emits(null));
    expectLater(sut.isFormValidStream, emits(true));

    sut.validateArtist(artist);
    sut.validateMusic(music);
  });

  test('Should call LyricsSearch with correct values', () async {
    sut.validateArtist(artist);
    sut.validateMusic(music);

    await sut.search();

    final params = LyricsSearchParams(artist: artist, music: music);

    verify(lyricsSearchSpy.search(params)).called(1);
  });

  test('Should emit correct events on LyricsSearch success', () async {
    sut.validateArtist(artist);
    sut.validateMusic(music);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.search();
  });

  test('Should emit invalidQuery on LyricsSearch failure', () async {
    mockLyricsSearchError(error: DomainError.invalidQuery);

    sut.validateArtist(artist);
    sut.validateMusic(music);

    expectLater(sut.isLoadingStream, emits(false));
    expectLater(
      sut.localErrorStream,
      emits('Invalid query. Try again with different values.'),
    );

    await sut.search();
  });

  test('Should emit unexpectedError on LyricsSearch failure', () async {
    mockLyricsSearchError();

    sut.validateArtist(artist);
    sut.validateMusic(music);

    expectLater(sut.isLoadingStream, emits(false));
    expectLater(
      sut.localErrorStream,
      emits('Something wrong happened. Please, try again!'),
    );

    await sut.search();
  });
}
