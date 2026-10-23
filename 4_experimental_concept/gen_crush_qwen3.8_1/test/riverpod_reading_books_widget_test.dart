/// 読書中の書籍 UI のウィジェットスモークテスト。
library;

import 'package:conference_handson_2025/src/app/app.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_state.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('riverpod readingBooksViewModel test', () {
    testWidgets('addReadingBook smoke test', (WidgetTester tester) async {
      // 準備：0 件で開始。
      final ReadingBooksState state = ReadingBooksState(
        overrideValue: const ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[],
        ),
      );
      final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
        overrideStateModel: state,
      );

      await tester.pumpWidget(
        ProviderScope(child: App(overrideReadingBooksDomain: domain)),
      );
      await tester.pumpAndSettle();

      // 歯車アイコンから SettingsPage へ遷移する。
      await tester.tap(find.byTooltip('設定'));
      await tester.pumpAndSettle();
      expect(find.text('書籍タイトル'), findsOneWidget);

      // 1 つ目の TextField に「Flutter入門」、
      // 最後の TextField に「350」を入力し、「新規追加」を押す。
      await tester.enterText(find.byType(TextField).at(0), 'Flutter入門');
      await tester.enterText(find.byType(TextField).last, '350');
      await tester.tap(find.text('新規追加'));
      await tester.pumpAndSettle();

      // HomePage に戻り、一覧に書名が表示されることを確認する。
      expect(find.text('読書進捗応援'), findsOneWidget);
      expect(find.text('Flutter入門'), findsWidgets);

      // 書籍カードをタップして ReadingBookPage に遷移し、
      // 1・2 番目の TextField の値が「Flutter入門」「350」であることを確認する。
      await tester.tap(find.text('Flutter入門'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('グラフ'), findsOneWidget);
      final List<Element> found = find.byType(TextField).evaluate().toList();
      final List<String> values = <String>[
        for (final Element e in found) (e.widget as TextField).controller?.text ?? '',
      ];
      expect(values[0], 'Flutter入門');
      expect(values[1], '350');

      // pageBack で HomePage に戻る。
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('読書進捗応援'), findsOneWidget);
    });

    testWidgets('updateReadingBook smoke test', (WidgetTester tester) async {
      // 準備：1 件で開始。
      final ReadingBooksState state = ReadingBooksState(
        overrideValue: ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[
            const ReadingBookValueObject(
              name: 'Flutter入門',
              totalPages: 350,
            ),
          ],
        ),
      );
      final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
        overrideStateModel: state,
      );

      await tester.pumpWidget(
        ProviderScope(child: App(overrideReadingBooksDomain: domain)),
      );
      await tester.pumpAndSettle();

      // 書籍を開く。
      await tester.tap(find.text('Flutter入門'));
      await tester.pumpAndSettle();

      // 4 つの TextField の値が「Flutter入門」「350」「0」「」であること。
      final List<Element> found = find.byType(TextField).evaluate().toList();
      final List<String> values = <String>[
        for (final Element e in found) (e.widget as TextField).controller?.text ?? '',
      ];
      expect(values[0], 'Flutter入門');
      expect(values[1], '350');
      expect(values[2], '0');
      expect(values[3], '');

      // 書名を「Flutter実践入門」に変えて「編集する」を押す。
      await tester.enterText(find.byType(TextField).at(0), 'Flutter実践入門');
      await tester.ensureVisible(find.byType(TextField).at(0));
      final Finder button = find.text('編集する');
      if (button.evaluate().isEmpty) {
        throw UnsupportedError('button not found');
      }
      await tester.tap(button);
      await tester.pumpAndSettle();

      // HomePage で新しい書名だけが表示されることを確認する。
      expect(find.text('読書進捗応援'), findsOneWidget);
      expect(find.text('Flutter実践入門'), findsWidgets);
      expect(find.text('Flutter入門'), findsNothing);
    });

    testWidgets('removeReadingBook smoke test', (WidgetTester tester) async {
      // 準備：1 件で開始。
      final ReadingBooksState state = ReadingBooksState(
        overrideValue: ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[
            const ReadingBookValueObject(
              name: 'Flutter入門',
              totalPages: 350,
            ),
          ],
        ),
      );
      final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
        overrideStateModel: state,
      );

      await tester.pumpWidget(
        ProviderScope(child: App(overrideReadingBooksDomain: domain)),
      );
      await tester.pumpAndSettle();

      // 書籍を開き、「この書籍を削除する」を押す。
      await tester.tap(find.text('Flutter入門'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('この書籍を削除する'));
      await tester.pumpAndSettle();

      // ダイアログの「削除」を押す。
      await tester.tap(find.text('削除'));
      await tester.pumpAndSettle();

      // HomePage に戻り、一覧が空になることを確認する。
      expect(find.text('読書進捗応援'), findsOneWidget);
      expect(find.text('Flutter入門'), findsNothing);
    });
  });
}
