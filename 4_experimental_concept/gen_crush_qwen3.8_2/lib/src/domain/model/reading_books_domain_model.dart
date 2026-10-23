/// 読書中の書籍のドメインモデル。
library;

import '../../application/model/application_model.dart';
import '../../fundamental/model/base_objects_model.dart';
import '../../presentation/model/default/reading_books_view_model.dart';
import 'reading_books_state.dart';
import 'reading_book_value_object.dart';

/// 書籍の編集モード。
enum ReadingBookEditMode {
  /// 新規作成。
  create,

  /// 編集。
  edit,

  /// 削除。
  delete,

  /// 未確定。
  undecided,
}

/// 読書中の書籍のドメインモデル。
class ReadingBooksDomainModel extends DomainObject<ReadingBooksState> {
  /// コンストラクタ。
  ReadingBooksDomainModel({ReadingBooksState? overrideStateModel})
    : stateModel = overrideStateModel ?? ReadingBooksState();

  /// 状態モデル。
  @override
  final ReadingBooksState stateModel;

  /// 現在のカレントな書籍のリスト。
  final List<ReadingBookValueObject> _readingBooks = <ReadingBookValueObject>[];

  /// 現在の編集モード。
  ReadingBookEditMode _currentEditMode = ReadingBookEditMode.undecided;

  /// 編集中の書籍の index。
  int? _currentEditIndex;

  /// 編集中の書籍。
  ReadingBookValueObject? _currentEditReadingBook;

  /// 状態の初期化。
  @override
  void initState() {
    stateModel.init();
    _readingBooks
      ..clear()
      ..addAll(stateModel.readingBooks);
  }

  /// 状態の破棄。
  @override
  void disposeState() {
    stateModel.dispose();
    _readingBooks.clear();
  }

  /// 現在のカレントな書籍のリスト（変更不可）。
  List<ReadingBookValueObject> get readingBooks =>
      List<ReadingBookValueObject>.unmodifiable(_readingBooks);

  /// 現在の編集モード。
  ReadingBookEditMode get currentEditMode => _currentEditMode;

  /// 編集中の書籍。
  ReadingBookValueObject? get currentEditReadingBook => _currentEditReadingBook;

  /// 編集対象の書籍を選択する（編集モード）。
  void selectReadingBook({required int index}) {
    assert(index >= 0 && index < _readingBooks.length);
    _currentEditIndex = index;
    _currentEditReadingBook = _readingBooks[index];
    _currentEditMode = ReadingBookEditMode.edit;
  }

  /// 新規作成モードに切り替える。
  void createReadingBook() {
    _currentEditReadingBook = null;
    _currentEditIndex = null;
    _currentEditMode = ReadingBookEditMode.create;
  }

  /// 新規作成する書籍を作成する。
  ///
  /// [name] と [totalPages] を持った新規の VO を編集中の書籍として
  /// 保持し、create モードにして、その VO を返す。
  ReadingBookValueObject addReadingBook({
    required String name,
    required int totalPages,
  }) {
    final ReadingBookValueObject book = ReadingBookValueObject(
      name: name,
      totalPages: totalPages,
    );
    _currentEditReadingBook = book;
    _currentEditMode = ReadingBookEditMode.create;
    return book;
  }

  /// 選択中の書籍を [copyWith] した VO を編集中の書籍として保持し、
  /// edit モードにして、その VO を返す。
  ReadingBookValueObject updateReadingBook({
    String? name,
    int? totalPages,
    int? readingPageNum,
    String? bookReview,
  }) {
    assert(_currentEditReadingBook != null);
    final ReadingBookValueObject book = _currentEditReadingBook!.copyWith(
      name: name,
      totalPages: totalPages,
      readingPageNum: readingPageNum,
      bookReview: bookReview,
    );
    _currentEditReadingBook = book;
    _currentEditMode = ReadingBookEditMode.edit;
    return book;
  }

  /// 選択中の書籍を編集中の書籍として保持し、delete モードにして、
  /// その書籍を返す。
  ReadingBookValueObject removeReadingBook() {
    assert(_currentEditReadingBook != null);
    _currentEditMode = ReadingBookEditMode.delete;
    return _currentEditReadingBook!;
  }

  /// 編集内容をリストに適用する（コミット）。
  ///
  /// - create: リストに追加する
  /// - edit: リストの [currentEditIndex] を置き換える
  /// - delete: リストから削除する
  /// - undecided: 何もしない
  ///
  /// 適用後に状態モデルを更新し、編集状態を undecided にリセットする。
  void commitReadingBook(ReadingBookValueObject book) {
    switch (_currentEditMode) {
      case ReadingBookEditMode.create:
        _readingBooks.add(book);
      case ReadingBookEditMode.edit:
        assert(_currentEditIndex != null);
        _readingBooks[_currentEditIndex!] = book;
      case ReadingBookEditMode.delete:
        assert(_currentEditIndex != null);
        _readingBooks.removeAt(_currentEditIndex!);
      case ReadingBookEditMode.undecided:
        break;
    }
    stateModel.update(
      stateModel.valueObject.copyWith(readingBooks: _readingBooks),
    );
    _currentEditMode = ReadingBookEditMode.undecided;
    _currentEditIndex = null;
    _currentEditReadingBook = null;
  }
}

/// グローバルなドメインモデルのインスタンス。
ReadingBooksDomainModel? _readingBooksDomainModel;

/// [ReadingBooksDomainModel] へのアクセス関数。
///
/// - 初期化（init）と破棄（dispose）は [ApplicationModel] のみ。
/// - 取得（get）は [ApplicationModel] と [ReadingBooksViewModel] のみ。
///
/// [approver] が上記の型でなかったり、承認されていない
/// approver からのアクセスは `ArgumentError('Unauthorized approver.')`
/// を投げる。
ReadingBooksDomainModel readingBooksDomainModelProvider(
  Object approver, {
  ModelCycle cycle = ModelCycle.get,
  ReadingBooksDomainModel? overrideModel,
}) {
  return modelProvider<ApplicationModel, ReadingBooksDomainModel>(
    approver,
    cycle: cycle,
    overrideModel: overrideModel,
    initModel: () {
      final ReadingBooksDomainModel model =
          overrideModel ?? ReadingBooksDomainModel();
      model.initState();
      _readingBooksDomainModel = model;
      return model;
    },
    disposeModel: () {
      final ReadingBooksDomainModel model = _readingBooksDomainModel!;
      model.disposeState();
      _readingBooksDomainModel = null;
      return model;
    },
    getModel: () => _readingBooksDomainModel,
    isApproved: (Object approver) => approver is ReadingBooksViewModel,
  );
}
