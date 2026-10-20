// Week 1, day 4 — your first screen. Run: flutter test test/week_01/day_4_test.dart
import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// Everything about one book.
///
/// Build it from the widgets in today's lesson. The tests find each piece by
/// its Key — 'book-title', 'book-authors', 'book-pages', 'book-status',
/// and 'cover-placeholder' or 'cover-image'.
class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 1, day 4: BookDetailScreen');
  }
}
