import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';
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
  String lyric;
  LyricEntity entity;
  LyricsSearchState baseState;

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

  setUp(() {
    validationSpy = ValidationSpy();
    lyricsSearchSpy = LyricsSearchSpy();
    sut = StreamLyricsSearchPresenter(
      validation: validationSpy,
      lyricsSearch: lyricsSearchSpy,
    );

    artist = faker.person.name();
    music = faker.lorem.sentence();
    lyric = faker.lorem.sentences(50).join(" ");
    entity = LyricEntity(lyric: lyric, artist: artist, music: music);
    baseState = LyricsSearchState(
      artist: artist,
      music: music,
      isLoading: false,
    );

    mockValidation();
    mockLyricsSearchSuccess();
  });

  Future<void> _fireEvent(event) async {
    sut.fireEvent(event);
    await Future.delayed(Duration.zero);
  }

  test('Should call validation with correct artist', () async {
    await _fireEvent(ValidateArtistEvent(artist));

    verify(
      validationSpy.validate(field: 'artist', value: artist),
    ).called(1);
  });

  test('Should call validation with correct music', () async {
    await _fireEvent(ValidateMusicEvent(music));

    verify(
      validationSpy.validate(field: 'music', value: music),
    ).called(1);
  });

  test('Should present error if artist is invalid', () async {
    mockValidation(value: 'invalid');

    expectLater(
      sut.stateStream,
      emits(LyricsSearchState(artist: artist, artistError: 'invalid')),
    );

    await _fireEvent(ValidateArtistEvent(artist));
  });

  test('Should emits null if artist is valid', () async {
    expectLater(
      sut.stateStream,
      emits(LyricsSearchState(artist: artist, artistError: null)),
    );

    await _fireEvent(ValidateArtistEvent(artist));
  });

  test('Should present error if music is invalid', () async {
    mockValidation(value: 'invalid');

    expectLater(
      sut.stateStream,
      emits(LyricsSearchState(music: music, musicError: 'invalid')),
    );

    await _fireEvent(ValidateMusicEvent(music));
  });

  test('Should emits null if music is valid', () async {
    expectLater(
      sut.stateStream,
      emits(LyricsSearchState(music: music, musicError: null)),
    );

    await _fireEvent(ValidateMusicEvent(music));
  });

  test('Should emits invalid form if any field is invalid', () async {
    mockValidation(field: 'music', value: 'invalid');

    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricsSearchState(artist: artist),
          baseState.copyWith(
            musicError: 'invalid',
            //isFormValid: false
          ),
        ],
      ),
    );

    await _fireEvent(ValidateArtistEvent(artist));
    await _fireEvent(ValidateMusicEvent(music));
  });

  test('Should emits invalid form if any field is invalid', () async {
    mockValidation(field: 'artist', value: 'invalid');

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState(artist: artist, artistError: 'invalid'),
        baseState.copyWith(
          artistError: 'invalid',
          //isFormValid: false
        ),
      ]),
    );

    await _fireEvent(ValidateArtistEvent(artist));
    await _fireEvent(ValidateMusicEvent(music));
  });

  test('Should emits form valid if all fields are valid', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricsSearchState(artist: artist),
        baseState
            .copyWith(
                //isFormValid: true,
                )
            .copyWithNull(
              musicError: true,
              artistError: true,
            ),
      ]),
    );

    await _fireEvent(ValidateArtistEvent(artist));
    await _fireEvent(ValidateMusicEvent(music));
  });

  test('Should call LyricsSearch with correct values', () async {
    await _fireEvent(ValidateArtistEvent(artist));
    await _fireEvent(ValidateMusicEvent(music));

    await _fireEvent(SearchLyricEvent());

    final params = LyricsSearchParams(artist: artist, music: music);

    verify(lyricsSearchSpy.search(params)).called(1);
  });

  test('Should emit correct events on LyricsSearch success', () async {
    await _fireEvent(ValidateArtistEvent(artist));
    await _fireEvent(ValidateMusicEvent(music));

    expectLater(
      sut.stateStream,
      emitsInOrder([
        baseState.copyWith(isLoading: true),
        baseState.copyWith(
          isLoading: false,
          navigateTo: PageConfig(
            '/lyric',
            arguments: entity,
            type: NavigateType.push,
          ),
        ),
      ]),
    );

    await _fireEvent(SearchLyricEvent());
  });

  test('Should emit invalidQuery on LyricsSearch failure', () async {
    mockLyricsSearchError(error: DomainError.invalidQuery);

    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricsSearchState(artist: artist),
          baseState,
          baseState.copyWith(isLoading: true),
          baseState.copyWith(
            isLoading: false,
            localError: 'Invalid query. Try again with different values.',
          ),
        ],
      ),
    );

    _fireEvent(ValidateArtistEvent(artist));
    _fireEvent(ValidateMusicEvent(music));
    await _fireEvent(SearchLyricEvent());
  });

  test('Should emit unexpectedError on LyricsSearch failure', () async {
    mockLyricsSearchError();

    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricsSearchState(artist: artist),
          baseState,
          baseState.copyWith(isLoading: true),
          baseState.copyWith(
            isLoading: false,
            localError: 'Something wrong happened. Please, try again!',
          ),
        ],
      ),
    );

    _fireEvent(ValidateArtistEvent(artist));
    _fireEvent(ValidateMusicEvent(music));
    await _fireEvent(SearchLyricEvent());
  });
}
