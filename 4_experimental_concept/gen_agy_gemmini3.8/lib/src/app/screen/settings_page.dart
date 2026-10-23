import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/widget_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 書籍設定画面。
class SettingsPage extends ConsumerWidget {
  /// コンストラクタ。
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読書書籍設定'),
      ),
      body: ReadingBookSettingsWidget(
        provider: (ref) {
          ref.read(readingBooksProvider.notifier).createReadingBook();
          return null;
        },
      ),
    );
  }
}
