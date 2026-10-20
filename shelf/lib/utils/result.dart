// Week 3, day 1 — read this file then; ignore it until then.

/// The outcome of something that can fail: [Ok] with a value, or [Error]
/// with the exception. Return one instead of throwing, and the compiler makes
/// the caller handle both (a `switch` on a sealed class must cover every case).
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;

  const factory Result.error(Exception error) = Error<T>;
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
