/// 進捗達成アニメーション（完成版）。
library;

import 'package:flutter/material.dart';

import 'dynamic_background_widget.dart';
import 'progress_circle_widget.dart';
import 'ripple_effect_widget.dart';
import 'sparkle_effect_widget.dart';
import 'title_text_widget.dart';
import 'message_text_widget.dart';

/// 進捗達成アニメーション。
///
/// 複数（7 個）の [AnimationController] と 8 種類のアニメーションで
/// 構成された演出を提供する。
class ProgressAchievementAnimation extends StatefulWidget {
  /// コンストラクタ。
  const ProgressAchievementAnimation({
    required this.progressPercentage,
    required this.message,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.isCompletion,
    this.bookName = '',
    super.key,
  });

  /// 進捗率（整数パーセント）。
  final int progressPercentage;

  /// メッセージ。
  final String message;

  /// 主色。
  final Color primaryColor;

  /// 副色。
  final Color secondaryColor;

  /// 中央アイコン。
  final IconData icon;

  /// 完読かどうか。
  final bool isCompletion;

  /// 書名。
  final String bookName;

  @override
  State<ProgressAchievementAnimation> createState() =>
      _ProgressAchievementAnimationState();
}

class _ProgressAchievementAnimationState
    extends State<ProgressAchievementAnimation>
    with TickerProviderStateMixin {
  /// main（1500ms）。
  late final AnimationController _mainController;

  /// progress（2000ms）。
  late final AnimationController _progressController;

  /// particle（4000ms）。
  late final AnimationController _particleController;

  /// pulse（800ms）。
  late final AnimationController _pulseController;

  /// ripple（2500ms）。
  late final AnimationController _rippleController;

  /// sparkle（3500ms）。
  late final AnimationController _sparkleController;

  /// background（5000ms）。
  late final AnimationController _backgroundController;

  /// fade：main の Interval(0, 0.5, easeOutCubic)。
  late final Animation<double> _fade;

  /// scale：main の Interval(0.1, 0.7, elasticOut)。
  late final Animation<double> _scale;

  /// bounce：main の Interval(0.5, 1, bounceOut)。
  late final Animation<double> _bounce;

  /// progress：easeOutQuart。
  late final Animation<double> _progressAnimation;

  /// pulse：Tween(0.95→1.15) + easeInOutSine。
  late final Animation<double> _pulse;

  /// ripple：easeOutQuart。
  late final Animation<double> _ripple;

  /// sparkle：easeInOut。
  late final Animation<double> _sparkle;

  /// background：easeInOutSine。
  late final Animation<double> _background;

  @override
  void initState() {
    // FIXME コードを完成させてください。
    // ステップ1: アニメーション設定の分割（再生時間・動き・dispose）
    // 正解のコード（コメントアウト）:
    // _mainController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1500),
    // );
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _fade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0, 0.5, curve: Curves.easeOutCubic),
    );
    _scale = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.1, 0.7, curve: Curves.elasticOut),
    );
    _bounce = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1, curve: Curves.bounceOut),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutQuart,
    );
    _pulse = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
    _ripple = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutQuart,
    );
    _sparkle = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    );
    _background = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOutSine,
    );

    // 再生シーケンスはステッ 3 で設定する。
    // FIXME コードを完成させてください。
    // ステップ3: アニメーションの配置と実行
    // 正解のコード（コメントアウト）:
    // _backgroundController.repeat(reverse: true);
    // _pulseController.repeat(reverse: true);
    // _mainController.forward();
    // _rippleController.forward();
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _progressController.forward();
      }
    });
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) {
        return;
      }
      _sparkleController.repeat();
    });
    final Duration particleDelay = widget.isCompletion
        ? const Duration(milliseconds: 1200)
        : const Duration(milliseconds: 1600);
    Future<void>.delayed(particleDelay, () {
      if (mounted) {
        _particleController.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _progressController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _sparkleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    // FIXME コードを完成させてください。
    // ステップ1: 複数コントローラの統合監視
    // 正解のコード（コメントアウト）:
    // final Listenable merged = Listenable.merge(<Listenable>[
    //   _mainController,
    //   _progressAnimation,
    //   _pulse,
    // ]);
    final Listenable merged = _mainController;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DynamicBackgroundWidget(
              animation: _background,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            RippleEffectWidget(
              animation: _ripple,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            AnimatedBuilder(
              animation: merged,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: _fade,
                  child: Transform.scale(
                    scale: _scale.value * (1 + _bounce.value * 0.02),
                    child: child,
                  ),
                );
              },
              child: _buildMainContent(),
            ),
            // FIXME コードを完成させてください。
            // ステップ4: 2層目の波紋、他のアニメーションの重ね合わせ
            // 正解のコード（コメントアウト）:
            // if (widget.isCompletion)
            //   ParticleEffectWidget(
            //     animation: _particleController,
            //     color: widget.primaryColor,
            //   ),
            SparkleEffectWidget(
              animation: _sparkle,
              isCompletion: widget.isCompletion,
              color: widget.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  /// メインコンテンツ（幅 400 の Column）。
  Widget _buildMainContent() {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ProgressCircleWidget(
            progress: _progressAnimation.value,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            icon: widget.icon,
            pulse: _pulse.value,
          ),
          const SizedBox(height: 32),
          TitleTextWidget(bookName: widget.bookName),
          const SizedBox(height: 16),
          MessageTextWidget(
            message: widget.message,
            primaryColor: widget.primaryColor,
          ),
        ],
      ),
    );
  }
}
