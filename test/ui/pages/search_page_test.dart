import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class LyricsSearchPresenter {
  Stream<String> get artistErrorStream;
  Stream<String> get musicErrorStream;

  void validateArtist(String artist);
  void validateMusic(String music);
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: null,
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

  void mockStreams() {
    when(searchPresenterSpy.artistErrorStream)
        .thenAnswer((_) => artistErrorController.stream);
    when(searchPresenterSpy.musicErrorStream)
        .thenAnswer((_) => musicErrorController.stream);
  }

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    searchPresenterSpy = LyricsSearchPresenterSpy();
    artistErrorController = StreamController<String>();
    musicErrorController = StreamController<String>();
    mockStreams();
  });

  tearDown(() {
    artistErrorController.close();
    musicErrorController.close();
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
}
