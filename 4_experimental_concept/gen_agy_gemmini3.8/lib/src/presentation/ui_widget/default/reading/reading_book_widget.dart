import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/fundamental/debug/debug_logger.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 書籍編集フォームの内部状態。
class ReadingBookState {
  /// フォームキー。
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// タイトル用コントローラ。
  final TextEditingController nameController = TextEditingController();

  /// 総ページ数用コントローラ。
  final TextEditingController totalPagesController = TextEditingController();

  /// 読書中ページ用コントローラ。
  final TextEditingController readingPageNumController =
      TextEditingController();

  /// 感想用コントローラ。
  final TextEditingController bookReviewController = TextEditingController();

  /// 破棄処理。
  void dispose() {
    formKey.currentState?.reset();
    nameController.dispose();
    totalPagesController.dispose();
    readingPageNumController.dispose();
    bookReviewController.dispose();
  }
}

/// 書籍登録・編集ウィジェット（デフォルト版）。
// ignore: must_be_immutable
class ReadingBookWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, ReadingBookState> {
  /// コンストラクタ。
  ReadingBookWidget({
    required super.provider,
    super.key,
  });

  @override
  ReadingBookState createWidgetState() => ReadingBookState();

  @override
  void disposeState(ReadingBookState? state) {
    state?.dispose();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    ReadingBookState? state,
  ) {
    if (state != null) {
      state.nameController.text = value.name;
      state.totalPagesController.text =
          value.totalPages > 0 ? value.totalPages.toString() : '';
      state.readingPageNumController.text = value.readingPageNum.toString();
      state.bookReviewController.text = value.bookReview;
    }

    final ReadingBookEditMode mode =
        ref.watch(readingBooksProvider.notifier).currentEditMode;
    final bool isCreate = mode == ReadingBookEditMode.create;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: state?.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: state?.nameController,
                decoration: const InputDecoration(
                  labelText: '書籍タイトル',
                  hintText: '例: Flutter実践入門',
                  border: OutlineInputBorder(),
                ),
                validator: (String? val) {
                  if (val == null || val.trim().isEmpty) {
                    return '書籍タイトルを入力してください';
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
                  hintText: '例: 300',
                  border: OutlineInputBorder(),
                ),
                validator: (String? val) {
                  if (val == null || val.trim().isEmpty) {
                    return '総ページ数を入力してください';
                  }
                  final int? pages = int.tryParse(val);
                  if (pages == null || pages < 1) {
                    return '有効なページ数を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: state?.readingPageNumController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: '読書中のページ番号（読書完了ページ数）',
                  hintText: '例: 150',
                  border: OutlineInputBorder(),
                ),
                validator: (String? val) {
                  if (val == null || val.trim().isEmpty) {
                    return '読書中のページ番号を入力してください';
                  }
                  final int? page = int.tryParse(val);
                  if (page == null || page < 0) {
                    return '有効なページ番号を入力してください';
                  }
                  final int? total =
                      int.tryParse(state?.totalPagesController.text ?? '');
                  if (total != null && page > total) {
                    return '総ページ数を超えることはできません';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: state?.bookReviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '書籍感想',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (state?.formKey.currentState?.validate() ?? false) {
                    state?.formKey.currentState?.save();
                    final int prevReadingPageNum = value.readingPageNum;
                    final ReadingBooksViewModel notifier =
                        ref.read(readingBooksProvider.notifier);

                    final ReadingBookValueObject updatedBook =
                        notifier.updateReadingBook(
                      name: state?.nameController.text,
                      totalPages: int.tryParse(
                        state?.totalPagesController.text ?? '',
                      ),
                      readingPageNum: int.tryParse(
                        state?.readingPageNumController.text ?? '',
                      ),
                      bookReview: state?.bookReviewController.text,
                    );
                    notifier.commitReadingBook(updatedBook);

                    ref
                        .read(readingProgressAnimationsProvider.notifier)
                        .updateAnimationTypeIfProgressChange(
                          updatedBook: updatedBook,
                          prevReadingPageNum: prevReadingPageNum,
                        );

                    Navigator.pop(context, updatedBook);
                  }
                },
                child: Text(isCreate ? '登録する' : '編集する'),
              ),
              if (!isCreate) ...<Widget>[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    final bool? confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('書籍の削除'),
                          content: Text('「${value.name}」を本当に削除しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                              onPressed: () {
                                final ReadingBooksViewModel notifier =
                                    ref.read(readingBooksProvider.notifier);
                                final ReadingBookValueObject removed =
                                    notifier.removeReadingBook();
                                notifier.commitReadingBook(removed);
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                '削除',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true && context.mounted) {
                      debugLog('Deleted book: ${value.name}');
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'この書籍を削除する',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
