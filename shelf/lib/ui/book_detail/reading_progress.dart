// Week 2, day 1 — a widget with state. Run: flutter test test/week_02/day_1_test.dart
import 'package:flutter/material.dart';

import '../../domain/models/book.dart';

/// A slider for how far through [book] you are.
///
/// The label ('Page 120 of 320') follows your finger while you drag;
/// [onPageChanged] is called once, when you let go. With no page count, it
/// shows 'Add a page count to track progress' instead.
///
/// Keys: 'progress-slider', 'progress-label', 'progress-unknown'.
class ReadingProgress extends StatefulWidget {
  const ReadingProgress({
    super.key,
    required this.book,
    required this.onPageChanged,
  });

  final Book book;
  final ValueChanged<int> onPageChanged;

  @override
  State<ReadingProgress> createState() => _ReadingProgressState();
}

class _ReadingProgressState extends State<ReadingProgress> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 2, day 1: ReadingProgress');
  }
}
