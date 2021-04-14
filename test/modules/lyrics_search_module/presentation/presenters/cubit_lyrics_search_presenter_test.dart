import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/presentation/presentation.dart';
import 'package:clean_architecture_proposal/shared/domain/domain.dart';
import 'package:clean_architecture_proposal/shared/ui/ui.dart';

import 'package:clean_architecture_proposal/modules/lyrics_search_module/ui/ui.dart';
import 'package:clean_architecture_proposal/modules/lyrics_search_module/domain/domain.dart';
import 'package:clean_architecture_proposal/modules/lyrics_search_module/presentation/presentation.dart';

class ValidationSpy extends Mock implements Validation {}

class LyricsSearchSpy extends Mock implements LyricsSearch {}

class LoadFavoriteLyricsSpy extends Mock implements LoadFavoriteLyrics {}

void main() {
  CubitLyricsSearchPresenter sut;
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
    sut = CubitLyricsSearchPresenter(
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
    sut.validate('artist', artist);

    verify(
      validationSpy.validate(field: 'artist', value: artist),
    ).called(1);
  });

  test('Should call validation with correct music', () async {
    sut.validate('music', music);

    verify(
      validationSpy.validate(field: 'music', value: music),
    ).called(1);
  });

  test('Should present error if artist is invalid', () async {
    mockValidation(value: 'invalid');

    expectLater(
      sut.stateStream,
      emits(
        LyricsSearchState.initial(artist: artist, artistError: 'invalid'),
      ),
    );

    sut.validate('artist', artist);
  });

  test('Should emits null if artist is valid', () async {
    expectLater(
      sut.stateStream,
      emits(LyricsSearchState.initial(artist: artist)),
    );

    sut.validate('artist', artist);
  });

  test('Should present error if music is invalid', () async {
    mockValidation(value: 'invalid');

    expectLater(
      sut.stateStream,
      emits(LyricsSearchState.initial(music: music, musicError: 'invalid')),
    );

    sut.validate('music', music);
  });

  test('Should emits null if music is valid', () async {
    expectLater(
      sut.stateStream,
      emits(LyricsSearchState.initial(music: music)),
    );

    sut.validate('music', music);
  });

  test('Should emits invalid form if any field is invalid (invalid music)',
      () async {
    mockValidation(field: 'music', value: 'invalid');

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist),
        LyricsSearchState.initial(
            artist: artist, music: music, musicError: 'invalid'),
      ]),
    );

    sut.validate('artist', artist);
    sut.validate('music', music);
  });

  test('Should emits invalid form if any field is invalid (invalid artist)',
      () async {
    mockValidation(field: 'artist', value: 'invalid');

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist, artistError: 'invalid'),
        LyricsSearchState.initial(
            artist: artist, artistError: 'invalid', music: music),
      ]),
    );

    sut.validate('artist', artist);
    sut.validate('music', music);
  });

  test('Should emits form valid if all fields are valid', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist),
        LyricsSearchState.initial(artist: artist, music: music),
      ]),
    );

    sut.validate('artist', artist);
    sut.validate('music', music);
  });

  test('Should call LyricsSearch with correct values', () async {
    sut.validate('artist', artist);
    sut.validate('music', music);

    await sut.search();

    final params = LyricsSearchParams(artist: artist, music: music);

    verify(lyricsSearchSpy.search(params)).called(1);
  });

  test('Should emit correct events on LyricsSearch success', () async {
    sut.validate('artist', artist);
    sut.validate('music', music);

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist, music: music)
            .copyWith(isLoading: true),
        LyricsSearchState.initial(artist: artist, music: music).copyWith(
          isLoading: true,
          navigateTo: PageConfig(
            '/lyric',
            arguments: entity,
            type: NavigateType.push,
            whenComplete: sut.loadFavorites,
          ),
        ),
        LyricsSearchState.initial(artist: artist, music: music)
            .copyWith(isLoading: false),
      ]),
    );

    await sut.search();
  });

  test('Should emit invalidQuery on LyricsSearch failure', () async {
    mockLyricsSearchError(error: DomainError.invalidQuery);

    sut.validate('artist', artist);
    sut.validate('music', music);

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist, music: music)
            .copyWith(isLoading: true),
        LyricsSearchState.initial(artist: artist, music: music).copyWith(
            isLoading: false,
            errorMessage: 'Invalid query. Try again with different values.'),
      ]),
    );

    await sut.search();
  });

  test('Should emit unexpectedError on LyricsSearch failure', () async {
    mockLyricsSearchError();

    sut.validate('artist', artist);
    sut.validate('music', music);

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial(artist: artist, music: music)
            .copyWith(isLoading: true),
        LyricsSearchState.initial(artist: artist, music: music).copyWith(
            isLoading: false,
            errorMessage: 'Something wrong happened. Please, try again!'),
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
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial().copyWith(isLoading: true),
        LyricsSearchState.initial()
            .copyWith(isLoading: false, favorites: [entity]),
      ]),
    );

    await sut.loadFavorites();
  });

  test('Should emit error event on loadFavorites failure', () async {
    mockLoadFavoriteLyricsError();

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState.initial().copyWith(isLoading: true),
        LyricsSearchState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Something wrong happened. Please, try again!',
        ),
      ]),
    );

    await sut.loadFavorites();
  });

  test('Should emit navigate events on openFavorite', () async {
    expectLater(
      sut.stateStream,
      emits(
        LyricsSearchState.initial().copyWith(
          isLoading: false,
          navigateTo: PageConfig(
            '/lyric',
            arguments: entity,
            type: NavigateType.push,
            whenComplete: sut.loadFavorites,
          ),
        ),
      ),
    );

    await sut.openFavorite(entity);
  });
}
