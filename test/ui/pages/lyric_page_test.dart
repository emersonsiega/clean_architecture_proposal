import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LyricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LyricEntity entity = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${entity.artist}"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text("${entity.music}"),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Text(
          "${entity.lyric}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

void main() {
  LyricEntity entity;

  Future<void> loadPage(WidgetTester tester) async {
    BuildContext _context;

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

  setUp(() {
    entity = LyricEntity(
      lyric: faker.lorem.sentences(30).join(" "),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );
  });

  testWidgets('Should load LyricPage with correct data',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.text(entity.artist), findsOneWidget);
    expect(find.text(entity.music), findsOneWidget);
    expect(find.text(entity.lyric), findsOneWidget);

    expect(find.byType(BackButton), findsOneWidget);
  });
}
