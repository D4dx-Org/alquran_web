import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:get_storage/get_storage.dart';

class BookmarksServices {
  static const String BOOKMARKS_KEY = 'bookmarks';
  final _storage = GetStorage();

  Future<List<Bookmark>> getAllBookmarks() async {
    try {
      final List<dynamic> bookmarksData =
          _storage.read<List>(BOOKMARKS_KEY) ?? [];
      return bookmarksData
          .map((data) => Bookmark(
                bId: data['id'],
                suraId: data['SuraId'],
                ayaNo: data['AyaNo'],
                suraName: data['SuraName'],
              ))
          .toList();
    } catch (e) {
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
