import 'dart:async';
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗アニメーションの種類を表す列挙型。
enum ProgressAnimationTypeEnum {
  /// アニメーションなし
  none,

  /// 進捗率 10%
  progressRate10,

  /// 進捗率 50%
  progressRate50,

  /// 進捗率 80%
  progressRate80,

  /// 進捗率 100%
  progressRate100,
}

/// 読書進捗アニメーションのプロバイダ。
final NotifierProvider<ReadingProgressAnimationsViewModel,
        ProgressAnimationTypeEnum> readingProgressAnimationsProvider =
    NotifierProvider<ReadingProgressAnimationsViewModel,
        ProgressAnimationTypeEnum>(
  ReadingProgressAnimationsViewModel.new,
);

/// 読書進捗アニメーションの ViewModel。
class ReadingProgressAnimationsViewModel
    extends Notifier<ProgressAnimationTypeEnum> {
  Timer? _timer;

  @override
  ProgressAnimationTypeEnum build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return ProgressAnimationTypeEnum.none;
  }

  /// 進捗率からアニメーション種別を判定する。
  static ProgressAnimationTypeEnum calculateType(
    int readingPage,
    int totalPages,
  ) {
    if (totalPages <= 0) {
      return ProgressAnimationTypeEnum.none;
    }
    final double rate = readingPage / totalPages;
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

  /// 進捗率が上昇した場合にアニメーション種別を更新する。
  void updateAnimationTypeIfProgressChange({
    required ReadingBookValueObject updatedBook,
    required int prevReadingPageNum,
  }) {
    final ProgressAnimationTypeEnum prevType = calculateType(
      prevReadingPageNum,
      updatedBook.totalPages,
    );
    final ProgressAnimationTypeEnum newType = calculateType(
      updatedBook.readingPageNum,
      updatedBook.totalPages,
    );

    if (newType.index > prevType.index) {
      updateAnimationType(animationType: newType);
    }
  }

  /// アニメーション種別を更新し、10秒後にリセットする。
  void updateAnimationType({
    required ProgressAnimationTypeEnum animationType,
  }) {
    _timer?.cancel();
    state = animationType;
    if (animationType != ProgressAnimationTypeEnum.none) {
      _timer = Timer(const Duration(seconds: 10), () {
        state = ProgressAnimationTypeEnum.none;
      });
    }
  }
}
