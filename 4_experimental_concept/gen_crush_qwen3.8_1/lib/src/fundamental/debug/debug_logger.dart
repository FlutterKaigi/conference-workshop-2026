/// デバッグログ出力ユーティリティ。
library;

import 'package:flutter/foundation.dart';

import '../error/default_abnormal.dart';

/// デバッグログユーティリティ。
class DebugLog {
  /// 使用を禁止するコンストラクタ。
  DebugLog._();

  /// デバッグモードが有効かどうか。
  static bool isDebugMode = true;

  /// 引数からデバッグ出力用の文字列を生成する。
  static String createDebugOutText(
    String message, {
    Object? info,
    Object? cause,
  }) {
    final StringBuffer buffer = StringBuffer(info != null ? '$info: ' : '');
    buffer.write(message);
    if (cause is DefaultAbnormal) {
      // error → exception の順に原因を再帰的に辿る。
      final DefaultAbnormal? errorCause = cause.error;
      if (errorCause != null) {
        buffer
          ..write(' error: ${errorCause.causeType}: ${errorCause.message}')
          ..write('\n${errorCause.stackTrace}');
      }
      final DefaultAbnormal? exceptionCause = cause.exception;
      if (exceptionCause != null) {
        buffer
          ..write(
            ' exception: ${exceptionCause.causeType}: '
            '${exceptionCause.message}',
          )
          ..write('\n${exceptionCause.stackTrace}');
      }
    } else if (cause != null) {
      buffer..write(' cause: ${cause.runtimeType}: ${cause.toString()}');
      if (cause is Error) {
        buffer..write('\n${cause.stackTrace}');
      }
    }
    return buffer.toString();
  }

  /// デバッグログを出力する。
  ///
  /// [kDebugMode] かつ（[isDebugMode] または [cause] が指定された場合）
  /// にのみ [debugPrint] を実行する。
  static void debugLog(String message, {Object? info, Object? cause}) {
    if (kDebugMode && (isDebugMode || cause != null)) {
      debugPrint(createDebugOutText(message, info: info, cause: cause));
    }
  }
}
