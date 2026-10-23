/// アプリケーションのデフォルトの異常（[Error] / [Exception]）クラス。
library;

import 'package:flutter/foundation.dart';

/// このリポジトリのデフォルトの異常に共通するインターフェース。
abstract interface class DefaultAbnormal {
  /// 例外のメッセージ。
  String get message;

  /// 原因となった [DefaultError]。
  DefaultError? get error;

  /// 原因となった [DefaultException]。
  DefaultException? get exception;

  /// 原因となったオブジェクト。
  Object? get cause;

  /// スタックトレース。
  StackTrace get stackTrace;

  /// 原因が [Error] かどうか。
  bool get hasError;

  /// 原因が [Exception] かどうか。
  bool get hasException;

  /// 原因の型。
  Type? get causeType;
}

/// このリポジトリのデフォルトの [Error]。
@immutable
class DefaultError extends Error implements DefaultAbnormal {
  /// コンストラクタ。
  DefaultError(this.message, {this.cause});

  /// 例外のメッセージ。
  @override
  final String message;

  /// 原因となったオブジェクト。
  @override
  final Object? cause;

  /// 例外の名前（runtimeType 文字列）。
  String get name => runtimeType.toString();

  /// 原因が [Error] かどうか。
  @override
  bool get hasError => cause is Error;

  /// 原因が [Exception] かどうか。
  @override
  bool get hasException => cause is Exception;

  /// 原因の型。
  @override
  Type? get causeType => cause?.runtimeType;

  /// 原因となった [DefaultError]。
  @override
  DefaultError? get error =>
      cause is DefaultError ? cause as DefaultError : null;

  /// 原因となった [DefaultException]。
  @override
  DefaultException? get exception =>
      cause is DefaultException ? cause as DefaultException : null;

  /// スタックトレース（cause が [Error] ならその stackTrace、
  /// それ以外は [StackTrace.current]）。
  @override
  StackTrace get stackTrace {
    final Object? causeValue = cause;
    if (causeValue is Error) {
      return _extractStackTrace(causeValue);
    }
    return StackTrace.current;
  }

  @override
  String toString() => 'Error: $name on 原因型: $message\n$stackTrace';
}

/// このリポジトリのデフォルトの [Exception]。
@immutable
class DefaultException implements Exception, DefaultAbnormal {
  /// コンストラクタ。
  DefaultException(this.message, {this.cause});

  /// 例外のメッセージ。
  @override
  final String message;

  /// 原因となったオブジェクト。
  @override
  final Object? cause;

  /// 例外の名前（runtimeType 文字列）。
  String get name => runtimeType.toString();

  /// 原因が [Error] かどうか。
  @override
  bool get hasError => cause is Error;

  /// 原因が [Exception] かどうか。
  @override
  bool get hasException => cause is Exception;

  /// 原因の型。
  @override
  Type? get causeType => cause?.runtimeType;

  /// 原因となった [DefaultError]。
  @override
  DefaultError? get error =>
      cause is DefaultError ? cause as DefaultError : null;

  /// 原因となった [DefaultException]。
  @override
  DefaultException? get exception =>
      cause is DefaultException ? cause as DefaultException : null;

  /// スタックトレース（cause が [Error] ならその stackTrace、
  /// それ以外は [StackTrace.current]）。
  @override
  StackTrace get stackTrace {
    final Object? causeValue = cause;
    if (causeValue is Error) {
      return _extractStackTrace(causeValue);
    }
    return StackTrace.current;
  }

  @override
  String toString() => 'Exception: $name on 原因型: $message\n$stackTrace';
}

/// [Error] の stackTrace を取得するヘルパー。
StackTrace _extractStackTrace(Object error) {
  // ignore: avoid_dynamic_calls
  final dynamic errorCause = error;
  try {
    return errorCause.stackTrace as StackTrace;
  } catch (e) {
    return StackTrace.current;
  }
}
