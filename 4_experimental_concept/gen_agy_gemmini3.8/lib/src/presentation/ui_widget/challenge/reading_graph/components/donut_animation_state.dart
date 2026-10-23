import 'dart:async';
import 'package:flutter/material.dart';

/// ドーナツチャートのアニメーション状態クラス（ハンズオン演習版）。
class DonutAnimationState {
  AnimationController? progressController;
  Animation<double>? progressAnimation;

  double progressValue = 0.0;
  double pulseValue = 0.0;
  double _targetProgress = 0.0;
  bool _isDisposed = false;

  /// アニメーション適用後の進捗率を取得する。
  double get animatedProgress => progressAnimation?.value ?? progressValue;

  /// アニメーションを初期化する。
  void initializeAnimations(TickerProvider vsync) {
    if (progressController != null) {
      return;
    }

    progressController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );

    progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: progressController!,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  /// 目標進捗値へアニメーションする。
  void animateToProgress(double target) {
    if (_targetProgress == target || progressController == null) {
      return;
    }

    _targetProgress = target;
    // FIXME コードを完成させてください。
    // ステップ2: Tween の再生成と reset / forward
    /*
    final double current = animatedProgress;
    progressAnimation = Tween<double>(begin: current, end: target).animate(
      CurvedAnimation(
        parent: progressController!,
        curve: Curves.easeOutCubic,
      ),
    );
    progressController!.reset();
    progressController!.forward();
    */
    progressValue = target;
  }

  /// パルスアニメーションをトリガーする。
  void triggerPulseAnimation() {
    pulseValue = 1.0;
    Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed) {
        pulseValue = 0.0;
      }
    });
  }

  /// 破棄処理。
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    progressController?.dispose();
    progressController = null;
    progressAnimation = null;
  }
}
