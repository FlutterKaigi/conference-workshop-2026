/// 読書進捗率達成アニメーションの ViewModel。
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/model/reading_book_value_object.dart';

/// 進捗率達成アニメーションの種別。
enum ProgressAnimationTypeEnum {
  /// アニメーションなし。
  none,

  /// 10% 達成。
  progressRate10,

  /// 50% 達成。
  progressRate50,

  /// 80% 達成。
  progressRate80,

  /// 100% 達成（読了）。
  progressRate100,
}

/// [ReadingProgressAnimationsViewModel] の [NotifierProvider]。
final NotifierProvider<
  ReadingProgressAnimationsViewModel,
  ProgressAnimationTypeEnum
>
readingProgressAnimationsProvider =
    NotifierProvider<
      ReadingProgressAnimationsViewModel,
      ProgressAnimationTypeEnum
    >(ReadingProgressAnimationsViewModel.new);

/// 読書進捗率達成アニメーションの ViewModel。
class ReadingProgressAnimationsViewModel
    extends Notifier<ProgressAnimationTypeEnum> {
  /// 初期化時に [ProgressAnimationTypeEnum.none] を返す。
  @override
  ProgressAnimationTypeEnum build() {
    return ProgressAnimationTypeEnum.none;
  }

  /// 進捗率に応じたアニメーション種別を返す。
  ProgressAnimationTypeEnum _getAnimationTypeByRate(double rate) {
    if (rate < 0.1) {
      return ProgressAnimationTypeEnum.none;
    }
    if (rate < 0.5) {
      return ProgressAnimationTypeEnum.progressRate10;
    }
    if (rate < 0.8) {
      return ProgressAnimationTypeEnum.progressRate50;
    }
    if (rate < 1.0) {
      return ProgressAnimationTypeEnum.progressRate80;
    }
    return ProgressAnimationTypeEnum.progressRate100;
  }

  /// 進捗率が変更された場合のみ、アニメーションの種別を更新する。
  void updateAnimationTypeIfProgressChange({
    required ReadingBookValueObject updatedBook,
    required int prevReadingPageNum,
  }) {
    final double prevRate = prevReadingPageNum / updatedBook.totalPages;
    final double updatedRate =
        updatedBook.readingPageNum / updatedBook.totalPages;
    final int prevIndex = _getAnimationTypeByRate(prevRate).index;
    final int updatedIndex = _getAnimationTypeByRate(updatedRate).index;
    if (updatedIndex > prevIndex) {
      updateAnimationType(animationType: _getAnimationTypeByRate(updatedRate));
    }
  }

  /// アニメーションの種別を更新する（10 秒後に [ProgressAnimationTypeEnum.none] に戻す）。
  void updateAnimationType({required ProgressAnimationTypeEnum animationType}) {
    state = animationType;
    Timer(const Duration(seconds: 10), () {
      state = ProgressAnimationTypeEnum.none;
    });
  }
}
