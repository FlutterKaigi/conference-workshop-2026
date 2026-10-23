/// 設定ページ。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/model/view_model_packages.dart';
import '../../../presentation/ui_widget/widget_packages.dart';

/// 設定ページ。
///
/// provider の実行時に書籍編集モードが create に移行する。
class SettingsPage extends ConsumerWidget {
  /// コンストラクタ。
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('読書書籍設定')),
      body: ReadingBookSettingsWidget(
        provider: (WidgetRef ref) {
          ref.read(readingBooksProvider.notifier).createReadingBook();
          return null;
        },
      ),
    );
  }
}
