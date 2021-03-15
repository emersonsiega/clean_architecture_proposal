import 'dart:async';

import 'package:clean_architecture_proposal/dependency_management/dependency_management.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';
import 'package:mockito/mockito.dart';

class LyricPresenterSpy extends Mock implements LyricPresenter {}

void main() {
  LyricEntity entity;
  LyricPresenterSpy lyricPresenterSpy;
  StreamController<String> messageController;
  StreamController<bool> isFavoriteController;

  Future<void> loadPage(WidgetTester tester) async {
    BuildContext _context;
    Get.i().put<LyricPresenter>(lyricPresenterSpy);

    final app = MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => Builder(
              builder: (context) {
                _context = context;
                return Container();
              },
            ),
        '/lyric': (_) => LyricPage(),
      },
    );

    await tester.pumpWidget(app);
    Navigator.of(_context).pushNamed('/lyric', arguments: entity);
    await tester.pumpAndSettle();
  }

  void mockStreams() {
    when(lyricPresenterSpy.successMessageStream)
        .thenAnswer((_) => messageController.stream);
    when(lyricPresenterSpy.isFavoriteStream)
        .thenAnswer((_) => isFavoriteController.stream);
  }

  setUp(() {
    lyricPresenterSpy = LyricPresenterSpy();
    messageController = StreamController<String>();
    isFavoriteController = StreamController<bool>();
    entity = LyricEntity(
      lyric: faker.lorem.sentences(30).join(" "),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );

    mockStreams();
  });

  tearDown(() {
    messageController.close();
    isFavoriteController.close();
  });

  testWidgets('Should load LyricPage with correct data',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.text(entity.artist), findsOneWidget);
    expect(find.text(entity.music), findsOneWidget);
    expect(find.text(entity.lyric), findsOneWidget);

    expect(find.byType(BackButton), findsOneWidget);
    expect(
      find.byKey(Key("favoriteButton")),
      findsOneWidget,
    );
  });

  testWidgets('Should call addFavorite with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    await tester.tap(find.byKey(Key("favoriteButton")));

    verify(lyricPresenterSpy.addFavorite(entity)).called(1);
  });

  testWidgets('Should present message on addFavorite success',
      (WidgetTester tester) async {
    await loadPage(tester);

    messageController.add("success_message");
    await tester.pumpAndSettle();

    expect(find.text('success_message'), findsOneWidget);
  });

  testWidgets('Should change icon on addFavorite success',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    isFavoriteController.add(true);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
