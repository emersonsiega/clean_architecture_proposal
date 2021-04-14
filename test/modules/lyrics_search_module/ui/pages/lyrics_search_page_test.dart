import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_proposal/shared/domain/domain.dart';
import 'package:clean_architecture_proposal/modules/modules.dart';
import 'package:clean_architecture_proposal/modules/lyrics_search_module/ui/ui.dart';

import '../../../../helpers/module_builder.dart';

class LyricsSearchPresenterSpy extends Mock implements LyricsSearchPresenter {}

void main() {
  LyricsSearchPresenterSpy searchPresenterSpy;
  String artist;
  String music;
  List<LyricEntity> favoritesList;
  StreamController<LyricsSearchState> stateController;

  void mockPresenter() {
    when(searchPresenterSpy.stateStream)
        .thenAnswer((_) => stateController.stream);
  }

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    favoritesList = [
      LyricEntity(lyric: faker.lorem.sentence(), artist: artist, music: music),
      LyricEntity(
        lyric: faker.lorem.sentence(),
        artist: faker.lorem.word(),
        music: faker.lorem.sentence(),
      ),
    ];
    searchPresenterSpy = LyricsSearchPresenterSpy();
    stateController = StreamController<LyricsSearchState>.broadcast();

    mockPresenter();

    ModuleBuilder.module(LyricsSearchModule())
        .bind<LyricsSearchPresenter>(() => searchPresenterSpy)
        .build();
  });

  tearDown(() {
    stateController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    final page = MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => LyricsSearchPage(),
        '/other_page': (_) => Text('other_page'),
      },
    );

    await tester.pumpWidget(page);
  }

  testWidgets('Should load SearchPage with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final artistInputTextChildren = find.descendant(
      of: find.bySemanticsLabel('Artist'),
      matching: find.byType(Text),
    );
    expect(
      artistInputTextChildren,
      findsNWidgets(2),
      reason: "Should find just two text children: Label and Hint text.",
    );

    final musicInputTextChildren = find.descendant(
      of: find.bySemanticsLabel('Music'),
      matching: find.byType(Text),
    );
    expect(
      musicInputTextChildren,
      findsNWidgets(2),
      reason: "Should find just two text children: Label and Hint text.",
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate when form changes',
      (WidgetTester tester) async {
    await loadPage(tester);

    await tester.enterText(find.bySemanticsLabel('Artist'), artist);
    verify(searchPresenterSpy.validate('artist', artist)).called(1);

    await tester.enterText(find.bySemanticsLabel('Music'), music);
    verify(searchPresenterSpy.validate('music', music)).called(1);
  });

  testWidgets('Should present error if Artist is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial(artistError: 'error'));
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present error if Music is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial(musicError: 'error'));
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present no error if data is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial());
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Artist'),
        matching: find.byType(Text),
      ),
      findsNWidgets(2),
    );

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Music'),
        matching: find.byType(Text),
      ),
      findsNWidgets(2),
    );
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    var state = LyricsSearchState.initial();
    stateController.add(
      state.copyWith(
        form: state.form
            .copyWith('artist', value: 'any')
            .copyWith('music', value: 'any'),
      ),
    );
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial(musicError: 'error'));
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call search on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    var state = LyricsSearchState.initial();
    stateController.add(
      state.copyWith(
        form: state.form
            .copyWith('artist', value: 'any')
            .copyWith('music', value: 'any'),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    verify(searchPresenterSpy.search()).called(1);
  });

  testWidgets('Should show and hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial().copyWith(isLoading: true));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    stateController.add(LyricsSearchState.initial().copyWith(isLoading: false));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if search fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(
        LyricsSearchState.initial().copyWith(errorMessage: 'error_message'));
    await tester.pump();
    expect(find.text('error_message'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(searchPresenterSpy.dispose()).called(1);
    });
  });

  testWidgets('Should call loadFavorites on initState',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(searchPresenterSpy.loadFavorites()).called(1);
  });

  testWidgets('Should present list of favorites', (WidgetTester tester) async {
    await loadPage(tester);

    stateController
        .add(LyricsSearchState.initial().copyWith(favorites: favoritesList));
    await tester.pump();

    expect(find.text("Favorites"), findsOneWidget);
    expect(
      find.text("${favoritesList.first.artist} - ${favoritesList.first.music}"),
      findsOneWidget,
    );
    expect(
      find.text("${favoritesList[1].artist} - ${favoritesList[1].music}"),
      findsOneWidget,
    );
  });

  testWidgets('Should not present list of favorites if there is no data',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState.initial().copyWith(favorites: null));
    await tester.pump();
    expect(find.text("Favorites"), findsNothing);

    stateController.add(LyricsSearchState.initial().copyWith(favorites: []));
    await tester.pump();
    expect(find.text("Favorites"), findsNothing);
  });

  testWidgets('Should call openFavorite on tap favorite',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController
        .add(LyricsSearchState.initial().copyWith(favorites: favoritesList));
    await tester.pump();

    final favoriteTile = find.byKey(Key("${favoritesList.first.id}"));
    expect(favoriteTile, findsOneWidget);

    await tester.tap(favoriteTile);
    await tester.pump();

    verify(searchPresenterSpy.openFavorite(favoritesList.first)).called(1);
  });
}
