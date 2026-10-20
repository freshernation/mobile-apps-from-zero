// Week 1, day 3 — async. Run: flutter test test/week_01/day_3_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/data/sample_books.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/exercises/day_3.dart';

void main() {
  final source = SampleBookSource(delay: Duration.zero);

  group('sampleBooks', () {
    test('has one book on each shelf, and one with no page count', () {
      expect(sampleBooks.map((b) => b.status).toSet(), ShelfStatus.values.toSet());
      expect(sampleBooks.where((b) => b.pageCount == null), hasLength(1));
    });
  });

  group('SampleBookSource.search', () {
    test('matches the title, ignoring case', () async {
      final results = await source.search('DUNE');
      expect(results.map((b) => b.title), ['Dune']);
    });

    test('matches an author', () async {
      final results = await source.search('morrison');
      expect(results.map((b) => b.title), ['Beloved']);
    });

    test('a blank query finds nothing', () async {
      expect(await source.search('   '), isEmpty);
    });

    test('no match finds nothing', () async {
      expect(await source.search('zzz'), isEmpty);
    });

    test('waits for the delay before answering', () async {
      final slow = SampleBookSource(delay: const Duration(milliseconds: 50));
      final watch = Stopwatch()..start();
      await slow.search('dune');
      expect(watch.elapsedMilliseconds, greaterThanOrEqualTo(45));
    });
  });

  group('SampleBookSource.byId', () {
    test('finds a book', () async {
      expect((await source.byId('1')).title, 'Dune');
    });

    test('an unknown id throws BookNotFoundException', () async {
      await expectLater(
        source.byId('nope'),
        throwsA(isA<BookNotFoundException>().having((e) => e.id, 'id', 'nope')),
      );
    });
  });

  group('firstTitleOrMessage', () {
    test('gives the first title', () async {
      expect(await firstTitleOrMessage(source, 'dune'), 'Dune');
    });

    test('says when nothing is found', () async {
      expect(await firstTitleOrMessage(source, 'zzz'), 'No books found');
    });
  });

  group('titleOrError', () {
    test('gives the title', () async {
      expect(await titleOrError(source, '2'), 'Beloved');
    });

    test('catches the not-found error', () async {
      expect(await titleOrError(source, 'x9'), 'No book with id x9');
    });
  });

  group('countdown', () {
    test('counts down to 1, then finishes', () async {
      expect(await countdown(3, every: Duration.zero).toList(), [3, 2, 1]);
    });

    test('from 0 emits nothing', () async {
      expect(await countdown(0, every: Duration.zero).toList(), isEmpty);
    });
  });
}
