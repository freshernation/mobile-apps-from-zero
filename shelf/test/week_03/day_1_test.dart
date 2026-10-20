// Week 3, day 1 — the data layer. Run: flutter test test/week_03/day_1_test.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/data/repositories/book_repository_memory.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/utils/app_exceptions.dart';
import 'package:shelf_app/utils/command.dart';
import 'package:shelf_app/utils/result.dart';

void main() {
  group('Command', () {
    test('runs, then completes with Ok', () async {
      final finish = Completer<Result<int>>();
      final command = Command0<int>(() => finish.future);

      final run = command.execute();
      expect(command.running, isTrue);

      finish.complete(const Result.ok(42));
      await run;

      expect(command.running, isFalse);
      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect((command.result as Ok<int>).value, 42);
    });

    test('an Error result sets error, not completed', () async {
      final command = Command0<int>(() async => const Result.error(NetworkException()));

      await command.execute();

      expect(command.error, isTrue);
      expect(command.completed, isFalse);
    });

    test('a second execute while running does not run it twice', () async {
      var runs = 0;
      final finish = Completer<Result<void>>();
      final command = Command1<void, String>((_) {
        runs++;
        return finish.future;
      });

      final first = command.execute('a');
      final second = command.execute('b');
      finish.complete(const Result.ok(null));
      await Future.wait([first, second]);

      expect(runs, 1);
    });

    test('a second execute while running waits for the first run', () async {
      final finish = Completer<Result<int>>();
      final command = Command0<int>(() => finish.future);

      unawaited(command.execute());
      var secondDone = false;
      final second = command.execute().then((_) => secondDone = true);
      await Future<void>.delayed(Duration.zero);
      expect(secondDone, isFalse);

      finish.complete(const Result.ok(7));
      await second;
      expect(command.completed, isTrue);
    });

    test('tells its listeners when it starts and when it finishes', () async {
      final command = Command0<int>(() async => const Result.ok(1));
      var told = 0;
      command.addListener(() => told++);

      await command.execute();

      expect(told, 2);
    });

    test('clearResult forgets the last result', () async {
      final command = Command0<int>(() async => const Result.error(NetworkException()));
      await command.execute();

      command.clearResult();

      expect(command.result, isNull);
      expect(command.error, isFalse);
    });

    test('Command1 passes its argument through', () async {
      final command = Command1<String, int>((n) async => Result.ok('got $n'));

      await command.execute(3);

      expect((command.result as Ok<String>).value, 'got 3');
    });
  });

  group('InMemoryBookRepository', () {
    const dune = Book(id: '1', title: 'Dune');
    const emma = Book(id: '2', title: 'Emma');

    T ok<T>(Result<T> result) => (result as Ok<T>).value;
    Exception err<T>(Result<T> result) => (result as Error<T>).error;

    test('starts with the books it is given', () async {
      final repo = InMemoryBookRepository(initial: [dune, emma]);

      expect(ok(await repo.getBooks()), [dune, emma]);
    });

    test('starts empty by default', () async {
      expect(ok(await InMemoryBookRepository().getBooks()), isEmpty);
    });

    test('addBook adds it', () async {
      final repo = InMemoryBookRepository();

      expect(ok(await repo.addBook(dune)), dune);
      expect(ok(await repo.getBooks()), [dune]);
    });

    test('updateBook replaces the book with the same id', () async {
      final repo = InMemoryBookRepository(initial: [dune, emma]);
      final moved = dune.copyWith(status: ShelfStatus.done);

      expect(ok(await repo.updateBook(moved)), moved);
      expect(ok(await repo.getBooks()), [moved, emma]);
    });

    test('updateBook of an unknown id is NotFoundException', () async {
      final repo = InMemoryBookRepository(initial: [dune]);

      expect(err(await repo.updateBook(emma)), isA<NotFoundException>());
    });

    test('deleteBook removes it', () async {
      final repo = InMemoryBookRepository(initial: [dune, emma]);

      expect(await repo.deleteBook('1'), isA<Ok<void>>());
      expect(ok(await repo.getBooks()), [emma]);
    });

    test('deleteBook of an unknown id is NotFoundException', () async {
      final repo = InMemoryBookRepository(initial: [dune]);

      expect(err(await repo.deleteBook('9')), isA<NotFoundException>());
    });

    test('getBooks hands out a copy, not its own list', () async {
      final repo = InMemoryBookRepository(initial: [dune]);

      ok(await repo.getBooks()).clear();

      expect(ok(await repo.getBooks()), [dune]);
    });

    test('the list it was given is not changed', () async {
      final initial = [dune];
      final repo = InMemoryBookRepository(initial: initial);

      await repo.addBook(emma);

      expect(initial, [dune]);
    });
  });
}
