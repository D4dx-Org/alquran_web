import 'dart:convert';
import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksServices {
  static const String BOOKMARKS_KEY = 'bookmarks';

  Future<List<Bookmark>> getAllBookmarks() async {
    try {
      print(
          'BookmarksServices: Attempting to read bookmarks from SharedPreferences');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? bookmarksDataString = prefs.getString(BOOKMARKS_KEY);
      print(
          'BookmarksServices: Raw data from SharedPreferences: $bookmarksDataString');

      if (bookmarksDataString == null) {
        print('BookmarksServices: No bookmarks found in SharedPreferences');
        return [];
      }

      final List<dynamic> bookmarksData = jsonDecode(bookmarksDataString);

      final bookmarks = bookmarksData
          .map((data) => Bookmark.fromMap({
                'id': data['id'],
                'SuraId': data['SuraId'],
                'AyaNo': data['AyaNo'],
                'SuraName': data['SuraName'],
              }))
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

      await _saveBookmarks(bookmarks);

      return newId;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<int> deleteBookmark(int id) async {
    try {
      final bookmarks = await getAllBookmarks();
      bookmarks.removeWhere((b) => b.bId == id);

      await _saveBookmarks(bookmarks);

      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteAllBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(BOOKMARKS_KEY, jsonEncode([]));
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> isBookmarked(int suraId, int ayaNo) async {
    try {
      final bookmarks = await getAllBookmarks();
      return bookmarks.any((b) => b.suraId == suraId && b.ayaNo == ayaNo);
    } catch (e) {
      print('BookmarksServices: Error checking bookmark status: $e');
      return false;
    }
  }

  Future<void> _saveBookmarks(List<Bookmark> bookmarks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> bookmarksMap = bookmarks
        .map((b) => {
              'id': b.bId,
              'SuraId': b.suraId,
              'AyaNo': b.ayaNo,
              'SuraName': b.suraName,
            })
        .toList();
    await prefs.setString(BOOKMARKS_KEY, jsonEncode(bookmarksMap));
  }
}
