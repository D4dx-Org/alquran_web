import 'package:alquran_malayalam/models/article.dart';
import 'package:alquran_malayalam/services/api_service/quran_service.dart';

class ArticlesServices {
  final QuranService _quranService = QuranService();

  Future<Article?> getArticle(int articleId) async {
    try {
      final matters = await _quranService.fetchAbout();
      if (matters.isEmpty) return null;

      return Article(
        aId: articleId,
        matter: matters.first,
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}
