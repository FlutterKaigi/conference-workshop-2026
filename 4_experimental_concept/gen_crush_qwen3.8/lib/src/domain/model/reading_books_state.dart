/// 読書中の書籍の状態モデル（[ValueObject] と書籍リストを保持）。
library;

import '../../fundamental/debug/debug_logger.dart';
import '../../fundamental/model/base_objects_model.dart';
import 'reading_book_value_object.dart';
import 'reading_books_value_object.dart';

/// 読書中の書籍の状態モデル。
class ReadingBooksState extends StateObject<ReadingBooksValueObject> {
  /// コンストラクタ（テスト用に初期値を指定可能）。
  ReadingBooksState({ReadingBooksValueObject? overrideValue})
    : _overrideValue = overrideValue;

  /// テスト用に渡された初期値。
  ReadingBooksValueObject? _overrideValue;

  /// 現在のカレントな書籍リスト。
  @override
  late ReadingBooksValueObject valueObject;

  /// 初期化。
  ///
  /// `overrideValue` が指定されていればその値で初期化し、
  /// 指定されていなければダミー書籍 3 件を含む初期値を設定する。
  @override
  void init() {
    final ReadingBooksValueObject? override = _overrideValue;
    if (override != null) {
      serialNumber = 0;
      update(override);
      _overrideValue = null;
      return;
    }
    // FIXME: 後でサーバーから取得する（ENV-06 により今回はメモリ内ダミー）。
    const ReadingBooksValueObject initialValue = ReadingBooksValueObject(
      readingBooks: <ReadingBookValueObject>[],
    );
    update(initialValue);
    serialNumber = 0;
    updateReadingBooks(const <ReadingBookValueObject>[
      ReadingBookValueObject(name: 'Flutter入門', totalPages: 100),
      ReadingBookValueObject(name: 'Flutter実践', totalPages: 350),
      ReadingBookValueObject(
        name: 'Introduction to Flutter for Beginners.',
        totalPages: 87,
      ),
    ]);
  }

  /// 破棄（ENV-06 により永続化は行わない）。
  @override
  void dispose() {
    // FIXME: 後でサーバーへ送る（ENV-06 により今回は行わない）。
    valueObject = const ReadingBooksValueObject(
      readingBooks: <ReadingBookValueObject>[],
    );
    serialNumber = 0;
  }

  /// 状態の更新（VO を差し替えるたびに serialNumber をインクリメント）。
  @override
  void update(ReadingBooksValueObject value) {
    valueObject = value;
    serialNumber++;
    DebugLog.debugLog('ReadingBooksState update', info: valueObject);
  }

  /// 書籍リストを新しい VO で更新する。
  void updateReadingBooks(List<ReadingBookValueObject> books) {
    update(ReadingBooksValueObject(readingBooks: books));
  }

  /// 現在のカレントな書籍リスト。
  List<ReadingBookValueObject> get readingBooks => valueObject.readingBooks;
}
