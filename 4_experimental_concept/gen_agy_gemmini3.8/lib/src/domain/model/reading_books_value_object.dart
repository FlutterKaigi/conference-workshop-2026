import 'package:flutter/foundation.dart';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';
import 'package:conference_handson_2025/src/fundamental/model/equatable_utils.dart';

/// 読書中書籍一覧の不変値オブジェクト。
@immutable
class ReadingBooksValueObject extends ValueObject {
  /// コンストラクタ。
  const ReadingBooksValueObject({
    this.readingBooks = const <ReadingBookValueObject>[],
    super.stateType = ReadingBooksValueObject,
  });

  /// JSON から復元するファクトリコンストラクタ。
  factory ReadingBooksValueObject.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rawBooks = json['readingBooks'] as List<dynamic>?;
    return ReadingBooksValueObject(
      readingBooks: rawBooks != null
          ? rawBooks
              .map(
                (item) => ReadingBookValueObject.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList()
          : const <ReadingBookValueObject>[],
    );
  }

  /// 書籍リスト。
  final List<ReadingBookValueObject> readingBooks;

  /// 書籍リストを変更した新しいインスタンスを生成する。
  ReadingBooksValueObject copyWith({
    List<ReadingBookValueObject>? readingBooks,
  }) {
    return ReadingBooksValueObject(
      readingBooks: readingBooks ?? this.readingBooks,
    );
  }

  /// JSON マップに変換する。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'stateType': stateType.toString(),
        'readingBooks': readingBooks
            .map((book) => book.toJson())
            .toList(),
      };

  @override
  List<Object?> get props => <Object?>[
        stateType,
        readingBooks,
      ];

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingBooksValueObject && equals(props, other.props));
}
