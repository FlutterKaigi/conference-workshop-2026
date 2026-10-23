import 'package:conference_handson_2025/src/application/model/application_model.dart';
import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/staged_widget.dart';
import 'package:conference_handson_2025/src/routing/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// アプリケーションルートウィジェット。
// ignore: must_be_immutable
class App extends StagedWidget<ApplicationModel> {
  /// コンストラクタ。
  App({
    super.key,
    super.isWidgetsBindingObserve = true,
    this.overrideReadingBooksDomain,
  });

  /// テスト等で注入可能なドメインモデル。
  final ReadingBooksDomainModel? overrideReadingBooksDomain;

  @override
  ApplicationModel createWidgetState() => ApplicationModel(
        overrideReadingBooksDomain: overrideReadingBooksDomain,
      );

  @override
  void initState(ApplicationModel? state) {
    state?.initState();
  }

  @override
  void disposeState(ApplicationModel? state) {
    state?.disposeState();
  }

  @override
  Widget build(BuildContext context, ApplicationModel? state) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ReadingBooksDomainModel?>(
        'overrideReadingBooksDomain',
        overrideReadingBooksDomain,
      ),
    );
  }
}
