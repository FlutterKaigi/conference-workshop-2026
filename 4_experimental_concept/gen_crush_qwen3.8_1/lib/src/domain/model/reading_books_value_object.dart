/// 読書中の書籍リストの値オブジェクト。
library;

import 'package:flutter/foundation.dart';

import '../../fundamental/model/base_objects_model.dart';
import '../../fundamental/model/equatable_utils.dart';
import 'reading_books_state.dart';
import 'reading_book_value_object.dart';

/// 読書中の書籍リストの値オブジェクト。
@immutable
class ReadingBooksValueObject extends ValueObject {
  /// 定数コンストラクタ。
  const ReadingBooksValueObject({
    this.readingBooks = const <ReadingBookValueObject>[],
  }) : super(stateType: ReadingBooksState);

  /// 読書中の書籍のリスト。
  final List<ReadingBookValueObject> readingBooks;

  /// Map から [ReadingBooksValueObject] を生成する。
  factory ReadingBooksValueObject.fromJson(Map<String, dynamic> json) {
    return ReadingBooksValueObject(
      readingBooks: (json['readingBooks'] as List<dynamic>)
          .map(
            (dynamic e) => ReadingBookValueObject.fromJson(
              (e as Map<Object?, dynamic>).cast<String, dynamic>(),
            ),
          )
          .cast<ReadingBookValueObject>()
          .toList(),
    );
  }

  /// JSON の [Map] に変換する。
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'stateType': stateType,
      'readingBooks': readingBooks
          .map((ReadingBookValueObject e) => e.toJson())
          .toList(),
    };
  }

  /// 一部のプロパティを差し替えた新しいインスタンスを生成する。
  ReadingBooksValueObject copyWith({
    List<ReadingBookValueObject>? readingBooks,
  }) {
    return ReadingBooksValueObject(
      readingBooks: readingBooks ?? this.readingBooks,
    );
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ReadingBooksValueObject && equals(props, other.props);
  }

  @override
  List<Object> get props => <Object>[stateType, readingBooks];

  @override
  String toString() =>
      'ReadingBooksValueObject ({readingBooks: $readingBooks })';
}
