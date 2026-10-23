/// 読書中の書籍の読書状態（枚举）を定義する。
library;

/// 読書中の状態。
enum ReadingState {
  /// 未読。
  unstarted,

  /// 読書中。
  reading,

  /// 読了。
  complete,
}
