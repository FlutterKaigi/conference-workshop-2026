/// 等価性ユーティリティ。
///
/// equatable パッケージの `equatable_utils.dart` を元にした実装。
///
/// Copyright 2018, Rene Tooten
///
/// Licensed under the MIT license (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// https://opensource.org/licenses/MIT
library;

/// [props] のハッシュ値を Jenkins ハッシュで算出する。
@pragma('vm:prefer-inline')
int mapPropsToHashCode(Iterable<Object?>? props) {
  if (props == null) {
    return 0;
  }
  int hash = 0;
  final iterator = props.iterator;
  while (iterator.moveNext()) {
    hash = _combine(hash, iterator.current.hashCode);
  }
  return _finish(hash);
}

int _combine(int hash, int value) {
  hash = 0x1FFFFFFF & (hash + value);
  hash = 0x1FFFFFFF & (hash + ((0x0007FFFF & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1FFFFFFF & (hash + ((0x03FFFFFF & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1FFFFFFF & (hash + ((0x00003FFF & hash) << 15));
}

/// 2 つの [Iterable] が等価かを比較する。
///
/// 同一参照なら true、null・長さ違い・要素の runtimeType 違いなら
/// false。Iterable 要素（Set・Map）は再帰で比較し、それ以外は
/// `!=` で比較する。
bool equals(Iterable<Object?>? list1, Iterable<Object?>? list2) {
  if (list1 == null || list2 == null) {
    return list1 == list2;
  }
  if (list1.length != list2.length) {
    return false;
  }
  if (list1 == list2) {
    return true;
  }
  bool equal = true;
  final i1 = list1.iterator;
  final i2 = list2.iterator;
  while (true) {
    final bool hasNext1 = i1.moveNext();
    if (hasNext1 != i2.moveNext()) {
      return false;
    }
    if (!hasNext1) {
      break;
    }
    final Object? current1 = i1.current;
    final Object? current2 = i2.current;
    if (identical(current1, current2)) {
      continue;
    }
    if (current1 == null || current2 == null) {
      equal = false;
      break;
    }
    if (current1.runtimeType != current2.runtimeType) {
      equal = false;
      break;
    }
    if (current1 is Iterable<Object?> || current2 is Iterable<Object?>) {
      Iterable<Object?> iterable1;
      Iterable<Object?> iterable2;
      if (current1 is Set<Object?> && current2 is Set<Object?>) {
        iterable1 = current1;
        iterable2 = current2;
      } else if (current1 is Map && current2 is Map) {
        iterable1 = current1.entries
            .expand((MapEntry<Object?, Object?> e) => <Object?>[e.key, e.value])
            .toList();
        iterable2 = current2.entries
            .expand((MapEntry<Object?, Object?> e) => <Object?>[e.key, e.value])
            .toList();
      } else {
        equal = false;
        break;
      }
      equal = equals(iterable1, iterable2);
    } else {
      equal = !(current1 != current2);
    }
    if (!equal) {
      break;
    }
  }
  return equal;
}
