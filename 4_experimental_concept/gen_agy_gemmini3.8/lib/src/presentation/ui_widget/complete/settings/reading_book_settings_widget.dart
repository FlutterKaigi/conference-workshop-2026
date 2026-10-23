import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/toggle_switch.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 書籍設定画面の内部状態。
class ReadingBookSettingsState {
  /// フォームキー。
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// タイトル用コントローラ。
  final TextEditingController nameController = TextEditingController();

  /// 総ページ数用コントローラ。
  final TextEditingController totalPagesController = TextEditingController();

  /// 破棄処理。
  void dispose() {
    formKey.currentState?.reset();
    nameController.dispose();
    totalPagesController.dispose();
  }
}

/// 書籍設定ウィジェット（完成版）。
// ignore: must_be_immutable
class ReadingBookSettingsWidget
    extends ConsumerStagedWidget<Object?, ReadingBookSettingsState> {
  /// コンストラクタ。
  ReadingBookSettingsWidget({
    required super.provider,
    super.key,
  });

  @override
  ReadingBookSettingsState createWidgetState() => ReadingBookSettingsState();

  @override
  void disposeState(ReadingBookSettingsState? state) {
    state?.dispose();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    Object? value,
    ReadingBookSettingsState? state,
  ) {
    final ReadingSupportAnimationsViewModel supportNotifier =
        ref.watch(readingSupportAnimationsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'デバッグ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'タップ 10秒後にイベントを発行します。',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('読書開始イベント'),
                      ToggleSwitch(
                        viewModel: supportNotifier.debugStartReading,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('読書終了イベント'),
                      ToggleSwitch(
                        viewModel: supportNotifier.debugEndReading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: state?.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: state?.nameController,
                    decoration: const InputDecoration(
                      labelText: '書籍タイトル',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? val) {
                      if (val == null || val.trim().isEmpty) {
                        return '書籍タイトルを入力してください。';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: state?.totalPagesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: '書籍総ページ数',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? val) {
                      if (val == null || val.trim().isEmpty) {
                        return '総ページ数を入力してください。';
                      }
                      final int? pages = int.tryParse(val);
                      if (pages == null) {
                        return '有効な数値を入力してください。';
                      }
                      if (pages < 1) {
                        return '総ページ数は1以上の数値を入力してください。';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (state?.formKey.currentState?.validate() ?? false) {
                        state?.formKey.currentState?.save();
                        final String bookName = state!.nameController.text;
                        final int totalPages =
                            int.parse(state.totalPagesController.text);

                        final ReadingBooksViewModel notifier =
                            ref.read(readingBooksProvider.notifier);
                        final ReadingBookValueObject newBook =
                            notifier.addReadingBook(
                          name: bookName,
                          totalPages: totalPages,
                        );
                        notifier.commitReadingBook(newBook);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('書籍「$bookName」を追加します。'),
                          ),
                        );
                        Navigator.pop(context);
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
