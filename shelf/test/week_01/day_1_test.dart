// Week 1, day 1 — Dart basics. Run: flutter test test/week_01/day_1_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/exercises/day_1.dart';

void main() {
  group('greet', () {
    test('greets by name', () {
      expect(greet('Ada'), 'Hello, Ada!');
    });

    test('trims spaces around the name', () {
      expect(greet('  Ada '), 'Hello, Ada!');
    });

    test('a blank name greets the reader', () {
      expect(greet(''), 'Hello, reader!');
      expect(greet('   '), 'Hello, reader!');
    });
  });

  group('totalPages', () {
    test('adds the page counts', () {
      expect(totalPages([320, 180, 500]), 1000);
    });

    test('an empty list is 0 pages', () {
      expect(totalPages([]), 0);
    });
  });

  group('averagePages', () {
    test('is the mean', () {
      expect(averagePages([100, 200, 600]), 300);
    });

    test('can be a fraction', () {
      expect(averagePages([1, 2]), 1.5);
    });

    test('an empty list averages 0, not a crash', () {
      expect(averagePages([]), 0);
    });
  });

  group('longTitles', () {
    test('keeps titles at least minLength long, in order', () {
      expect(
        longTitles(['Dune', 'Middlemarch', 'Emma', 'Beloved'], 7),
        ['Middlemarch', 'Beloved'],
      );
    });

    test('nothing long enough gives an empty list', () {
      expect(longTitles(['Dune'], 10), isEmpty);
    });
  });

  group('booksPerAuthor', () {
    test('counts each author', () {
      expect(
        booksPerAuthor(['Austen', 'Eliot', 'Austen', 'Morrison', 'Austen']),
        {'Austen': 3, 'Eliot': 1, 'Morrison': 1},
      );
    });

    test('no authors gives an empty map', () {
      expect(booksPerAuthor([]), isEmpty);
    });
  });

  group('hoursToRead', () {
    test('rounds up to whole hours', () {
      expect(hoursToRead(100), 3); // 2.5 hours at 40 pages an hour
    });

    test('an exact fit does not round up', () {
      expect(hoursToRead(80), 2);
    });

    test('uses the reading speed you give it', () {
      expect(hoursToRead(100, pagesPerHour: 50), 2);
    });

    test('0 pages takes 0 hours', () {
      expect(hoursToRead(0), 0);
    });
  });
}
