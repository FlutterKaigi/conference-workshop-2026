import 'dart:async';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/dynamic_background_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/message_text_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/particle_effect_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/progress_circle_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/ripple_effect_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/sparkle_effect_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/title_text_widget.dart';
import 'package:flutter/material.dart';

/// 進捗達成アニメーションの複合ウィジェット（ハンズオン演習版）。
class ProgressAchievementAnimation extends StatefulWidget {
  /// コンストラクタ。
  const ProgressAchievementAnimation({
    required this.targetPercentage,
    required this.message,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconData,
    this.isCompletion = false,
    this.title,
    super.key,
  });

  /// 達成パーセンテージ。
  final int targetPercentage;

  /// メッセージ。
  final String message;

  /// 書籍タイトル。
  final String? title;

  /// メインカラー。
  final Color primaryColor;

  /// サブカラー。
  final Color secondaryColor;

  /// アイコン。
  final IconData iconData;

  /// 完読フラグ。
  final bool isCompletion;

  @override
  State<ProgressAchievementAnimation> createState() =>
      _ProgressAchievementAnimationState();
}

class _ProgressAchievementAnimationState
    extends State<ProgressAchievementAnimation> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _progressController;
  late final AnimationController _particleController;
  late final AnimationController _pulseController;
  late final AnimationController _rippleController;
  late final AnimationController _sparkleController;
  late final AnimationController _backgroundController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _progressAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rippleAnimation;
  late final Animation<double> _sparkleAnimation;
  late final Animation<double> _backgroundAnimation;

  final List<Timer> _timers = <Timer>[];

  @override
  void initState() {
    super.initState();

    // FIXME コードを完成させてください。
    // ステップ1: アニメーション設定の分割（再生時間・動き・dispose）
    /*
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
    */
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

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.1, 0.7, curve: Curves.elasticOut),
    );
    _bounceAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutQuart,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutQuart,
    );
    _sparkleAnimation = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOutSine,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // FIXME コードを完成させてください。
    // ステップ3: アニメーションの配置と実行
    /*
    _backgroundController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _mainController.forward();
    _rippleController.forward();

    _timers.add(
      Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          _progressController.forward();
        }
      }),
    );

    _timers.add(
      Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
          _sparkleController.repeat();
        }
      }),
    );

    final int particleDelay = widget.isCompletion ? 1400 : 1800;
    _timers.add(
      Timer(Duration(milliseconds: particleDelay), () {
        if (mounted) {
          _particleController.forward();
        }
      }),
    );
    */
    _backgroundController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _mainController.forward();
    _rippleController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    for (final Timer timer in _timers) {
      timer.cancel();
    }
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
    final Size size = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DynamicBackgroundWidget(
              animation: _backgroundAnimation,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            // FIXME コードを完成させてください。
            // ステップ4: ２層目の波紋、他のアニメーションの重ね合わせ
            /*
            RippleEffectWidget(
              animation: _rippleAnimation,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            */
            RippleEffectWidget(
              animation: _rippleAnimation,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            // FIXME コードを完成させてください。
            // ステップ1: 複数コントローラの統合監視
            /*
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[
                _mainController,
                _progressController,
                _pulseController,
              ]),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value * _bounceAnimation.value,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ProgressCircleWidget(
                      progressAnimation: _progressAnimation,
                      pulseAnimation: _pulseAnimation,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      iconData: widget.iconData,
                      targetPercentage: widget.targetPercentage,
                    ),
                    const SizedBox(height: 32),
                    TitleTextWidget(
                      title: widget.title,
                      primaryColor: widget.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    MessageTextWidget(
                      message: widget.message,
                      primaryColor: widget.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            */
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[
                _mainController,
                _progressController,
                _pulseController,
              ]),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value * _bounceAnimation.value,
                    child: child,
                  ),
                );
              },
              // FIXME コードを完成させてください。
              // ステップ2: プログレス円とアイコンの配置
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ProgressCircleWidget(
                      progressAnimation: _progressAnimation,
                      pulseAnimation: _pulseAnimation,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      iconData: widget.iconData,
                      targetPercentage: widget.targetPercentage,
                    ),
                    const SizedBox(height: 32),
                    TitleTextWidget(
                      title: widget.title,
                      primaryColor: widget.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    MessageTextWidget(
                      message: widget.message,
                      primaryColor: widget.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isCompletion)
              ParticleEffectWidget(
                animation: _particleController,
                primaryColor: widget.primaryColor,
                secondaryColor: widget.secondaryColor,
              ),
            SparkleEffectWidget(
              animation: _sparkleAnimation,
              isCompletion: widget.isCompletion,
              primaryColor: widget.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
