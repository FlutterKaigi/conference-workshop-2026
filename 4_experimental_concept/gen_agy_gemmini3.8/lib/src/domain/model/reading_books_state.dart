import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';

/// 読書中書籍一覧の状態モデル。
class ReadingBooksState extends StateObject<ReadingBooksValueObject> {
  /// コンストラクタ。
  ReadingBooksState({ReadingBooksValueObject? overrideValue})
      : _overrideValue = overrideValue;

  ReadingBooksValueObject? _overrideValue;
  ReadingBooksValueObject? _valueObject;
  int _serialNumber = 0;

  @override
  int get serialNumber => _serialNumber;

  @override
  ReadingBooksValueObject get valueObject => _valueObject!;

  /// 書籍リストを取得する。
  List<ReadingBookValueObject> get readingBooks => valueObject.readingBooks;

  @override
  void init() {
    if (_overrideValue != null) {
      _serialNumber = 0;
      update(_overrideValue!);
      _overrideValue = null;
      return;
    }

    _valueObject = const ReadingBooksValueObject();
    _serialNumber = 0;
    updateReadingBooks(const <ReadingBookValueObject>[
      ReadingBookValueObject(
        name: 'Flutter入門',
        totalPages: 100,
      ),
      ReadingBookValueObject(
        name: 'Flutter実践',
        totalPages: 350,
      ),
      ReadingBookValueObject(
        name: 'Introduction to Flutter for Beginners.',
        totalPages: 87,
      ),
    ]);
  }

  @override
  void dispose() {
    _valueObject = null;
    _serialNumber = 0;
  }

  @override
  void update(ReadingBooksValueObject value) {
    _valueObject = value;
    _serialNumber++;
  }

  /// 書籍リストを新しい値オブジェクトで更新する。
  void updateReadingBooks(List<ReadingBookValueObject> list) {
    update(ReadingBooksValueObject(readingBooks: list));
  }
}
