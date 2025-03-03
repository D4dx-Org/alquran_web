import 'package:alquran_malayalam/models/bookmark.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/routes/routes.dart';
import 'package:alquran_malayalam/services/bookmark_services.dart';
import 'package:alquran_malayalam/widgets/delete_dialog.dart';

class BookmarksController extends GetxController {
  BookmarksServices bookmarksServices = BookmarksServices();
  RxList<Bookmark> bookmarks = <Bookmark>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    print('BookmarksController: onInit called');
    super.onInit();
    loadDB();
    // Listen to changes in bookmarks list
    ever(bookmarks, (_) {
      print(
          'BookmarksController: Bookmarks list updated, length: ${bookmarks.length}');
    });
  }

  loadDB() async {
    print('BookmarksController: loadDB called');
    await loadBookmarks(1);
  }

  Future<void> loadBookmarks(int bkTypeNo) async {
    try {
      print('BookmarksController: Starting to load bookmarks');
      isLoading.value = true;
      List<Bookmark> list = await bookmarksServices.getAllBookmarks();
      print(
          'BookmarksController: Retrieved ${list.length} bookmarks from storage');

      bookmarks.value = list;
      print(
          'BookmarksController: Successfully loaded ${bookmarks.length} bookmarks');
    } catch (e) {
      print('BookmarksController: Error loading bookmarks: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> removeBookmark(int bid) async {
    try {
      await bookmarksServices.deleteBookmark(bid);
      bookmarks.removeWhere((bookmark) => bookmark.bId == bid);
      update();
    } catch (e) {
      print('BookmarksController: Error removing bookmark: $e');
    }
  }

  Future<void> removeAllBookmarks() async {
    if (bookmarks.isEmpty) return;

    DeleteDialog deleteDialog = DeleteDialog(
        deleteMessage: "Are you sure want to delete all Bookmarks?",
        onDeletePressed: () async {
          try {
            Get.back();
            await bookmarksServices.deleteAllBookmarks();
            bookmarks.clear();
            Get.snackbar('Bookmarks Deleted!', 'No more Bookmarks !!',
                snackPosition: SnackPosition.BOTTOM);
            update();
          } catch (e) {
            print('BookmarksController: Error removing all bookmarks: $e');
          }
        });
    deleteDialog.showDeleteDialog();
  }

  showSuraTranLines(Bookmark cbkMark) async {
    int suraId = cbkMark.suraId;
    int ayaNo = cbkMark.ayaNo;

    await Get.offNamed(AppRoutes.TRANLISTING,
        arguments: [suraId, ayaNo], preventDuplicates: false);
  }
}
