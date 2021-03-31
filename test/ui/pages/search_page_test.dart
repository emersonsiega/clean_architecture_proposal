import 'dart:async';

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
  StreamController<LyricsSearchState> stateController;

  void mockPresenter() {
    when(searchPresenterSpy.stateStream)
        .thenAnswer((_) => stateController.stream);
  }

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    searchPresenterSpy = LyricsSearchPresenterSpy();
    stateController = StreamController<LyricsSearchState>.broadcast();

    mockPresenter();
  });

  tearDown(() {
    stateController.close();
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
    verify(searchPresenterSpy.fireEvent(ValidateArtistEvent(artist))).called(1);

    await tester.enterText(find.bySemanticsLabel('Music'), music);
    verify(searchPresenterSpy.fireEvent(ValidateMusicEvent(music))).called(1);
  });

  testWidgets('Should present error if Artist is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState(artistError: 'error'));
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present error if Music is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState(musicError: 'error'));
    await tester.pump();

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present no error if data is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(
      LyricsSearchState(artistError: null, musicError: null),
    );
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

    stateController.add(
      LyricsSearchState(music: 'any_music', artist: 'any_artist'),
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

    stateController.add(LyricsSearchState(musicError: 'error'));
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call search on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(
      LyricsSearchState(music: 'any_music', artist: 'any_artist'),
    );
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    verify(searchPresenterSpy.fireEvent(SearchLyricEvent())).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState(isLoading: true));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState(isLoading: true));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    stateController.add(LyricsSearchState(isLoading: false));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should navigate to other page', (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(
      LyricsSearchState(navigateTo: PageConfig('/other_page')),
    );
    await tester.pumpAndSettle();

    expect(find.text("other_page"), findsOneWidget);
  });

  testWidgets('Should present error if search fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    stateController.add(LyricsSearchState(localError: 'error_message'));
    await tester.pump();
    expect(find.text('error_message'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(searchPresenterSpy.dispose()).called(1);
    });
  });
}
