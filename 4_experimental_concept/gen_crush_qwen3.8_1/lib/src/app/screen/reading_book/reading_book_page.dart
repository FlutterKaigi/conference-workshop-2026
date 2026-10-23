/// 書籍編集ページ。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/model/view_model_packages.dart';
import '../../../presentation/ui_widget/widget_packages.dart';
import '../../../routing/app_router.dart';

/// 書籍編集ページ。
///
/// 編集モードに応じて AppBar のタイトルが変わる。
class ReadingBookPage extends ConsumerWidget {
  /// コンストラクタ。
  const ReadingBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCreate =
        ref.read(readingBooksProvider.notifier).currentEditMode.name ==
        'create';
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? '書籍の新規登録' : '書籍情報の編集'),
        actions: <Widget>[
          IconButton(
            tooltip: 'グラフ',
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              context.goReadingGraph();
            },
          ),
        ],
      ),
      body: ReadingBookWidget(
        provider: (WidgetRef ref) {
          return ref
              .watch(readingBooksProvider.notifier)
              .currentEditReadingBook!;
        },
      ),
    );
  }
}
