/// 読書中の書籍一覧の ViewModel。
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/model/reading_books_domain_model.dart';
import '../../../domain/model/reading_books_value_object.dart';
import '../../../domain/model/reading_book_value_object.dart';

/// [ReadingBooksViewModel] の [NotifierProvider]。
final NotifierProvider<ReadingBooksViewModel, ReadingBooksValueObject>
readingBooksProvider =
    NotifierProvider<ReadingBooksViewModel, ReadingBooksValueObject>(
      ReadingBooksViewModel.new,
    );

/// 読書中の書籍一覧の ViewModel。
class ReadingBooksViewModel extends Notifier<ReadingBooksValueObject> {
  /// 直近にコミットした書籍。
  ReadingBookValueObject? editedReadingBook;

  /// ドメインモデル。
  late final ReadingBooksDomainModel _domainModel;

  /// 初期化時にドメインモデルを取得し、現在の状態を返す。
  @override
  ReadingBooksValueObject build() {
    _domainModel = readingBooksDomainModelProvider(this);
    return _domainModel.stateModel.valueObject;
  }

  /// 現在のカレントな書籍のリスト。
  List<ReadingBookValueObject> get readingBooks => _domainModel.readingBooks;

  /// 現在の編集モード。
  ReadingBookEditMode get currentEditMode => _domainModel.currentEditMode;

  /// 編集中の書籍。
  ReadingBookValueObject? get currentEditReadingBook =>
      _domainModel.currentEditReadingBook;

  /// 編集対象の書籍を選択する。
  void selectReadingBook({required int index}) {
    return _domainModel.selectReadingBook(index: index);
  }

  /// 新規作成モードに切り替える。
  void createReadingBook() {
    return _domainModel.createReadingBook();
  }

  /// 新規作成する書籍を作成する。
  ReadingBookValueObject addReadingBook({
    required String name,
    required int totalPages,
  }) {
    return _domainModel.addReadingBook(name: name, totalPages: totalPages);
  }

  /// 選択中の書籍を更新する。
  ReadingBookValueObject updateReadingBook({
    String? name,
    int? totalPages,
    int? readingPageNum,
    String? bookReview,
  }) {
    return _domainModel.updateReadingBook(
      name: name,
      totalPages: totalPages,
      readingPageNum: readingPageNum,
      bookReview: bookReview,
    );
  }

  /// 選択中の書籍を削除する。
  ReadingBookValueObject removeReadingBook() {
    return _domainModel.removeReadingBook();
  }

  /// 編集内容をコミットする。
  ///
  /// コミット後に [editedReadingBook] を保持し、
  /// Riverpod の state を [ValueObject] で更新する。
  void commitReadingBook(ReadingBookValueObject book) {
    _domainModel.commitReadingBook(book);
    editedReadingBook = book;
    state = _domainModel.stateModel.valueObject;
  }
}
