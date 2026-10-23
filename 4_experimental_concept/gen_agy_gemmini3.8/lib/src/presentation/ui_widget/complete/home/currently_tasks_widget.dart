import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/debug/debug_logger.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書中タスク一覧ウィジェット（完成版）。
// ignore: must_be_immutable
class CurrentlyTasksWidget
    extends ConsumerStagedWidget<ReadingBooksValueObject, ScrollController> {
  /// コンストラクタ。
  CurrentlyTasksWidget({
    required super.provider,
    super.key,
  });

  @override
  ScrollController createWidgetState() => ScrollController();

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
      controller: state,
      thumbVisibility: true,
      child: ListView.builder(
        controller: state,
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          final ReadingBookValueObject book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              title: Text(book.name),
              onTap: () {
                ref
                    .read(readingBooksProvider.notifier)
                    .selectReadingBook(index: index);
                debugLog('Selected book: ${book.name}');
                context.goReadingBook();
              },
            ),
          );
        },
      ),
    );
  }
}
