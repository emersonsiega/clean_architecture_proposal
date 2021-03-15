import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';

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
    expect(
      find.byKey(Key("favoriteButton")),
      findsOneWidget,
    );
  });
}
