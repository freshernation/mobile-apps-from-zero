// Week 3, day 3 — the search screen. Ignore it until then.
import 'package:flutter/material.dart';

import 'search_view_model.dart';

/// Search Open Library and add books to your shelf.
///
/// 'search-field': type and submit to search. While searching, a progress
/// indicator. On failure, 'search-error' with a 'retry' button. No results:
/// 'No books match' ('search-empty'). Each result is a row keyed
/// `'result-$id'` with an add button `'add-$id'`, which becomes a check
/// icon once the book is on your shelf.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.viewModel});

  final SearchViewModel viewModel;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Week 3, day 3: SearchScreen');
  }
}
