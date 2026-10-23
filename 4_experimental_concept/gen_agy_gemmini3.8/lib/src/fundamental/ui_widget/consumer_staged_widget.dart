import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ConsumerStagedWidget のビルド関数の型定義。
typedef ConsumerStagedBuild<R, T> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  R value,
  T? state,
);

/// ビルダー選択関数の型定義。
typedef SelectBuilder<R, T> = ConsumerStagedBuild<R, T> Function(
  List<ConsumerStagedBuild<R, T>> builders,
  R value,
);

/// ビルダーリスト生成関数の型定義。
typedef ConsumerStagedBuilders<R, T> = List<ConsumerStagedBuild<R, T>> Function(
  BuildContext context,
  WidgetRef ref,
  R value,
  T? state,
);

/// Riverpod の状態と内部状態を組み合わせて描画を切り替える基底ウィジェット。
// ignore: must_be_immutable
abstract class ConsumerStagedWidget<R, T> extends StatefulWidget
    with WidgetsBindingObserver {
  /// コンストラクタ。
  ConsumerStagedWidget({
    required this.provider,
    this.builders,
    this.selectBuilder,
    this.isWidgetsBindingObserve = false,
    super.key,
  });

  /// Riverpod から状態値を取得する関数。
  final R Function(WidgetRef ref) provider;

  /// ビルダーリストのオーバーライド関数。
  final ConsumerStagedBuilders<R, T>? builders;

  /// ビルダー選択のオーバーライド関数。
  final SelectBuilder<R, T>? selectBuilder;

  /// ライフサイクル監視フラグ。
  final bool isWidgetsBindingObserve;

  T? _state;

  /// 内部状態を取得する。
  T? get state => _state;

  /// 内部状態を生成する。
  T? createWidgetState() => null;

  /// 初期化フック。
  void initState(T? state) {}

  /// 依存関係変更フック。
  void didChangeDependencies(T? state) {}

  /// ウィジェット更新フック。
  void didUpdateWidget(
    covariant ConsumerStagedWidget<R, T> now,
    covariant ConsumerStagedWidget<R, T> old,
    T? state,
  ) {}

  /// build 直後のセットアップフック。
  void setupState(T? state) {}

  /// 破棄フック。
  void disposeState(T? state) {}

  /// ウィジェット破棄処理。
  void dispose() {}

  /// レジューム時のフック。
  void onResumed(T? state) {}

  /// 非アクティブ時のフック。
  void onInactive(T? state) {}

  /// 一時停止時のフック。
  void onPaused(T? state) {}

  /// 非表示時のフック。
  void onHidden(T? state) {}

  /// デタッチ時のフック。
  void onDetached(T? state) {}

  /// メインのビルドメソッド。
  Widget build(BuildContext context, WidgetRef ref, R value, T? state);

  /// サブビルドメソッド群（build2〜build20）。
  Widget build2(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build3(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build4(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build5(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build6(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build7(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build8(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build9(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build10(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build11(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build12(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build13(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build14(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build15(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build16(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build17(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build18(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build19(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();
  Widget build20(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// ビルドメソッドのリストを取得する。
  List<ConsumerStagedBuild<R, T>> get buildList => <ConsumerStagedBuild<R, T>>[
        build,
        build2,
        build3,
        build4,
        build5,
        build6,
        build7,
        build8,
        build9,
        build10,
        build11,
        build12,
        build13,
        build14,
        build15,
        build16,
        build17,
        build18,
        build19,
        build20,
      ];

  /// 使用するビルダーを選択する。デフォルトは最初のビルダー。
  ConsumerStagedBuild<R, T> selectBuild(
    List<ConsumerStagedBuild<R, T>> builders,
    R value,
  ) {
    return builders[0];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed(_state);
      case AppLifecycleState.inactive:
        onInactive(_state);
      case AppLifecycleState.paused:
        onPaused(_state);
      case AppLifecycleState.hidden:
        onHidden(_state);
      case AppLifecycleState.detached:
        onDetached(_state);
        dispose();
    }
  }

  @override
  State<ConsumerStagedWidget<R, T>> createState() =>
      _ConsumerStagedWidgetState<R, T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<R Function(WidgetRef ref)>.has('provider', provider),
    );
    properties.add(
      ObjectFlagProperty<SelectBuilder<R, T>>.has(
        'selectBuilder',
        selectBuilder,
      ),
    );
    properties.add(
      ObjectFlagProperty<ConsumerStagedBuilders<R, T>>.has(
        'builders',
        builders,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'isWidgetsBindingObserve',
        isWidgetsBindingObserve,
      ),
    );
    properties.add(
      IterableProperty<ConsumerStagedBuild<R, T>>('buildList', buildList),
    );
  }
}

class _ConsumerStagedWidgetState<R, T>
    extends State<ConsumerStagedWidget<R, T>> {
  T? _state;

  @override
  void initState() {
    super.initState();
    if (widget.isWidgetsBindingObserve) {
      WidgetsBinding.instance.addObserver(widget);
    }
    _state = widget.createWidgetState();
    widget._state = _state;
    widget.initState(_state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies(_state);
  }

  @override
  void didUpdateWidget(covariant ConsumerStagedWidget<R, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._state = _state;
    widget.didUpdateWidget(widget, oldWidget, _state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final R value = widget.provider(ref);
        final List<ConsumerStagedBuild<R, T>> builders =
            widget.builders?.call(context, ref, value, _state) ??
                widget.buildList;
        final ConsumerStagedBuild<R, T> selectedBuild =
            widget.selectBuilder?.call(builders, value) ??
                widget.selectBuild(builders, value);
        final Widget result = selectedBuild(context, ref, value, _state);
        widget.setupState(_state);
        return result;
      },
    );
  }

  @override
  void dispose() {
    widget.disposeState(_state);
    widget.dispose();
    _state = null;
    widget._state = null;
    if (widget.isWidgetsBindingObserve) {
      WidgetsBinding.instance.removeObserver(widget);
    }
    super.dispose();
  }
}
