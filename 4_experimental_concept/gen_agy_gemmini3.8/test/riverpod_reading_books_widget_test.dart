import 'package:conference_handson_2025/src/app/app.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_state.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

String? findTextField(CommonFinders find, int index) {
  final TextField textField =
      find.byType(TextField).at(index).evaluate().single.widget as TextField;
  return textField.controller?.text;
}

void main() {
  testWidgets('addReadingBook smoke test', (tester) async {
    final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
      overrideStateModel: ReadingBooksState(
        overrideValue: const ReadingBooksValueObject(),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: App(overrideReadingBooksDomain: domain),
      ),
    );
    await tester.pumpAndSettle();

    // 1. 歯車アイコンから SettingsPage へ遷移
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // 2. 1つ目の TextField に「Flutter入門」、最後の TextField に「350」を入力し、「新規追加」
    await tester.enterText(find.byType(TextField).first, 'Flutter入門');
    await tester.enterText(find.byType(TextField).last, '350');
    await tester.tap(find.text('新規追加'));
    await tester.pumpAndSettle();

    // 3. HomePage に戻り、一覧に書名が表示されることを確認
    expect(find.text('Flutter入門'), findsOneWidget);

    // 4. 書籍カードをタップして ReadingBookPage に遷移し、1・2番目の TextField の値が「Flutter入門」「350」であることを確認
    await tester.tap(find.text('Flutter入門'));
    await tester.pumpAndSettle();

    expect(findTextField(find, 0), 'Flutter入門');
    expect(findTextField(find, 1), '350');

    // 5. pageBack で HomePage に戻る
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('読書進捗応援'), findsOneWidget);
  });

  testWidgets('updateReadingBook smoke test', (tester) async {
    final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
      overrideStateModel: ReadingBooksState(
        overrideValue: const ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[
            ReadingBookValueObject(
              name: 'Flutter入門',
              totalPages: 350,
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: App(overrideReadingBooksDomain: domain),
      ),
    );
    await tester.pumpAndSettle();

    // 1. 書籍を開き、4つの TextField の値が「Flutter入門」「350」「0」「」であることを確認
    await tester.tap(find.text('Flutter入門'));
    await tester.pumpAndSettle();

    expect(findTextField(find, 0), 'Flutter入門');
    expect(findTextField(find, 1), '350');
    expect(findTextField(find, 2), '0');
    expect(findTextField(find, 3), '');

    // 2. 書名を「Flutter実践入門」に変えて、ensureVisible の後に「編集する」を押す
    await tester.enterText(find.byType(TextField).first, 'Flutter実践入門');
    final Finder buttonFinder = find.widgetWithText(ElevatedButton, '編集する');
    if (buttonFinder.evaluate().isEmpty) {
      throw UnsupportedError('Button not found');
    }
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // 3. HomePage で新しい書名だけが表示されることを確認
    expect(find.text('Flutter実践入門'), findsOneWidget);
    expect(find.text('Flutter入門'), findsNothing);
  });

  testWidgets('removeReadingBook smoke test', (tester) async {
    final ReadingBooksDomainModel domain = ReadingBooksDomainModel(
      overrideStateModel: ReadingBooksState(
        overrideValue: const ReadingBooksValueObject(
          readingBooks: <ReadingBookValueObject>[
            ReadingBookValueObject(
              name: 'Flutter入門',
              totalPages: 350,
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: App(overrideReadingBooksDomain: domain),
      ),
    );
    await tester.pumpAndSettle();

    // 1. 書籍を開き、「この書籍を削除する」を押す
    await tester.tap(find.text('Flutter入門'));
    await tester.pumpAndSettle();

    final Finder deleteButtonFinder = find.text('この書籍を削除する');
    await tester.ensureVisible(deleteButtonFinder);
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();

    // 2. ダイアログの「削除」を押す
    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pumpAndSettle();

    // 3. HomePage に戻り、一覧が空になることを確認
    expect(find.text('Flutter入門'), findsNothing);
  });
}
