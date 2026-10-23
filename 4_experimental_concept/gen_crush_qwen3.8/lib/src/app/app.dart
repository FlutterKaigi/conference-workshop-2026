/// アプリケーションのルートのウィジェット。
library;

import 'package:flutter/material.dart';

import '../application/model/application_model.dart';
import '../domain/model/reading_books_domain_model.dart';
import '../fundamental/ui_widget/staged_widget.dart';
import '../routing/app_router.dart';

/// アプリケーションのルートのウィジェット。
///
/// [StagedWidget] を継承し、内部状態 [ApplicationModel] を
/// 生成・初期化・破棄する。
class App extends StagedWidget<ApplicationModel> {
  /// コンストラクタ。
  const App({
    super.key,
    super.isWidgetsBindingObserve = true,
    this.overrideReadingBooksDomain,
  });

  /// 初期化/破棄時に渡すテスト用のドメインモデル。
  final ReadingBooksDomainModel? overrideReadingBooksDomain;

  /// 内部状態オブジェクトを作成する。
  @override
  ApplicationModel? createWidgetState() {
    return ApplicationModel(
      overrideReadingBooksDomain: overrideReadingBooksDomain,
    );
  }

  /// ウィジェットの初期化時に呼ばれる。
  @override
  void initState(ApplicationModel? state) {
    state?.initState();
  }

  /// 破棄時に呼ばれる。
  @override
  void disposeState(ApplicationModel? state) {
    state?.disposeState();
  }

  /// [MaterialApp.router] を構築する。
  @override
  Widget build(BuildContext context, ApplicationModel? state) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
