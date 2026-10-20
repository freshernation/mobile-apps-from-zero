// Week 2, day 3 — forms. Run: flutter test test/week_02/day_3_test.dart
import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// A form for adding a book by hand.
///
/// Fields: 'title-field' (required), 'author-field' (required; commas
/// separate several authors), 'pages-field' (optional; if filled, a whole
/// number above 0). Errors: 'Required', 'Enter a whole number above 0'.
///
/// 'save-book' validates, then calls [onAdd] with a new Book on Want to read,
/// id `DateTime.now().microsecondsSinceEpoch.toString()`.
class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key, required this.onAdd});

  final ValueChanged<Book> onAdd;

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 2, day 3: AddBookScreen');
  }
}
