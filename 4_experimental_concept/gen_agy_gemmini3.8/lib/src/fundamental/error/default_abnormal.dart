import 'package:flutter/foundation.dart';

/// 異常系の共通インターフェース。
abstract interface class DefaultAbnormal {
  /// メッセージを取得する。
  String get message;

  /// 内包するエラーを取得する。
  Error? get error;

  /// 内包する例外を取得する。
  Exception? get exception;

  /// 原因オブジェクトを取得する。
  Object? get cause;

  /// スタックトレースを取得する。
  StackTrace get stackTrace;

  /// エラーを保持しているかどうか。
  bool get hasError;

  /// 例外を保持しているかどうか。
  bool get hasException;

  /// 原因オブジェクトの型。
  Type? get causeType;
}

/// アプリ共通のエラー基底クラス。
@immutable
class DefaultError extends Error implements DefaultAbnormal {
  /// コンストラクタ。
  DefaultError(this.message, {this.cause})
      : error = cause is Error ? cause : null,
        exception = cause is Exception ? cause : null,
        stackTrace = cause is Error
            ? (cause.stackTrace ?? StackTrace.current)
            : StackTrace.current;

  @override
  final String message;

  @override
  final Object? cause;

  @override
  final Error? error;

  @override
  final Exception? exception;

  @override
  final StackTrace stackTrace;

  /// クラス名を取得する。
  String get name => runtimeType.toString();

  @override
  bool get hasError => error != null;

  @override
  bool get hasException => exception != null;

  @override
  Type? get causeType => cause?.runtimeType;

  @override
  String toString() {
    final String causeName = causeType != null ? '$causeType' : 'none';
    return '$name on $causeName: $message\n$stackTrace';
  }
}

/// アプリ共通の例外基底クラス。
@immutable
class DefaultException implements Exception, DefaultAbnormal {
  /// コンストラクタ。
  DefaultException(this.message, {this.cause})
      : error = cause is Error ? cause : null,
        exception = cause is Exception ? cause : null,
        stackTrace = cause is Error
            ? (cause.stackTrace ?? StackTrace.current)
            : StackTrace.current;

  @override
  final String message;

  @override
  final Object? cause;

  @override
  final Error? error;

  @override
  final Exception? exception;

  @override
  final StackTrace stackTrace;

  /// クラス名を取得する。
  String get name => runtimeType.toString();

  @override
  bool get hasError => error != null;

  @override
  bool get hasException => exception != null;

  @override
  Type? get causeType => cause?.runtimeType;

  @override
  String toString() {
    final String causeName = causeType != null ? '$causeType' : 'none';
    return '$name on $causeName: $message\n$stackTrace';
  }
}
