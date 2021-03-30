import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/presentation/presentation.dart';
import 'package:clean_architecture_proposal/shared/domain/domain.dart';
import 'package:clean_architecture_proposal/shared/ui/ui.dart';

import 'package:clean_architecture_proposal/modules/lyrics_search_module/domain/domain.dart';
import 'package:clean_architecture_proposal/modules/lyrics_search_module/presentation/presentation.dart';

class ValidationSpy extends Mock implements Validation {}

class LyricsSearchSpy extends Mock implements LyricsSearch {}

class LoadFavoriteLyricsSpy extends Mock implements LoadFavoriteLyrics {}

void main() {
  StreamLyricsSearchPresenter sut;
  ValidationSpy validationSpy;
  LyricsSearchSpy lyricsSearchSpy;
  LoadFavoriteLyricsSpy loadFavoriteLyricsSpy;
  String artist;
  String music;
  String lyric;
  LyricEntity entity;

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

  void mockLyricsSearchSuccess() {
    mockSearchCall().thenAnswer((_) async => entity);
  }

  PostExpectation mockLoadFavoritesCall() =>
      when(loadFavoriteLyricsSpy.loadFavorites());

  void mockLoadFavoriteLyricsSuccess() {
    mockLoadFavoritesCall().thenAnswer((_) async => [entity]);
  }

  void mockLoadFavoriteLyricsError() {
    mockLoadFavoritesCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validationSpy = ValidationSpy();
    lyricsSearchSpy = LyricsSearchSpy();
    loadFavoriteLyricsSpy = LoadFavoriteLyricsSpy();
    sut = StreamLyricsSearchPresenter(
      validation: validationSpy,
      lyricsSearch: lyricsSearchSpy,
      loadFavoriteLyrics: loadFavoriteLyricsSpy,
    );

    artist = faker.person.name();
    music = faker.lorem.sentence();
    lyric = faker.lorem.sentences(50).join(" ");
    entity = LyricEntity(lyric: lyric, artist: artist, music: music);

    mockValidation();
    mockLyricsSearchSuccess();
    mockLoadFavoriteLyricsSuccess();
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

  test('Should navigate to lyric page on LyricsSearch', () async {
    sut.validateArtist(artist);
    sut.validateMusic(music);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
      sut.navigateToStream,
      emitsInOrder([
        null,
        PageConfig(
          '/lyric',
          arguments: entity,
          type: NavigateType.push,
          whenComplete: sut.loadFavorites,
        )
      ]),
    );

    await sut.search();
  });

  test('Should call LoadFavoriteLyrics on load', () async {
    await sut.loadFavorites();

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should emit favorites event on loadFavorites', () async {
    expectLater(
      sut.favoritesStream,
      emitsInOrder([
        null,
        [entity]
      ]),
    );

    await sut.loadFavorites();
  });

  test('Should emit error event on loadFavorites failure', () async {
    mockLoadFavoriteLyricsError();

    expectLater(
      sut.localErrorStream,
      emits('Something wrong happened. Please, try again!'),
    );

    await sut.loadFavorites();
  });

  test('Should emit loading events on loadFavorites', () async {
    expectLater(
      sut.isLoadingFavoritesStream,
      emitsInOrder([true, false]),
    );

    await sut.loadFavorites();
  });

  test('Should emit navigate events on openFavorite', () async {
    expectLater(
      sut.navigateToStream,
      emits(PageConfig('/lyric', arguments: entity, type: NavigateType.push)),
    );

    await sut.openFavorite(entity);
  });

  test('Should reload favorites after openFavorite', () async {
    expectLater(
      sut.navigateToStream,
      emits(
        PageConfig(
          '/lyric',
          arguments: entity,
          type: NavigateType.push,
          whenComplete: sut.loadFavorites,
        ),
      ),
    );

    await sut.openFavorite(entity);
  });
}
