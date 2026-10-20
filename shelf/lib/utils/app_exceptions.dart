// Week 3 — the errors Shelf's data layer returns inside a Result.

/// The record does not exist.
class NotFoundException implements Exception {
  const NotFoundException();

  @override
  String toString() => 'NotFoundException';
}

/// The server could not be reached, or answered with something unusable.
class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'NetworkException';
}
