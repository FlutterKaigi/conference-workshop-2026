import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/widget_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗グラフ画面。
class ReadingBookGraphPage extends ConsumerWidget {
  /// コンストラクタ。
  const ReadingBookGraphPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読書進捗グラフ'),
      ),
      body: ReadingBookGraphWidget(
        provider: (ref) =>
            ref.read(readingBooksProvider.notifier).currentEditReadingBook!,
      ),
    );
  }
}
