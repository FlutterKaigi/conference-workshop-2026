/// 読書中の書籍の値オブジェクト。
library;

import 'package:flutter/foundation.dart';

import '../../fundamental/model/base_objects_model.dart';
import '../../fundamental/model/equatable_utils.dart';
import 'reading_books_state.dart';
import 'reading_state.dart';

/// 読書中の書籍の値オブジェクト。
@immutable
class ReadingBookValueObject extends ValueObject {
  /// 定数コンストラクタ。
  const ReadingBookValueObject({
    required this.name,
    required this.totalPages,
    this.readingPageNum = 0,
    this.bookReview = '',
  }) : super(stateType: ReadingBooksState);

  /// 書名。
  final String name;

  /// 総ページ数。
  final int totalPages;

  /// 読書中のページ番号。
  final int readingPageNum;

  /// 書籍の感想。
  final String bookReview;

  /// Map から [ReadingBookValueObject] を生成する。
  factory ReadingBookValueObject.fromJson(Map<String, dynamic> json) {
    return ReadingBookValueObject(
      name: json['name'] as String,
      totalPages: json['totalPages'] as int,
      readingPageNum: json['readingPageNum'] as int? ?? 0,
      bookReview: json['bookReview'] as String? ?? '',
    );
  }

  /// 現在完了しているかどうか（読んだページが総ページ数に達したとき）。
  bool get isComplete => readingPageNum == totalPages;

  /// 現在の読書状態。
  ReadingState get readingState {
    if (isComplete) {
      return ReadingState.complete;
    }
    if (readingPageNum == 0) {
      return ReadingState.unstarted;
    }
    return ReadingState.reading;
  }

  /// JSON の [Map] に変換する。
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'stateType': stateType,
      'name': name,
      'totalPages': totalPages,
      'readingPageNum': readingPageNum,
      'bookReview': bookReview,
    };
  }

  /// 一部のプロパティを差し替えた新しいインスタンスを生成する。
  ReadingBookValueObject copyWith({
    String? name,
    int? totalPages,
    int? readingPageNum,
    String? bookReview,
  }) {
    return ReadingBookValueObject(
      name: name ?? this.name,
      totalPages: totalPages ?? this.totalPages,
      readingPageNum: readingPageNum ?? this.readingPageNum,
      bookReview: bookReview ?? this.bookReview,
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
    return other is ReadingBookValueObject && equals(props, other.props);
  }

  @override
  List<Object> get props => <Object>[
    stateType,
    name,
    totalPages,
    readingPageNum,
    bookReview,
  ];

  @override
  String toString() =>
      'ReadingBookValueObject '
      '({name: $name, totalPages: $totalPages, '
      'readingPageNum: $readingPageNum, bookReview: $bookReview })';
}
