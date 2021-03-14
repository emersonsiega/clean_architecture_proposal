import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

abstract class LyricsSearchPresenter {
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Artist",
                    hintText: "Eric Clapton",
                    prefixIcon: Icon(Icons.person),
                    errorText: null,
                  ),
                  textInputAction: TextInputAction.none,
                  onChanged: presenter.validateArtist,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Music",
                    hintText: "Tears in Heaven",
                    prefixIcon: Icon(Icons.music_note),
                    errorText: null,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: presenter.validateMusic,
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

  setUp(() {
    artist = faker.lorem.word();
    music = faker.lorem.sentence();
    searchPresenterSpy = LyricsSearchPresenterSpy();
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
}
