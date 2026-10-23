import 'package:flutter/foundation.dart';
import 'package:conference_handson_2025/src/fundamental/error/default_abnormal.dart';

/// デバッグログの設定クラス。
class DebugLog {
  DebugLog._();

  /// デバッグログの出力可否フラグ。
  static bool isDebugMode = true;
}

/// デバッグログを出力する。
void debugLog(
  String message, {
  Object? info,
  Object? cause,
}) {
  if (kDebugMode && (DebugLog.isDebugMode || cause != null)) {
    debugPrint(createDebugOutText(message, info: info, cause: cause));
  }
}

/// デバッグ用の出力文字列を生成する。
String createDebugOutText(
  String message, {
  Object? info,
  Object? cause,
}) {
  final StringBuffer buffer = StringBuffer();
  if (info != null) {
    buffer.write('${info.runtimeType}: $message');
  } else {
    buffer.write(message);
  }

  if (cause != null) {
    buffer.writeln();
    _appendCause(buffer, cause);
  }

  return buffer.toString();
}

void _appendCause(StringBuffer buffer, Object cause) {
  if (cause is DefaultAbnormal) {
    buffer.writeln('${cause.runtimeType}: ${cause.message}');
    buffer.writeln(cause.stackTrace);
    final Object? nextCause = cause.error ?? cause.exception ?? cause.cause;
    if (nextCause != null && nextCause != cause) {
      _appendCause(buffer, nextCause);
    }
  } else {
    buffer.writeln('${cause.runtimeType}: $cause');
    if (cause is Error && cause.stackTrace != null) {
      buffer.writeln(cause.stackTrace);
    }
  }
}
