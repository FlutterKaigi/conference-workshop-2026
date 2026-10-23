/// アプリケーションの GoRouter ルーティング定義。
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/screen/home/home_page.dart';
import '../app/screen/reading_book/reading_book_page.dart';
import '../app/screen/reading_graph/reading_book_graph_page.dart';
import '../app/screen/settings/settings_page.dart';

/// 名前付きルートのパス定義。
enum AppRoutes {
  /// ホームページ。
  home('/'),

  /// 設定ページ。
  settings('/settings'),

  /// 書籍編集ページ。
  readingBook('/reading_book'),

  /// 書籍グラフページ。
  readingGraph('/reading_book/graph');

  /// ルートのパス。
  const AppRoutes(this.path);

  /// ルートのパス。
  final String path;
}

/// アプリケーションの GoRouter 定義。
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.settings.path,
          name: AppRoutes.settings.name,
          builder: (BuildContext context, GoRouterState state) =>
              const SettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.readingBook.path,
          name: AppRoutes.readingBook.name,
          builder: (BuildContext context, GoRouterState state) =>
              const ReadingBookPage(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.readingGraph.path,
              name: AppRoutes.readingGraph.name,
              builder: (BuildContext context, GoRouterState state) =>
                  const ReadingBookGraphPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Text('Page not found: ${state.error}'),
    );
  },
);

/// [AppRoutes] 用の [BuildContext] 拡張。
extension AppRouterExtension on BuildContext {
  /// 設定ページへ遷移する。
  void goSettings() {
    goNamed(AppRoutes.settings.name);
  }

  /// 書籍編集ページへ遷移する。
  void goReadingBook() {
    goNamed(AppRoutes.readingBook.name);
  }

  /// 書籍グラフページへ遷移する。
  void goReadingGraph() {
    goNamed(AppRoutes.readingGraph.name);
  }
}
