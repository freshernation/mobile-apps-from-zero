// Week 3, day 1 — Command. Run: flutter test test/week_03/day_1_test.dart
import 'package:flutter/foundation.dart';

import 'result.dart';

/// An action a screen can run — saving, loading, deleting — and its state.
///
/// A screen listens to it to show a spinner ([running]), an error ([error]),
/// or that it worked ([completed]). It tells its listeners when it starts and
/// when it finishes. Running it again while it is already running must not run
/// the action twice: return the run that is already in flight.
abstract class Command<T> extends ChangeNotifier {
  bool get running => throw UnimplementedError('Week 3, day 1: running');

  /// The last run ended in an Error.
  bool get error => throw UnimplementedError('Week 3, day 1: error');

  /// The last run ended in Ok.
  bool get completed => throw UnimplementedError('Week 3, day 1: completed');

  /// The last run's result, or null if it hasn't run (or was cleared).
  Result<T>? get result => throw UnimplementedError('Week 3, day 1: result');

  void clearResult() => throw UnimplementedError('Week 3, day 1: clearResult');
}

/// A [Command] whose action takes no argument.
class Command0<T> extends Command<T> {
  Command0(this._action);

  // ignore: unused_field
  final Future<Result<T>> Function() _action;

  Future<void> execute() => throw UnimplementedError('Week 3, day 1: execute');
}

/// A [Command] whose action takes one argument.
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  // ignore: unused_field
  final Future<Result<T>> Function(A) _action;

  Future<void> execute(A argument) =>
      throw UnimplementedError('Week 3, day 1: execute');
}
