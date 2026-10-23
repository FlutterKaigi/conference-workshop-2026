/// 書籍編集フォームのウィジェット。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/debug/debug_logger.dart';
import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../../domain/model/reading_book_value_object.dart';
import '../../../model/default/reading_books_view_model.dart';
import '../../../model/default/reading_progress_animations_view_model.dart';

/// 書籍編集フォームの内部状態。
class ReadingBookState {
  /// フォームの [GlobalKey]。
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// 書籍タイトル入力。
  final TextEditingController nameController = TextEditingController();

  /// 総ページ数入力。
  final TextEditingController totalPagesController = TextEditingController();

  /// 読書中のページ数入力。
  final TextEditingController readingPageNumController =
      TextEditingController();

  /// 書籍感想入力。
  final TextEditingController bookReviewController = TextEditingController();

  /// 各 controller を dispose し、フォームを reset する。
  void disposeState() {
    nameController.dispose();
    totalPagesController.dispose();
    readingPageNumController.dispose();
    bookReviewController.dispose();
  }
}

/// 書籍編集フォームのウィジェット。
class ReadingBookWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, ReadingBookState> {
  /// コンストラクタ。
  const ReadingBookWidget({required super.provider, super.key});

  @override
  ReadingBookState createWidgetState() {
    return ReadingBookState();
  }

  @override
  void disposeState(ReadingBookState? state) {
    state?.disposeState();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    ReadingBookState? state,
  ) {
    final ReadingBookState formState = state!;
    final bool isCreate =
        ref.read(readingBooksProvider.notifier).currentEditMode.name ==
        'create';

    formState.nameController.text = value.name;
    formState.totalPagesController.text = value.totalPages.toString();
    formState.readingPageNumController.text = value.readingPageNum.toString();
    formState.bookReviewController.text = value.bookReview;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: formState.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              TextFormField(
                controller: formState.nameController,
                decoration: const InputDecoration(
                  labelText: '書籍タイトル',
                  hintText: '例: Flutter実践入門',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '書籍タイトルを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: formState.totalPagesController,
                decoration: const InputDecoration(
                  labelText: '書籍総ページ数',
                  hintText: '例: 300',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '総ページ数を入力してください';
                  }
                  final int? num = int.tryParse(value);
                  if (num == null || num < 1) {
                    return '有効なページ数を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: formState.readingPageNumController,
                decoration: const InputDecoration(
                  labelText: '読書中のページ番号（読書完了ページ数）',
                  hintText: '例: 150',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '読書中のページ番号を入力してください';
                  }
                  final int? num = int.tryParse(value);
                  if (num == null || num < 0) {
                    return '有効なページ番号を入力してください';
                  }
                  final int? total = int.tryParse(
                    formState.totalPagesController.text,
                  );
                  if (total != null && num > total) {
                    return '総ページ数を超えることはできません';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: formState.bookReviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '書籍感想',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formState.formKey.currentState!.validate()) {
                    final int prevReadingPageNum = value.readingPageNum;
                    final ReadingBookValueObject updatedVo = ref
                        .read(readingBooksProvider.notifier)
                        .updateReadingBook(
                          name: formState.nameController.text,
                          totalPages: int.tryParse(
                            formState.totalPagesController.text,
                          ),
                          readingPageNum: int.tryParse(
                            formState.readingPageNumController.text,
                          ),
                          bookReview: formState.bookReviewController.text,
                        );
                    ref
                        .read(readingBooksProvider.notifier)
                        .commitReadingBook(updatedVo);
                    ref
                        .read(readingProgressAnimationsProvider.notifier)
                        .updateAnimationTypeIfProgressChange(
                          updatedBook: updatedVo,
                          prevReadingPageNum: prevReadingPageNum,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop(updatedVo);
                    }
                  }
                },
                child: Text(isCreate ? '登録する' : '編集する'),
              ),
              if (!isCreate) ...<Widget>[
                const SizedBox(height: 12),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('書籍の削除'),
                          content: Text('「${value.name}」を本当に削除しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                final ReadingBookValueObject removeVo = ref
                                    .read(readingBooksProvider.notifier)
                                    .removeReadingBook();
                                ref
                                    .read(readingBooksProvider.notifier)
                                    .commitReadingBook(removeVo);
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('削除'),
                            ),
                          ],
                        );
                      },
                    ).then((dynamic result) {
                      if (result == true && context.mounted) {
                        DebugLog.debugLog('removeReadingBook: ${value.name}');
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: const Text('この書籍を削除する'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
