# Day 3 — A real server: HTTP and JSON

> **By the end of today** you can search millions of real books from inside Shelf and
> add any of them to your shelf with one tap. When there's no signal, the app says
> so instead of hanging or crashing.

Until now every book came from your own code. Today Shelf talks to
[Open Library](https://openlibrary.org): a free, open catalogue with an API that
needs no account and no key. Week 1's `SampleBookSource` was a stand-in for exactly
this, so the shape of the code (a `Future`, a slow answer, something that can fail)
is already familiar. What's new is the network, and the network is where things go
wrong.

---

## Read first

- [ ] [Fetch data from the internet](https://docs.flutter.dev/cookbook/networking/fetch-data) · 15 min
- [ ] [JSON and serialization](https://docs.flutter.dev/data-and-backend/serialization/json): *Serializing JSON manually using dart:convert* only · 10 min
- [ ] [Open Library Search API](https://openlibrary.org/dev/docs/api/search): skim, and open the example URLs in your browser · 10 min

---

## What you need to know

### Look at the real thing first

Before writing any code, open this in your browser:

```
https://openlibrary.org/search.json?q=dune&limit=2&fields=key,title,author_name,number_of_pages_median,cover_i
```

```json
{"numFound": 48318, "docs": [
  {"author_name": ["Frank Herbert"], "cover_i": 11481354,
   "key": "/works/OL893414W", "number_of_pages_median": 608, "title": "Dune"},
  ...
]}
```

That's your input. Every field except `key` and `title` can be missing. Search for
something obscure and you'll see docs with no authors and no page count.
`fields=` asks for only what we use, which is faster for you and kinder to a free
service.

### A service talks to the outside world

```dart
class OpenLibraryService {
  OpenLibraryService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Result<List<Book>>> search(String query) async {
    final url = Uri.https('openlibrary.org', '/search.json', {
      'q': query.trim(), 'limit': '20', 'fields': '...',
    });
    final response = await _client.get(url, headers: {'User-Agent': '...'});
    ...
  }
}
```

In the architecture you're building, a **service** wraps one outside thing (an API,
the database) and a **repository** is what the app asks for data. Shelf's search is
simple enough that the view model calls the service directly. The template in week 4
always goes through a repository.

`Uri.https(host, path, query)` builds the URL and escapes the query for you. Never
glue URLs together with `+`: a search for `"war & peace"` breaks a hand-made URL.

Open Library asks apps to send a `User-Agent` saying who they are. It's polite, and
it's how a free API can contact you instead of blocking you.

### Everything that can go wrong becomes one `Error`

```dart
try {
  final response = await _client.get(url, headers: ...).timeout(const Duration(seconds: 10));
  if (response.statusCode != 200) return const Result.error(NetworkException());
  final json = jsonDecode(response.body) as Map<String, Object?>;
  ...
} on SocketException {          // no connection
  return const Result.error(NetworkException());
} on FormatException {          // not JSON at all: a café wifi login page, say
  return const Result.error(NetworkException());
}
```

List what you've seen go wrong: no signal, the server is down (`500`, `503`), a
login page instead of JSON, a reply that never comes. Each one is a branch. The
screen above doesn't care which: it shows "couldn't reach Open Library" and a retry
button. `.timeout` matters more than it looks. Without it, a phone on a bad network
can wait minutes.

### Parsing someone else's JSON

```dart
factory Book.fromOpenLibrary(Map<String, Object?> doc) {
  final cover = doc['cover_i'] as int?;
  return Book(
    id: (doc['key']! as String).replaceFirst('/works/', ''),
    title: doc['title']! as String,
    authors: [...?(doc['author_name'] as List?)?.cast<String>()],
    pageCount: doc['number_of_pages_median'] as int?,
    coverUrl: cover == null ? null : 'https://covers.openlibrary.org/b/id/$cover-M.jpg',
  );
}
```

This is week 1's `fromJson` again, but now the data isn't yours, so every optional
field gets `as T?` and a sensible default. Day 2's null safety is what makes this
safe: the compiler won't let you use `pageCount` as an `int` without handling null.

### Testing without the internet: `MockClient`

```dart
final service = OpenLibraryService(
  client: MockClient((request) async => http.Response('{"docs": []}', 200)),
);
```

This is why the constructor takes an `http.Client`. Tests pass a fake that answers
instantly, with exactly the reply (or the failure) the test wants. Tests that hit the
real network are slow, flaky, and fail on a plane. None of Shelf's tests touch the
real internet.

### The search view model, and adding without duplicates

`SearchViewModel` holds the results and two Commands: `search` and `addToShelf`.
Adding asks the `ShelfViewModel` you already have, so nothing new about saving books
is invented here. One rule: a book already on your shelf can't be added again. The
button turns into a check, and adding again does nothing.

Each time the search page opens it gets its **own** `SearchViewModel`, created once
and thrown away when you leave. The `/search` route in `app.dart` does this with a
`ChangeNotifierProvider(create: ...)` inside the route builder. Creating it directly in
the builder would make a new one every time the router rebuilds, and the screen would
keep listening to an old one. It's a real bug worth knowing by name, and the template
handles it the same way.

---

## Exercises

1. `Book.fromOpenLibrary` in `lib/domain/models/book.dart`.
2. `OpenLibraryService.search` in `lib/data/services/open_library_service.dart`.
3. `SearchViewModel` and `SearchScreen` in `lib/ui/search/`.
4. In `app.dart`, add the `/search` route (with its own `ChangeNotifierProvider`), and
   pass `onSearch: () => context.push(Routes.search)` to `ShelfScreen`.

```bash
cd shelf
flutter test test/week_03/day_3_test.dart
```

5. **On a device:** search, add a book, see it on Want to read. Then turn on airplane
   mode and search again. You should see your error and retry button, not a spinner
   forever and not a crash.

---

## Before tomorrow

- [ ] Everything green.
- [ ] **Ship log:** a recording of a real search and add, and a screenshot of the
      airplane-mode error.
- [ ] Signal log. In "hardest thing", list every way a request can fail that you
      handled today.
