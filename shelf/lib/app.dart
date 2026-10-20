// Week 2, day 4 — the app: who owns the books, and how screens connect.
// Run: flutter test test/week_02/day_4_test.dart
import 'package:flutter/material.dart';

import 'data/repositories/book_repository.dart';
import 'data/services/open_library_service.dart';

/// Shelf. Owns the list of books (starting with `sampleBooks`), and connects
/// the screens with go_router:
///
///   /           ShelfScreen        tap a book → /book/:id, + → /add
///   /add        AddBookScreen      saving goes back to /
///   /book/:id   BookDetailScreen   changes update the book; delete goes back
///               — or 'Book not found' (key 'book-not-found') for an unknown id
///
/// Light and dark themes come from `shelfTheme`.
class ShelfApp extends StatefulWidget {
  const ShelfApp({super.key, this.repository, this.search});

  // Week 3 — ignore these two until then.
  final BookRepository? repository;
  final OpenLibraryService? search;

  @override
  State<ShelfApp> createState() => _ShelfAppState();
}

class _ShelfAppState extends State<ShelfApp> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 2, day 4: ShelfApp');
  }
}
