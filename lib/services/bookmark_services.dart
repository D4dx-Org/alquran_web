import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:get_storage/get_storage.dart';

class BookmarksServices {
  static const String BOOKMARKS_KEY = 'bookmarks';
  final _storage = GetStorage();

  Future<List<Bookmark>> getAllBookmarks() async {
    try {
      print('BookmarksServices: Attempting to read bookmarks from storage');
      final List<dynamic>? bookmarksData = _storage.read<List>(BOOKMARKS_KEY);
      print('BookmarksServices: Raw data from storage: $bookmarksData');

      if (bookmarksData == null) {
        print('BookmarksServices: No bookmarks found in storage');
        return [];
      }

      final bookmarks = bookmarksData
          .map((data) => Bookmark(
                bId: data['id'] as int,
                suraId: data['SuraId'] as int,
                ayaNo: data['AyaNo'] as int,
                suraName: data['SuraName'] as String,
              ))
          .toList();

      print(
          'BookmarksServices: Successfully loaded ${bookmarks.length} bookmarks');
      return bookmarks;
    } catch (e) {
      print('BookmarksServices: Error reading bookmarks: $e');
      return [];
    }
  }

  Future<int> createBookmark(Bookmark bmark) async {
    try {
      final bookmarks = await getAllBookmarks();
      final newId = bookmarks.isEmpty ? 1 : bookmarks.last.bId + 1;

      final newBookmark = Bookmark(
        bId: newId,
        suraId: bmark.suraId,
        ayaNo: bmark.ayaNo,
        suraName: bmark.suraName,
      );

      bookmarks.add(newBookmark);

      await _storage.write(
          BOOKMARKS_KEY,
          bookmarks
              .map((b) => {
                    'id': b.bId,
                    'SuraId': b.suraId,
                    'AyaNo': b.ayaNo,
                    'SuraName': b.suraName,
                  })
              .toList());

      return newId;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<int> deleteBookmark(int id) async {
    try {
      final bookmarks = await getAllBookmarks();
      bookmarks.removeWhere((b) => b.bId == id);

      await _storage.write(
          BOOKMARKS_KEY,
          bookmarks
              .map((b) => {
                    'id': b.bId,
                    'SuraId': b.suraId,
                    'AyaNo': b.ayaNo,
                    'SuraName': b.suraName,
                  })
              .toList());

      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteAllBookmarks() async {
    try {
      await _storage.write(BOOKMARKS_KEY, []);
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
