import 'package:conference_handson_2025/src/application/model/application_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_state.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';
import 'package:conference_handson_2025/src/presentation/model/default/reading_books_view_model.dart';

/// 書籍の編集モードを表す列挙型。
enum ReadingBookEditMode {
  /// 新規作成
  create,

  /// 編集
  edit,

  /// 削除
  delete,

  /// 未定
  undecided,
}

/// 読書中書籍を管理するドメインモデル。
class ReadingBooksDomainModel extends DomainObject<ReadingBooksState> {
  /// コンストラクタ。
  ReadingBooksDomainModel({ReadingBooksState? overrideStateModel})
      : _stateModel = overrideStateModel ?? ReadingBooksState();

  final ReadingBooksState _stateModel;
  final List<ReadingBookValueObject> _readingBooks = <ReadingBookValueObject>[];
  ReadingBookEditMode _currentEditMode = ReadingBookEditMode.undecided;
  int? _currentEditIndex;
  ReadingBookValueObject? _currentEditReadingBook;

  @override
  ReadingBooksState get stateModel => _stateModel;

  /// 書籍リストを取得する（変更不可リスト）。
  List<ReadingBookValueObject> get readingBooks =>
      List<ReadingBookValueObject>.unmodifiable(_readingBooks);

  /// 現在の編集モードを取得する。
  ReadingBookEditMode get currentEditMode => _currentEditMode;

  /// 現在編集中の書籍を取得する。
  ReadingBookValueObject? get currentEditReadingBook => _currentEditReadingBook;

  @override
  void initState() {
    stateModel.init();
    _readingBooks.clear();
    _readingBooks.addAll(stateModel.readingBooks);
  }

  @override
  void disposeState() {
    stateModel.dispose();
    _readingBooks.clear();
    _currentEditMode = ReadingBookEditMode.undecided;
    _currentEditIndex = null;
    _currentEditReadingBook = null;
  }

  /// 書籍を選択して編集モードにする。
  void selectReadingBook({required int index}) {
    _currentEditIndex = index;
    _currentEditReadingBook = _readingBooks[index];
    _currentEditMode = ReadingBookEditMode.edit;
  }

  /// 新規作成モードにする。
  void createReadingBook() {
    _currentEditIndex = null;
    _currentEditReadingBook = null;
    _currentEditMode = ReadingBookEditMode.create;
  }

  /// 書籍を新規作成して編集中にする。
  ReadingBookValueObject addReadingBook({
    required String name,
    required int totalPages,
  }) {
    final ReadingBookValueObject newBook = ReadingBookValueObject(
      name: name,
      totalPages: totalPages,
    );
    _currentEditIndex = null;
    _currentEditReadingBook = newBook;
    _currentEditMode = ReadingBookEditMode.create;
    return newBook;
  }

  /// 編集中書籍の情報を更新する。
  ReadingBookValueObject updateReadingBook({
    String? name,
    int? totalPages,
    int? readingPageNum,
    String? bookReview,
  }) {
    final ReadingBookValueObject target = _currentEditReadingBook!;
    final ReadingBookValueObject updatedBook = target.copyWith(
      name: name,
      totalPages: totalPages,
      readingPageNum: readingPageNum,
      bookReview: bookReview,
    );
    _currentEditReadingBook = updatedBook;
    _currentEditMode = ReadingBookEditMode.edit;
    return updatedBook;
  }

  /// 選択中の書籍を削除モードにする。
  ReadingBookValueObject removeReadingBook() {
    final ReadingBookValueObject target = _currentEditReadingBook!;
    _currentEditMode = ReadingBookEditMode.delete;
    return target;
  }

  /// 編集内容をコミットして確定する。
  void commitReadingBook(ReadingBookValueObject book) {
    switch (_currentEditMode) {
      case ReadingBookEditMode.create:
        _readingBooks.add(book);
      case ReadingBookEditMode.edit:
        if (_currentEditIndex != null) {
          _readingBooks[_currentEditIndex!] = book;
        }
      case ReadingBookEditMode.delete:
        if (_currentEditIndex != null) {
          _readingBooks.removeAt(_currentEditIndex!);
        }
      case ReadingBookEditMode.undecided:
        break;
    }
    stateModel.update(
      stateModel.valueObject.copyWith(
        readingBooks: List<ReadingBookValueObject>.from(_readingBooks),
      ),
    );
    _currentEditMode = ReadingBookEditMode.undecided;
    _currentEditIndex = null;
    _currentEditReadingBook = null;
  }
}

ReadingBooksDomainModel? _readingBooksDomainModel;

/// 読書中書籍ドメインモデルのプロバイダ関数。
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
    isApproved: (target) => target is ReadingBooksViewModel,
  );
}
