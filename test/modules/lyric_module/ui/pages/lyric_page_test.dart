import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_proposal/shared/shared.dart';
import 'package:clean_architecture_proposal/shared/domain/domain.dart';

import 'package:clean_architecture_proposal/modules/modules.dart';
import 'package:clean_architecture_proposal/modules/lyric_module/ui/ui.dart';

import '../../../../helpers/module_builder.dart';

class LyricPresenterSpy extends Mock implements LyricPresenter {}

void main() {
  LyricEntity entity;
  LyricPresenterSpy lyricPresenterSpy;
  StreamController<LyricState> stateController;

  Future<void> loadPage(WidgetTester tester) async {
    final app = MaterialApp(
      home: LyricPage(entity: entity),
    );

    await tester.pumpWidget(app);
  }

  void mockStreams() {
    when(lyricPresenterSpy.stateStream)
        .thenAnswer((_) => stateController.stream);
  }

  setUp(() {
    lyricPresenterSpy = LyricPresenterSpy();
    stateController = StreamController<LyricState>.broadcast();

    entity = LyricEntity(
      lyric: faker.lorem.sentences(30).join(" "),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );

    mockStreams();

    ModuleBuilder.module(LyricModule())
        .bind<LyricPresenter>(() => lyricPresenterSpy)
        .build();
  });

  tearDown(() {
    stateController.close();
  });

  testWidgets('Should load LyricPage with correct data',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.text(entity.artist), findsOneWidget);
    expect(find.text(entity.music), findsOneWidget);
    expect(find.text(entity.lyric), findsOneWidget);

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

    stateController.add(LyricState(message: "success_message"));
    await tester.pumpAndSettle();

    expect(find.text('success_message'), findsOneWidget);
  });

  testWidgets('Should change icon on addFavorite success',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    stateController.add(LyricState(isFavorite: true));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('Should show and hide loading on addFavorite call',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricState(isLoading: true));
    await tester.pump(Duration(milliseconds: 200));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    stateController.add(LyricState(isLoading: false));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call checkFavorite', (WidgetTester tester) async {
    await loadPage(tester);

    verify(lyricPresenterSpy.checkIsFavorite(entity)).called(1);
  });
}
