import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書中書籍一覧プロバイダ。
final NotifierProvider<ReadingBooksViewModel, ReadingBooksValueObject>
    readingBooksProvider =
    NotifierProvider<ReadingBooksViewModel, ReadingBooksValueObject>(
  ReadingBooksViewModel.new,
);

/// 読書中書籍一覧の ViewModel。
class ReadingBooksViewModel extends Notifier<ReadingBooksValueObject> {
  late final ReadingBooksDomainModel _domainModel;
  ReadingBookValueObject? _editedReadingBook;

  /// 直近でコミットされた書籍。
  ReadingBookValueObject? get editedReadingBook => _editedReadingBook;

  @override
  ReadingBooksValueObject build() {
    _domainModel = readingBooksDomainModelProvider(this);
    return _domainModel.stateModel.valueObject;
  }

  /// 書籍リストを取得する。
  List<ReadingBookValueObject> get readingBooks => _domainModel.readingBooks;

  /// 現在の編集モードを取得する。
  ReadingBookEditMode get currentEditMode => _domainModel.currentEditMode;

  /// 現在編集中の書籍を取得する。
  ReadingBookValueObject? get currentEditReadingBook =>
      _domainModel.currentEditReadingBook;

  /// 書籍を選択する。
  void selectReadingBook({required int index}) =>
      _domainModel.selectReadingBook(index: index);

  /// 新規作成モードにする。
  void createReadingBook() => _domainModel.createReadingBook();

  /// 書籍を追加する。
  ReadingBookValueObject addReadingBook({
    required String name,
    required int totalPages,
  }) =>
      _domainModel.addReadingBook(name: name, totalPages: totalPages);

  /// 書籍情報を更新する。
  ReadingBookValueObject updateReadingBook({
    String? name,
    int? totalPages,
    int? readingPageNum,
    String? bookReview,
  }) =>
      _domainModel.updateReadingBook(
        name: name,
        totalPages: totalPages,
        readingPageNum: readingPageNum,
        bookReview: bookReview,
      );

  /// 書籍を削除する。
  ReadingBookValueObject removeReadingBook() =>
      _domainModel.removeReadingBook();

  /// 変更をコミットして状態を更新する。
  void commitReadingBook(ReadingBookValueObject book) {
    _domainModel.commitReadingBook(book);
    _editedReadingBook = book;
    state = _domainModel.stateModel.valueObject;
  }
}
