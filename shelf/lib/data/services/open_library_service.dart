// Week 3, day 3 — searching a real API. Ignore it until then.
import 'package:http/http.dart' as http;

import '../../domain/models/book.dart';
import '../../utils/result.dart';

/// Searches openlibrary.org. Free, no key needed.
///
/// GET https://openlibrary.org/search.json
///   ?q=QUERY&limit=20&fields=key,title,author_name,number_of_pages_median,cover_i
/// with the header `User-Agent: ShelfApp/1.0 (course project)`.
///
/// A blank query is `Ok([])` without a request. A non-200 answer, no
/// connection, or a reply that is not the JSON you expect is a
/// `NetworkException`.
class OpenLibraryService {
  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();

  // ignore: unused_field
  final http.Client _client;

  Future<Result<List<Book>>> search(String query) async {
    throw UnimplementedError('Week 3, day 3: search');
  }
}
