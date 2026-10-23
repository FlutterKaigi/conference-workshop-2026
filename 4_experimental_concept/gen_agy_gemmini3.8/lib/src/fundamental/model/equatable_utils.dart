// MIT License
//
// Copyright (c) 2019 Felix Angelov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/foundation.dart';

/// props から Jenkins ハッシュ値を算出する。
@pragma('vm:prefer-inline')
int mapPropsToHashCode(Iterable<Object?>? props) {
  return _finish(_combineProps(0, props));
}

@pragma('vm:prefer-inline')
int _combine(int hash, Object? object) {
  int nextHash = 0x1fffffff & (hash + object.hashCode);
  nextHash = 0x1fffffff & (nextHash + ((0x0007ffff & nextHash) << 10));
  return nextHash ^ (nextHash >> 6);
}

@pragma('vm:prefer-inline')
int _combineProps(int hash, Iterable<Object?>? props) {
  if (props == null) {
    return hash;
  }
  int nextHash = hash;
  for (final Object? prop in props) {
    if (prop is Iterable<Object?>) {
      nextHash = _combineProps(nextHash, prop);
    } else if (prop is Map<Object?, Object?>) {
      for (final MapEntry<Object?, Object?> entry in prop.entries) {
        nextHash = _combine(nextHash, entry.key);
        nextHash = _combine(nextHash, entry.value);
      }
    } else {
      nextHash = _combine(nextHash, prop);
    }
  }
  return nextHash;
}

@pragma('vm:prefer-inline')
int _finish(int hash) {
  int nextHash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  nextHash = nextHash ^ (nextHash >> 11);
  return 0x1fffffff & (nextHash + ((0x00003fff & nextHash) << 15));
}

/// 2つの Iterable の等価性を比較する。
@pragma('vm:prefer-inline')
bool equals(Iterable<Object?>? list1, Iterable<Object?>? list2) {
  if (identical(list1, list2)) {
    return true;
  }
  if (list1 == null || list2 == null) {
    return false;
  }
  final int length = list1.length;
  if (length != list2.length) {
    return false;
  }

  final Iterator<Object?> iter1 = list1.iterator;
  final Iterator<Object?> iter2 = list2.iterator;

  while (iter1.moveNext() && iter2.moveNext()) {
    final Object? item1 = iter1.current;
    final Object? item2 = iter2.current;

    if (identical(item1, item2)) {
      continue;
    }
    if (item1 == null || item2 == null) {
      return false;
    }
    if (item1.runtimeType != item2.runtimeType) {
      return false;
    }

    if (item1 is Iterable<Object?> && item2 is Iterable<Object?>) {
      if (item1 is Set<Object?> && item2 is Set<Object?>) {
        if (!setEquals(item1, item2)) {
          return false;
        }
      } else if (!equals(item1, item2)) {
        return false;
      }
    } else if (item1 is Map<Object?, Object?> &&
        item2 is Map<Object?, Object?>) {
      if (!mapEquals(item1, item2)) {
        return false;
      }
    } else if (item1 != item2) {
      return false;
    }
  }

  return true;
}
