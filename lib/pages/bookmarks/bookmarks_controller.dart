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
  }

  loadDB() async {
    print('BookmarksController: loadDB called');
    loadBookmarks(1);
  }

  loadBookmarks(int bkTypeNo) async {
    try {
      print('BookmarksController: Starting to load bookmarks');
      isLoading.value = true;
      bookmarks.value = [];
      List<Bookmark> list = await bookmarksServices.getAllBookmarks();
      print(
          'BookmarksController: Retrieved ${list.length} bookmarks from storage');

      bookmarks.value = list;
      print(
          'BookmarksController: Successfully loaded ${bookmarks.length} bookmarks');

      isLoading.value = false;
    } catch (e) {
      print('BookmarksController: Error loading bookmarks: $e');
      isLoading.value = false;
    }
  }

  removeBookmark(int bid) {
    bookmarks.removeWhere((bookmark) => bookmark.bId == bid);
    bookmarksServices.deleteBookmark(bid);
    update();
  }

  removeAllBookmarks() {
    if (bookmarks.isEmpty) return;
    DeleteDialog deleteDialog = DeleteDialog(
        deleteMessage: "Are you sure want to delete all Bookmarks?",
        onDeletePressed: () async {
          Get.back();
          bookmarks.removeRange(0, bookmarks.length);
          bookmarksServices.deleteAllBookmarks();
          Get.snackbar('Bookmarks Deleted!', 'No more Bookmarks !!',
              snackPosition: SnackPosition.BOTTOM);

          update();
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
