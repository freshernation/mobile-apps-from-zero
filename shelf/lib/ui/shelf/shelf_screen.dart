// Week 2, day 2 — lists. Run: flutter test test/week_02/day_2_test.dart
import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// Your books, one shelf at a time.
///
/// A SegmentedButton ('status-filter') picks the shelf, starting on Reading.
/// Each book is a row keyed `'book-$id'` showing its title and authors, with a
/// LinearProgressIndicator for books being read. An empty shelf shows
/// 'Nothing on this shelf yet.' ('empty-shelf').
///
/// [onAdd] and [onSearch] are optional: when given, show a floating add button
/// ('add-book') and a search button in the app bar ('open-search').
class ShelfScreen extends StatefulWidget {
  const ShelfScreen({
    super.key,
    required this.books,
    required this.onBookTap,
    this.onAdd,
    this.onSearch,
  });

  final List<Book> books;
  final ValueChanged<Book> onBookTap;
  final VoidCallback? onAdd;
  final VoidCallback? onSearch;

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 2, day 2: ShelfScreen');
  }
}
