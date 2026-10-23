/// 読書中の書籍 ViewModel の単体テスト。
library;

import 'package:conference_handson_2025/src/application/model/application_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_state.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'riverpod_unit_test_utillity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('riverpod readingBooksViewModel unit test', () {
    late ProviderContainer container;
    late ApplicationModel approver;

    setUp(() {
      final ReadingBooksState state = ReadingBooksState(
        overrideValue: const ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[],
        ),
      );
      final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
        overrideStateModel: state,
      );
      approver = ApplicationModel(overrideReadingBooksDomain: domain);
      readingBooksDomainModelProvider(
        approver,
        cycle: ModelCycle.init,
        overrideModel: domain,
      );
      container = createContainer();
    });

    tearDown(() {
      readingBooksDomainModelProvider(approver, cycle: ModelCycle.dispose);
    });

    test('addReadingBook smoke test', () {
      // 1. 初期状態が 0 件であること。
      expect(container.read(readingBooksProvider).readingBooks.length, 0);

      // 2. 「Flutter入門」350p を add → commit すると 1 件になること。
      final ReadingBookValueObject added = container
          .read(readingBooksProvider.notifier)
          .addReadingBook(name: 'Flutter入門', totalPages: 350);
      container.read(readingBooksProvider.notifier).commitReadingBook(added);
      expect(container.read(readingBooksProvider).readingBooks.length, 1);

      // 3. index 0 を選択して「Flutter実践入門」に update → commit すると、
      //    書名が変わること。
      container
          .read(readingBooksProvider.notifier)
          .selectReadingBook(index: 0);
      final ReadingBookValueObject updated = container
          .read(readingBooksProvider.notifier)
          .updateReadingBook(name: 'Flutter実践入門');
      container.read(readingBooksProvider.notifier).commitReadingBook(updated);
      expect(
        container.read(readingBooksProvider).readingBooks[0].name,
        'Flutter実践入門',
      );

      // 4. 「Vibeでええやん？」100p を add すると 2 件になること。
      final ReadingBookValueObject added2 = container
          .read(readingBooksProvider.notifier)
          .addReadingBook(name: 'Vibeでええやん？', totalPages: 100);
      container
          .read(readingBooksProvider.notifier)
          .commitReadingBook(added2);
      expect(container.read(readingBooksProvider).readingBooks.length, 2);

      // 5. index 1 を remove → commit すると 1 件に戻り、
      //    残りが「Flutter実践入門」であること。
      container
          .read(readingBooksProvider.notifier)
          .selectReadingBook(index: 1);
      final ReadingBookValueObject removed = container
          .read(readingBooksProvider.notifier)
          .removeReadingBook();
      container
          .read(readingBooksProvider.notifier)
          .commitReadingBook(removed);
      final List<ReadingBookValueObject> books =
          container.read(readingBooksProvider).readingBooks;
      expect(books.length, 1);
      expect(books[0].name, 'Flutter実践入門');
    });
  });
}
