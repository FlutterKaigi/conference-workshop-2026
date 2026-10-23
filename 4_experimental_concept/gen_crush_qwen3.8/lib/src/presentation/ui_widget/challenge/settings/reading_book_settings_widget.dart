/// 書籍設定（新規追加・デバッグ）ウィジェット。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../../fundamental/ui_widget/toggle_switch.dart';
import '../../../../domain/model/reading_book_value_object.dart';
import '../../../model/default/reading_books_view_model.dart';
import '../../../model/default/reading_support_animations_view_model.dart';

/// 書籍設定ウィジェットの内部状態。
class ReadingBookSettingsState {
  /// フォームの [GlobalKey]。
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// 書籍タイトル入力。
  final TextEditingController nameController = TextEditingController();

  /// 総ページ数入力。
  final TextEditingController totalPagesController = TextEditingController();

  /// 各 controller を dispose し、フォームを reset する。
  void disposeState() {
    nameController.dispose();
    totalPagesController.dispose();
  }
}

/// 書籍設定（新規追加・デバッグ）ウィジェット。
class ReadingBookSettingsWidget
    extends ConsumerStagedWidget<Object?, ReadingBookSettingsState> {
  /// コンストラクタ。
  const ReadingBookSettingsWidget({required super.provider, super.key});

  @override
  ReadingBookSettingsState createWidgetState() {
    return ReadingBookSettingsState();
  }

  @override
  void disposeState(ReadingBookSettingsState? state) {
    state?.disposeState();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Object? value,
    ReadingBookSettingsState? state,
  ) {
    final ReadingBookSettingsState formState = state!;
    final ReadingSupportAnimationsViewModel supportVm = ref.read(
      readingSupportAnimationsProvider.notifier,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'デバッグ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'タップ 10秒後にイベントを発行します。',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('読書開始イベント'),
                      ToggleSwitch(viewModel: supportVm.debugStartReading),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('読書終了イベント'),
                      ToggleSwitch(viewModel: supportVm.debugEndReading),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: formState.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: formState.nameController,
                    decoration: const InputDecoration(
                      labelText: '書籍タイトル',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '書籍タイトルを入力してください。';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: formState.totalPagesController,
                    decoration: const InputDecoration(
                      labelText: '書籍総ページ数',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return '総ページ数を入力してください。';
                      }
                      final int? num = int.tryParse(value);
                      if (num == null) {
                        return '有効な数値を入力してください。';
                      }
                      if (num < 1) {
                        return '総ページ数は1以上の数値を入力してください。';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (formState.formKey.currentState!.validate()) {
                        final ReadingBookValueObject newBook = ref
                            .read(readingBooksProvider.notifier)
                            .addReadingBook(
                              name: formState.nameController.text,
                              totalPages:
                                  int.tryParse(
                                    formState.totalPagesController.text,
                                  ) ??
                                  0,
                            );
                        ref
                            .read(readingBooksProvider.notifier)
                            .commitReadingBook(newBook);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('書籍「${newBook.name}」を追加します。'),
                            ),
                          );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('新規追加'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
