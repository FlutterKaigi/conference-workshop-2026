/// ホームページ。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/model/view_model_packages.dart';
import '../../../presentation/ui_widget/widget_packages.dart';
import '../../../routing/app_router.dart';

/// ホームページ。
///
/// 書籍一覧と、読書応援・読書進捗のアニメーションを重ね合わせた UI。
class HomePage extends ConsumerWidget {
  /// コンストラクタ。
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読書進捗応援'),
        actions: <Widget>[
          IconButton(
            tooltip: '設定',
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.goSettings();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          CurrentlyTasksWidget(
            provider: (WidgetRef ref) => ref.watch(readingBooksProvider),
          ),
          ReadingSupportAnimationsWidget(
            provider: (WidgetRef ref) =>
                ref.watch(readingSupportAnimationsProvider),
          ),
          ReadingProgressAnimationsWidget(
            provider: (WidgetRef ref) =>
                ref.watch(readingProgressAnimationsProvider),
          ),
        ],
      ),
    );
  }
}
