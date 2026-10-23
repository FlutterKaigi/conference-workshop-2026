/// ドーナツアニメーションの状態。
library;

import 'package:flutter/material.dart';

/// ドーナツアニメーションの状態。
class DonutAnimationState {
  /// 現在の対象の進捗率。
  double progressValue = 0;

  /// pulse 値（0〜1）。
  double pulseValue = 0;

  AnimationController? _animationController;
  Animation<double>? _progressAnimation;
  bool _isDisposed = false;
  final Duration _animationDuration = const Duration(milliseconds: 2000);

  /// 対象の進捗率を設定する。
  void setProgressValue(double value) {
    progressValue = value;
  }

  /// [vsync] を用いてアニメーションを初期化する。
  void initializeAnimations(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: _animationDuration,
    );
    // animateToProgress 内で Tween の再生成と reset / forward が必要。
  }

  /// 現在の対象の進捗値。
  double get animatedProgress => _progressAnimation?.value ?? progressValue;

  /// 現在のアニメーションのコントローラ。
  AnimationController? get animationController => _animationController;

  /// 対象の進捗をアニメーションで遷移する。
  void animateToProgress(double target) {
    final AnimationController? controller = _animationController;
    if (progressValue == target || _isDisposed || controller == null) {
      return;
    }
    // FIXME コードを完成させてください。
    // ステップ2: Tween の再生成と reset / forward
    // 正解のコード（コメントアウト）:
    // _progressAnimation = Tween<double>(
    //   begin: _progressAnimation?.value ?? 0,
    //   end: target,
    // ).animate(
    //   CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    // );
    // controller.reset();
    // controller.forward();
    // 仮コード: Tween を再生成せず、値のみを設定する。
    progressValue = target;
  }

  /// pulse アニメーションを発火する。
  void triggerPulseAnimation() {
    pulseValue = 1;
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!_isDisposed) {
        pulseValue = 0;
      }
    });
  }

  /// 破棄（二重破棄を防止する）。
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _animationController?.dispose();
    _animationController = null;
    _progressAnimation = null;
  }
}
