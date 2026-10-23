import 'package:flutter/foundation.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';
import 'package:conference_handson_2025/src/fundamental/model/equatable_utils.dart';

/// 読書状態を表す列挙型。
enum ReadingState {
  /// 未着手
  unstarted,

  /// 読書中
  reading,

  /// 読了
  complete,
}

/// 読書対象書籍の不変値オブジェクト。
@immutable
class ReadingBookValueObject extends ValueObject {
  /// コンストラクタ。
  const ReadingBookValueObject({
    required this.name,
    required this.totalPages,
    this.readingPageNum = 0,
    this.bookReview = '',
    super.stateType = ReadingBookValueObject,
  });

  /// JSON から復元するファクトリコンストラクタ。
  factory ReadingBookValueObject.fromJson(Map<String, dynamic> json) {
    return ReadingBookValueObject(
      name: json['name'] as String,
      totalPages: json['totalPages'] as int,
      readingPageNum: json['readingPageNum'] as int? ?? 0,
      bookReview: json['bookReview'] as String? ?? '',
    );
  }

  /// 書籍タイトル。
  final String name;

  /// 総ページ数。
  final int totalPages;

  /// 現在の読書完了ページ数。
  final int readingPageNum;

  /// 書籍の感想。
  final String bookReview;

  /// 読了したかどうか。
  bool get isComplete => readingPageNum == totalPages;

  /// 読書状態。
  ReadingState get readingState {
    if (isComplete) {
      return ReadingState.complete;
    }
    if (readingPageNum == 0) {
      return ReadingState.unstarted;
    }
    return ReadingState.reading;
  }

  /// 値を変更した新しいインスタンスを生成する。
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

  /// JSON マップに変換する。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'stateType': stateType.toString(),
        'name': name,
        'totalPages': totalPages,
        'readingPageNum': readingPageNum,
        'bookReview': bookReview,
      };

  @override
  List<Object?> get props => <Object?>[
        stateType,
        name,
        totalPages,
        readingPageNum,
        bookReview,
      ];

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingBookValueObject && equals(props, other.props));
}
