/// ホーム画面の「現在読書中書籍一覧」ウィジェット。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/debug/debug_logger.dart';
import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../../domain/model/reading_books_value_object.dart';
import '../../../../domain/model/reading_book_value_object.dart';
import '../../../../routing/app_router.dart';
import '../../../model/default/reading_books_view_model.dart';

/// ホーム画面の「現在読書中書籍一覧」ウィジェット。
class CurrentlyTasksWidget
    extends ConsumerStagedWidget<ReadingBooksValueObject, ScrollController> {
  /// コンストラクタ。
  const CurrentlyTasksWidget({required super.provider, super.key});

  @override
  ScrollController createWidgetState() {
    return ScrollController();
  }

  @override
  void disposeState(ScrollController? state) {
    state?.dispose();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBooksValueObject value,
    ScrollController? state,
  ) {
    final List<ReadingBookValueObject> books = value.readingBooks;
    return Scrollbar(
      thumbVisibility: true,
      controller: state,
      child: ListView.builder(
        controller: state,
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          final ReadingBookValueObject book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(book.name),
              onTap: () {
                ref
                    .read(readingBooksProvider.notifier)
                    .selectReadingBook(index: index);
                DebugLog.debugLog('selectReadingBook', info: book);
                context.goReadingBook();
              },
            ),
          );
        },
      ),
    );
  }
}
