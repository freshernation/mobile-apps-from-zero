// Week 1, day 4 — your first screen. Run: flutter test test/week_01/day_4_test.dart
import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// Everything about one book.
///
/// Build it from the widgets in today's lesson. The tests find each piece by
/// its Key — put each Key on the Text (or Chip, or Image) itself:
///   'book-title'    the title
///   'book-authors'  `book.authorLine`
///   'book-pages'    '412 pages', or 'Page count unknown' when there is none
///   'book-status'   a Chip with `book.status.label`
///   'cover-placeholder' (an Icon) or 'cover-image' (an Image.network)
///
/// Week 2, day 1 adds: a shelf picker keyed 'status-picker' (shown when
/// [onStatusChanged] is given) and a delete IconButton in the app bar keyed
/// 'delete-book' (shown when [onDelete] is given).
class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    super.key,
    required this.book,
    this.onPageChanged,
    this.onStatusChanged,
    this.onDelete,
  });

  final Book book;

  // Week 2, day 1 — ignore these three until then.

  /// Called with the new page when the reader moves the progress slider.
  final ValueChanged<int>? onPageChanged;

  /// Called when the reader picks a different shelf.
  final ValueChanged<ShelfStatus>? onStatusChanged;

  /// Called when the reader taps delete.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 1, day 4: BookDetailScreen');
  }
}
