// Week 2, day 4 — every path in the app, in one place.

abstract final class Routes {
  static const home = '/';
  static const add = '/add';
  static const search = '/search';

  static String book(String id) => '/book/$id';
}
