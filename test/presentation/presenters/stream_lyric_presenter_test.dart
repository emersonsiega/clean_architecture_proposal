import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class LyricPresenter {
  Future<void> addFavorite(LyricEntity entity);
}

class StreamLyricPresenter implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;

  StreamLyricPresenter({@required this.saveFavoriteLyrics});

  @override
  Future<void> addFavorite(LyricEntity entity) async {
    await saveFavoriteLyrics.save([entity]);
  }
}

class SaveFavoriteLyricsSpy extends Mock implements SaveFavoriteLyrics {}

void main() {
  StreamLyricPresenter sut;
  SaveFavoriteLyricsSpy saveFavoriteLyricsSpy;
  LyricEntity entity;

  setUp(() {
    saveFavoriteLyricsSpy = SaveFavoriteLyricsSpy();
    sut = StreamLyricPresenter(saveFavoriteLyrics: saveFavoriteLyricsSpy);
    entity = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );
  });

  test('Should call SaveFavoriteLyrics with correct values', () async {
    await sut.addFavorite(entity);

    verify(saveFavoriteLyricsSpy.save([entity])).called(1);
  });
}
