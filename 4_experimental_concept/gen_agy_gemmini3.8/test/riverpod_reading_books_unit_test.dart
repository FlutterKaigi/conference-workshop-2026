import 'package:conference_handson_2025/src/application/model/application_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_state.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'riverpod_unit_test_utillity.dart';

void main() {
  test('riverpod readingBooksViewModel unit test', () {
    final ReadingBooksState stateModel = ReadingBooksState(
      overrideValue: const ReadingBooksValueObject(),
    );
    final ReadingBooksDomainModel domainModel = ReadingBooksDomainModel(
      overrideStateModel: stateModel,
    );

    final ApplicationModel approver = ApplicationModel();
    readingBooksDomainModelProvider(
      approver,
      cycle: ModelCycle.init,
      overrideModel: domainModel,
    );

    addTearDown(() {
      readingBooksDomainModelProvider(
        approver,
        cycle: ModelCycle.dispose,
      );
    });

    final ProviderContainer container = createContainer();
    final ReadingBooksViewModel notifier =
        container.read(readingBooksProvider.notifier);

    // 1. 初期状態が 0 件
    expect(container.read(readingBooksProvider).readingBooks.length, 0);

    // 2. 「Flutter入門」350p を add → commit すると 1 件
    final ReadingBookValueObject book1 = notifier.addReadingBook(
      name: 'Flutter入門',
      totalPages: 350,
    );
    notifier.commitReadingBook(book1);
    expect(container.read(readingBooksProvider).readingBooks.length, 1);
    expect(
      container.read(readingBooksProvider).readingBooks[0].name,
      'Flutter入門',
    );

    // 3. index 0 を選択して「Flutter実践入門」に update → commit すると、書名が変わる
    notifier.selectReadingBook(index: 0);
    final ReadingBookValueObject updatedBook1 = notifier.updateReadingBook(
      name: 'Flutter実践入門',
    );
    notifier.commitReadingBook(updatedBook1);
    expect(container.read(readingBooksProvider).readingBooks.length, 1);
    expect(
      container.read(readingBooksProvider).readingBooks[0].name,
      'Flutter実践入門',
    );

    // 4. 「Vibeでええやん？」100p を add すると 2 件
    final ReadingBookValueObject book2 = notifier.addReadingBook(
      name: 'Vibeでええやん？',
      totalPages: 100,
    );
    notifier.commitReadingBook(book2);
    expect(container.read(readingBooksProvider).readingBooks.length, 2);

    // 5. index 1 を remove → commit すると 1 件に戻り、残りが「Flutter実践入門」
    notifier.selectReadingBook(index: 1);
    final ReadingBookValueObject removedBook = notifier.removeReadingBook();
    notifier.commitReadingBook(removedBook);
    expect(container.read(readingBooksProvider).readingBooks.length, 1);
    expect(
      container.read(readingBooksProvider).readingBooks[0].name,
      'Flutter実践入門',
    );
  });
}
