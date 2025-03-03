import 'package:alquran_malayalam/pages/articles/articles_binding.dart';
import 'package:alquran_malayalam/pages/articles/articles_page.dart';
import 'package:alquran_malayalam/pages/bookmarks/bookmarks_binding.dart';
import 'package:alquran_malayalam/pages/bookmarks/bookmarks_page.dart';
import 'package:alquran_malayalam/pages/info.dart';
import 'package:alquran_malayalam/pages/mushaf/mushaf_bindings.dart';
import 'package:alquran_malayalam/pages/mushaf/mushaf_page.dart';
import 'package:alquran_malayalam/pages/searchres/searchres_binding.dart';
import 'package:alquran_malayalam/pages/searchres/searchres_page.dart';
import 'package:alquran_malayalam/pages/settings/settings_binding.dart';
import 'package:alquran_malayalam/pages/settings/settings_page.dart';
import 'package:alquran_malayalam/pages/splash/splash_binding.dart';
import 'package:alquran_malayalam/pages/splash/splash_screen.dart';
import 'package:get/get.dart';

import 'package:alquran_malayalam/pages/index/index_binding.dart';
import 'package:alquran_malayalam/pages/index/index_page.dart';
import 'package:alquran_malayalam/pages/tranlisting/tranlisting_binding.dart';
import 'package:alquran_malayalam/pages/tranlisting/tranlisting_page.dart';

abstract class AppRoutes {
  static const HOME = '/';
  static const SPLASH = '/splash';
  static const TRANLISTING = "/tranlisting/:surano/:ayano";
  static const ARTICLE = "/article/:aid";
  static const INFO = "/info";
  static const BOOKMARKS = "/bookmarks";
  static const SETTINGS = "/settings";
  static const SEARCHRES = "/search/:schtxt";
  static const MUSHAF = "/mushaf";
}

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => IndexPage(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: AppRoutes.TRANLISTING,
      page: () => TranListingPage(),
      binding: TranListingBinding(),
    ),
    GetPage(
      name: AppRoutes.ARTICLE,
      page: () => ArticlesPage(),
      binding: ArticlesBinding(),
    ),
    GetPage(
      name: AppRoutes.INFO,
      page: () => InfoPage(),
    ),
    GetPage(
      name: AppRoutes.BOOKMARKS,
      page: () => BookmarksPage(),
      binding: BookmarksBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCHRES,
      page: () => SearchResPage(),
      binding: SearchResBinding(),
    ),
    GetPage(
      name: AppRoutes.MUSHAF,
      page: () => MushafPage(),
      binding: MushafBindings(),
    )
  ];
}
