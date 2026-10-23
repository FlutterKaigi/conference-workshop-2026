import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/widget_packages.dart';
import 'package:conference_handson_2025/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 書籍登録・編集画面。
class ReadingBookPage extends ConsumerWidget {
  /// コンストラクタ。
  const ReadingBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReadingBookEditMode mode =
        ref.watch(readingBooksProvider.notifier).currentEditMode;
    final String title =
        mode == ReadingBookEditMode.create ? '書籍の新規登録' : '書籍情報の編集';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: 'グラフ',
            onPressed: () => context.goReadingGraph(),
          ),
        ],
      ),
      body: ReadingBookWidget(
        provider: (ref) =>
            ref.watch(readingBooksProvider.notifier).currentEditReadingBook!,
      ),
    );
  }
}
