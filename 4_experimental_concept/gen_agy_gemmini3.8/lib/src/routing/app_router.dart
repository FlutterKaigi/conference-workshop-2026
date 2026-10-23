import 'package:conference_handson_2025/src/app/screen/home_page.dart';
import 'package:conference_handson_2025/src/app/screen/reading_book_graph_page.dart';
import 'package:conference_handson_2025/src/app/screen/reading_book_page.dart';
import 'package:conference_handson_2025/src/app/screen/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ルーティング先を定義する列挙型。
enum AppRoutes {
  /// ホーム
  home('/'),

  /// 設定
  settings('/settings'),

  /// 書籍編集
  readingBook('/reading_book'),

  /// 読書進捗グラフ
  readingGraph('/reading_book/graph');

  /// コンストラクタ。
  const AppRoutes(this.path);

  /// パス。
  final String path;
}

/// アプリ全体のルーター。
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.settings.path,
          name: AppRoutes.settings.name,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.readingBook.path,
          name: AppRoutes.readingBook.name,
          builder: (context, state) => const ReadingBookPage(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.readingGraph.path,
              name: AppRoutes.readingGraph.name,
              builder: (context, state) => const ReadingBookGraphPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);

/// ルーティング拡張。
extension AppRouterExtension on BuildContext {
  /// 設定画面へ遷移する。
  void goSettings() => goNamed(AppRoutes.settings.name);

  /// 書籍編集画面へ遷移する。
  void goReadingBook() => goNamed(AppRoutes.readingBook.name);

  /// 読書進捗グラフ画面へ遷移する。
  void goReadingGraph() => goNamed(AppRoutes.readingGraph.name);
}
