// Week 3, day 3 — searching Open Library. Ignore it until then.
import 'package:flutter/foundation.dart';

import '../../data/services/open_library_service.dart';
import '../../domain/models/book.dart';
import '../../utils/command.dart';
import '../shelf/shelf_view_model.dart';

/// Searches Open Library, and adds results to your shelf.
///
/// [search] fills [results]. [addToShelf] adds a result on Want to read —
/// and does nothing if that book is already on the shelf.
class SearchViewModel extends ChangeNotifier {
  SearchViewModel({
    required OpenLibraryService service,
    required ShelfViewModel shelf,
  });

  List<Book> get results => throw UnimplementedError('Week 3, day 3: results');

  bool isOnShelf(String id) =>
      throw UnimplementedError('Week 3, day 3: isOnShelf');

  Command1<void, String> get search =>
      throw UnimplementedError('Week 3, day 3: search');

  Command1<void, Book> get addToShelf =>
      throw UnimplementedError('Week 3, day 3: addToShelf');
}
