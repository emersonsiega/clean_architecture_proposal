import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class FormValidManager {
  Stream<bool> get isFormValidStream;
}

abstract class FormLoadingManager {
  Stream<bool> get isLoadingStream;
}

abstract class LyricsSearchPresenter
    implements FormValidManager, FormLoadingManager {
  Stream<String> get artistErrorStream;
  Stream<String> get musicErrorStream;

  void validateArtist(String artist);
  void validateMusic(String music);

  Future<void> search();
}

class LyricsSearchPresenterSpy extends Mock implements LyricsSearchPresenter {}

class SearchPage extends StatelessWidget {
  final LyricsSearchPresenter presenter;

  const SearchPage({
    Key key,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics Search"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 32),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<String>(
                  stream: presenter.artistErrorStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Artist",
                        hintText: "Eric Clapton",
                        prefixIcon: Icon(Icons.person),
                        errorText: snapshot.data,
                      ),
                      textInputAction: TextInputAction.none,
                      onChanged: presenter.validateArtist,
                    );
                  },
                ),
                const SizedBox(height: 30),
                StreamBuilder<String>(
                  stream: presenter.musicErrorStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Music",
                        hintText: "Tears in Heaven",
                        prefixIcon: Icon(Icons.music_note),
                        errorText: snapshot.data,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: presenter.validateMusic,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        initialData: false,
        builder: (context, isFormValid) {
          return FloatingActionButton(
            child: StreamBuilder<bool>(
              stream: presenter.isLoadingStream,
              initialData: false,
              builder: (context, isLoading) {
                if (isLoading.data == true) {
                  return CircularProgressIndicator();
                }

                return Icon(Icons.search);
              },
            ),
            onPressed: isFormValid.data == true ? presenter.search : null,
          );
        },
      ),
    );
  }
}

void main() {
  LyricsSearchPresenterSpy searchPresenterSpy;
  String artist;
  String music;
  StreamController<String> artistErrorController;
  StreamController<String> musicErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void mockPresenter() {
    when(searchPresenterSpy.artistErrorStream)
        .thenAnswer((_) => artistErrorController.stream);
    when(searchPresenterSpy.musicErrorStream)
        .thenAnswer((_) => musicErrorController.stream);
    when(searchPresenterSpy.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(searchPresenterSpy.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    searchPresenterSpy = LyricsSearchPresenterSpy();
    artistErrorController = StreamController<String>();
    musicErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mockPresenter();
  });

  tearDown(() {
    artistErrorController.close();
    musicErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    final page = MaterialApp(
      home: SearchPage(presenter: searchPresenterSpy),
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
}
