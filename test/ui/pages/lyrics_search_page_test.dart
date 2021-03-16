import 'dart:async';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_proposal/dependency_management/dependency_management.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';

class LyricsSearchPresenterSpy extends Mock implements LyricsSearchPresenter {}

void main() {
  LyricsSearchPresenterSpy searchPresenterSpy;
  String artist;
  String music;
  List<LyricEntity> favoritesList;
  StreamController<String> artistErrorController;
  StreamController<String> musicErrorController;
  StreamController<String> formErrorController;
  StreamController<PageConfig> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<List<LyricEntity>> favoritesController;

  void mockPresenter() {
    when(searchPresenterSpy.artistErrorStream)
        .thenAnswer((_) => artistErrorController.stream);
    when(searchPresenterSpy.musicErrorStream)
        .thenAnswer((_) => musicErrorController.stream);
    when(searchPresenterSpy.localErrorStream)
        .thenAnswer((_) => formErrorController.stream);
    when(searchPresenterSpy.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(searchPresenterSpy.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(searchPresenterSpy.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(searchPresenterSpy.favoritesStream)
        .thenAnswer((_) => favoritesController.stream);
  }

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    favoritesList = [
      LyricEntity(lyric: faker.lorem.sentence(), artist: artist, music: music),
      LyricEntity(
          lyric: faker.lorem.sentence(),
          artist: faker.lorem.word(),
          music: faker.lorem.sentence()),
    ];
    searchPresenterSpy = LyricsSearchPresenterSpy();
    artistErrorController = StreamController<String>();
    musicErrorController = StreamController<String>();
    formErrorController = StreamController<String>();
    navigateToController = StreamController<PageConfig>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    favoritesController = StreamController<List<LyricEntity>>();

    mockPresenter();
  });

  tearDown(() {
    artistErrorController.close();
    musicErrorController.close();
    formErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    navigateToController.close();
    favoritesController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    Get.i().put<LyricsSearchPresenter>(searchPresenterSpy);

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
    verify(searchPresenterSpy.validateArtist(artist)).called(1);

    await tester.enterText(find.bySemanticsLabel('Music'), music);
    verify(searchPresenterSpy.validateMusic(music)).called(1);
  });

  testWidgets('Should present error if Artist is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    artistErrorController.add('error');
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present error if Music is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    musicErrorController.add('error');
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present no error if data is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    artistErrorController.add(null);
    musicErrorController.add(null);
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

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call search on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    verify(searchPresenterSpy.search()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should navigate to other page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add(PageConfig('/other_page'));
    await tester.pumpAndSettle();

    expect(find.text("other_page"), findsOneWidget);
  });

  testWidgets('Should present error if search fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    formErrorController.add('error_message');
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

    favoritesController.add(favoritesList);
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
}
