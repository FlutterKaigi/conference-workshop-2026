# 読書進捗応援アプリ 再現仕様書

本書は `lib/`・`test/` 配下の Dart ソースと `pubspec.yaml` の内容から、このアプリのコードを再現するための要件を要件ごとに列挙したものです。
要件 ID は `分類-連番` で表記します。

---

## 1. プロジェクト・環境要件

- **ENV-01** パッケージ名は `conference_handson_2025`、バージョン `1.0.0+1`、`publish_to: 'none'` とする。
- **ENV-02** Dart SDK 制約は `>=3.8.0 <4.0.0` とする（Flutter 3.35.1 / fvm 管理を想定）。
- **ENV-03** 依存パッケージは以下に限定する。
  - `flutter`（SDK）、`cupertino_icons: ^1.0.8`、`flutter_riverpod: ^2.6.1`、`go_router: ^16.0.0`
  - dev: `flutter_test`（SDK）、`flutter_lints: ^5.0.0`
- **ENV-04** コード生成（freezed / riverpod_generator / json_serializable 等）と `hooks_riverpod` は使用しない。不変データクラスとウィジェット内部状態は手書きで実装する。
- **ENV-05** `flutter: uses-material-design: true` を設定する。アセット・フォントは使用しない。
- **ENV-06** 永続化・外部プラグイン・アラームは使用しない。書籍データはメモリ上のダミーデータで模擬する。

## 2. アーキテクチャ要件

- **ARC-01** レイヤードアーキテクチャを採用し、上位レイヤーは下位レイヤーにのみ依存する（逆依存禁止）。
- **ARC-02** ディレクトリ構成は以下とする。

  | パス | 役割 |
  |---|---|
  | `lib/main.dart` | エントリポイント |
  | `lib/src/app/` | ルートウィジェット `App`、`screen/**` ページウィジェット |
  | `lib/src/routing/` | GoRouter ルーティング定義 |
  | `lib/src/application/model/` | アプリケーションモデル |
  | `lib/src/domain/model/` | ドメインモデル・状態モデル・値オブジェクト |
  | `lib/src/infrastructure/` | 空実装（説明用 `package_info.dart` のみ） |
  | `lib/src/presentation/model/` | ViewModel（Riverpod Notifier） |
  | `lib/src/presentation/ui_widget/` | UI ウィジェット（default / challenge / complete の 3 系統） |
  | `lib/src/fundamental/` | 基盤クラス（モデル基底、ウィジェット基底、エラー、デバッグログ） |

- **ARC-03** 状態の依存経路は `ViewModel → DomainModel → StateModel → ValueObject` とする。ドメインモデルは Riverpod を関知しない。
- **ARC-04** UI は MVVM とし、ページウィジェット（`ConsumerWidget`）が UI ウィジェットに「Riverpod の `WidgetRef` から状態値を取得する関数」を `provider` 引数で注入する。
- **ARC-05** 画面遷移は GoRouter の名前付きルートのみで行う。
- **ARC-06** `lib/src/infrastructure/package_info.dart` はコメントのみのファイルとし、インフラ層が空であることを説明する。

## 3. 基盤（fundamental）要件

### 3.1 モデル基底クラス（`fundamental/model/base_objects_model.dart`）

- **FND-01** `enum ModelCycle { init, dispose, get }` を定義する。
- **FND-02** 汎用関数 `T modelProvider<A, T>(Object approver, {ModelCycle cycle = ModelCycle.get, T? overrideModel, T Function()? initModel, T Function()? disposeModel, T? Function()? getModel, bool Function(Object)? isApproved})` を実装する。
  - `approver` が型 `A` でない場合、`isApproved(approver)` が true かつ `cycle == get` のときのみ許可し、それ以外は `ArgumentError('Unauthorized approver.')` を投げる。
  - `cycle != init` で `overrideModel` が指定された場合は `ArgumentError('Unexpected parameter paring.')`。
  - `init`：既に初期化済（`getModel()` が非 null）なら `ArgumentError('Already initialized..')`、そうでなければ `initModel()` を返す。
  - `get`：未初期化なら `ArgumentError('Non initialized.')`、そうでなければ `getModel()` を返す。
  - `dispose`：未初期化なら `ArgumentError('Non initialized.')`、そうでなければ `disposeModel()` を返す。
- **FND-03** 抽象クラス `ApplicationObject`（`initState()` / `disposeState()`）を定義する。
- **FND-04** 抽象クラス `DomainObject<S extends StateObject<ValueObject>>`（`S get stateModel` / `initState()` / `disposeState()`）を定義する。
- **FND-05** 抽象クラス `StateObject<V extends ValueObject>`（`int get serialNumber` / `V get valueObject` / `init()` / `dispose()` / `update(V value)`）を定義する。
- **FND-06** 抽象クラス `ValueObject` を定義する。`const` コンストラクタで `required Type stateType` を受け取り、`List<Object> get props` を抽象プロパティとする。

### 3.2 等価性ユーティリティ（`fundamental/model/equatable_utils.dart`）

- **FND-07** equatable パッケージの `equatable_utils.dart` を元にした以下の関数を実装する（元コードは MIT ライセンス表記付きコメントとして残す）。
  - `int mapPropsToHashCode(Iterable<Object?>? props)`：Jenkins ハッシュ（`_combine` / `_finish`）で props のハッシュ値を返す。
  - `bool equals(Iterable<Object?>? list1, Iterable<Object?>? list2)`：同一参照なら true、null・長さ違い・要素の runtimeType 違いなら false、Iterable 要素は再帰比較（Set・Map 対応）、それ以外は `!=` で比較する。
- **FND-08** 各関数に `@pragma('vm:prefer-inline')` を付与する。

### 3.3 StagedWidget（`fundamental/ui_widget/staged_widget.dart`）

- **FND-09** `abstract class StagedWidget<T> extends StatefulWidget with WidgetsBindingObserver` を定義する。コンストラクタは `{super.key, bool isWidgetsBindingObserve = false}` とする。
- **FND-10** 派生クラスがオーバーライドするフック：`T? createWidgetState()`（必須）、`initState(T?)`、`didChangeDependencies(T?)`、`didUpdateWidget(now, old, T?)`、`setupState(T?)`（build 後）、`disposeState(T?)`、`Widget build(BuildContext, T?)`（必須）、ライフサイクル `onResumed` / `onInactive` / `onPaused` / `onHidden` / `onDetached`。
- **FND-11** 内部 State は、`initState` で（フラグが true なら）`WidgetsBinding` へのオブザーバ登録 → `createWidgetState()` → `widget.initState(state)` の順に処理する。`dispose` で `disposeState` → state を null にする → オブザーバ解除を行う。`build` 後に `setupState` を呼ぶ。`didChangeAppLifecycleState` を各 `onXxx` に振り分け、`detached` 時は `onDetached()` の後に `dispose()` を呼ぶ。
- **FND-12** 空実装の補助クラス `StagedWidgetState`（`setState(VoidCallback)` は何もしない空メソッド）を定義する。

### 3.4 ConsumerStagedWidget（`fundamental/ui_widget/consumer_staged_widget.dart`）

- **FND-13** 以下の型エイリアスを定義する。
  - `ConsumerStagedBuild<R, T> = Widget Function(BuildContext, WidgetRef, R value, T? state)`
  - `SelectBuilder<R, T> = ConsumerStagedBuild<R, T> Function(List<ConsumerStagedBuild<R, T>> builders, R value)`
  - `ConsumerStagedBuilders<R, T> = List<ConsumerStagedBuild<R, T>> Function(BuildContext, WidgetRef, R, T?)`
- **FND-14** `abstract class ConsumerStagedWidget<R, T> extends StatefulWidget` を定義する。コンストラクタは `{required R Function(WidgetRef) provider, ConsumerStagedBuilders<R,T>? builders, SelectBuilder<R,T>? selectBuilder, bool isWidgetsBindingObserve = false, super.key}` とする。
- **FND-15** StagedWidget と同じライフサイクルフック群（FND-10 と同等、ただし build は `build(context, ref, value, state)`）を提供する。
- **FND-16** `build`（抽象）と、デフォルトで `const Offstage()` を返す `build2` 〜 `build20` を定義する。これらを順に並べた `buildList` ゲッターを持つ。
- **FND-17** `selectBuild(builders, value)` のデフォルトは `builders[0]` を返す。
- **FND-18** 内部 State の build は `Consumer` でラップし、以下の順に処理する。
  1. `value = widget.provider(ref)`
  2. `builders = widget.builders?.call(...) ?? widget.buildList`
  3. `build = widget.selectBuilder?.call(builders, value) ?? widget.selectBuild(builders, value)`
  4. `build(context, ref, value, state)` を実行し、その後 `setupState` を呼ぶ
- **FND-19** `debugFillProperties` で `provider` / `selectBuild` / `buildList` / `selectBuilder` / `builders` を出力する。

### 3.5 ToggleSwitch（`fundamental/ui_widget/toggle_switch.dart`）

- **FND-20** `ToggleSwitch`（StatefulWidget、`required ToggleSwitchViewModel viewModel`）を定義する。State は initState で `viewModel._bindUpdateState(() => setState(() {}))`、dispose で `_unbindUpdateState()` を呼ぶ。`Switch(value: viewModel.isEnable, onChanged: viewModel._update)` を表示する。
- **FND-21** `ToggleSwitchViewModel({required bool initValue, required UpdateToggleSwitchState updateHandler, void Function()? onBind, void Function()? onUnBind})` を定義する。
  - `isEnable`、`isBinding`（更新関数がバインド中か）のゲッターを持つ。
  - `_update(value)`：`updateHandler(value:, updateState:)` を呼び、再描画して `_isEnable = value` とする。
  - `updateState({required bool value})`：値を更新して再描画する。
- **FND-22** `typedef UpdateToggleSwitchState = void Function({required bool value, required void Function({required bool value}) updateState})` を定義する。

### 3.6 エラー・デバッグ

- **FND-23** `DefaultError extends Error implements DefaultAbnormal` と `DefaultException implements Exception, DefaultAbnormal` を定義する（`@immutable`）。
  - コンストラクタは `(message, {cause})`。`cause` の型に応じて `error` / `exception` に振り分け、`stackTrace` は Error なら `cause.stackTrace`、それ以外は `StackTrace.current` とする。
  - `name`（runtimeType 文字列）、`hasError`、`hasException`、`causeType` を持つ。`toString()` は `"$name on 原因型: $message\n$stackTrace"` 形式とする。
- **FND-24** `abstract interface class DefaultAbnormal`（message / error / exception / cause / stackTrace / hasError / hasException / causeType）を定義する。
- **FND-25** `AppErrorHandlerDialog.showErrorAlertDialog({context, title, message, isExitApp})` を実装する。`context.mounted` のときのみ、`barrierDismissible: false`・`useRootNavigator: true` で `PopScope(canPop: false)` 付き `AlertDialog` を表示する。`isExitApp == false` のときのみ「OK」ボタンを表示する。
- **FND-26** `DebugLog.isDebugMode = true`（static）と `debugLog(String message, {Object? info, Object? cause})` を実装する。`kDebugMode` かつ（`isDebugMode` または `cause != null`）のときのみ `debugPrint` する。
- **FND-27** `createDebugOutText` は、`info` があれば `"型名: message"` とする。`cause` が `DefaultAbnormal` なら error → exception の順に原因を再帰的に辿って型名・メッセージ・スタックトレースを連結し、それ以外なら型名と `toString()`（Error ならスタックトレースも）を付加する。

## 4. ドメイン要件

### 4.1 値オブジェクト

- **DOM-01** `enum ReadingState { unstarted, reading, complete }` を定義する。
- **DOM-02** `@immutable class ReadingBookValueObject extends ValueObject` を定義する。
  - フィールド：`String name`（必須）、`int totalPages`（必須）、`int readingPageNum = 0`、`String bookReview = ''`。
  - `isComplete => readingPageNum == totalPages`
  - `readingState`：完了なら complete、`readingPageNum == 0` なら unstarted、それ以外は reading。
  - `fromJson` / `toJson`（キー：stateType, name, totalPages, readingPageNum, bookReview）、全項目任意の `copyWith` を実装する。
  - `hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props)`
  - `==` は identical、または同型かつ `equals(props, other.props)` で判定する。
  - `props = [stateType, name, totalPages, readingPageNum, bookReview]`
- **DOM-03** `@immutable class ReadingBooksValueObject extends ValueObject` を定義する。
  - フィールド：`List<ReadingBookValueObject> readingBooks`
  - `fromJson` / `toJson` / `copyWith`、hashCode / == を DOM-02 と同じ方式で実装する。`props = [stateType, readingBooks]`

### 4.2 状態モデル（`ReadingBooksState extends StateObject<ReadingBooksValueObject>`）

- **DOM-04** コンストラクタ `ReadingBooksState({ReadingBooksValueObject? overrideValue})` でテスト用初期値を受け取る。
- **DOM-05** `init()` の動作：
  - `overrideValue` があれば、serialNumber を 0 にしてその値で `update()` し、`overrideValue` をクリアして終了する。
  - なければ空リストの const VO で初期化し、serialNumber を 0 にした上で、ダミー書籍 3 件を `updateReadingBooks()` で設定する。
    1. 「Flutter入門」 100 ページ
    2. 「Flutter実践」 350 ページ
    3. 「Introduction to Flutter for Beginners.」 87 ページ
- **DOM-06** `dispose()` は VO を null、serialNumber を 0 にする（ENV-06 により永続化は行わない）。
- **DOM-07** `update(value)` は VO を差し替えて serialNumber をインクリメントする。`updateReadingBooks(list)` は新しい（非 const の）VO を生成して `update` する。`readingBooks` ゲッターを持つ。

### 4.3 ドメインモデル（`ReadingBooksDomainModel extends DomainObject<ReadingBooksState>`）

- **DOM-08** `enum ReadingBookEditMode { create, edit, delete, undecided }` を定義する。
- **DOM-09** コンストラクタ `ReadingBooksDomainModel({ReadingBooksState? overrideStateModel})` を定義する（未指定なら新規 `ReadingBooksState`）。
- **DOM-10** 内部状態は、書籍リスト、編集モード（初期値 undecided）、編集中 index、編集中書籍とする。
- **DOM-11** `initState()` は状態モデルを `init()` し、そのリストを内部リストへコピーする。`disposeState()` は状態モデルを `dispose()` し、内部リストをクリアする。
- **DOM-12** 公開 API：
  - `readingBooks`：変更不可リストを返す。
  - `currentEditMode`、`currentEditReadingBook`
  - `selectReadingBook({required int index})`：index と書籍を保持し、edit モードにする。
  - `createReadingBook()`：編集中書籍と index をクリアし、create モードにする。
  - `addReadingBook({required name, required totalPages})`：新規 VO を編集中書籍にして create モードにし、その VO を返す。
  - `updateReadingBook({name?, totalPages?, readingPageNum?, bookReview?})`：選択中の書籍を `copyWith` した VO を編集中書籍にして edit モードにし、その VO を返す。
  - `removeReadingBook()`：選択中の書籍を編集中書籍にして delete モードにし、その書籍を返す。
  - `commitReadingBook(book)`：モードに応じてリストに追加（create）・置換（edit）・削除（delete）するか、何もしない（undecided）。その後、状態モデルを `valueObject.copyWith(readingBooks: 内部リスト)` で更新し、編集状態を undecided にリセットする。
- **DOM-13** グローバル変数 `_readingBooksDomainModel` と、アクセス関数 `readingBooksDomainModelProvider(Object approver, {cycle, overrideModel})` を定義する。`modelProvider<ApplicationModel, ReadingBooksDomainModel>` を用い、`get` は `ReadingBooksViewModel` にのみ許可する。init 時は `overrideModel ?? ReadingBooksDomainModel()` を生成して `initState()` を呼ぶ。dispose 時は `disposeState()` を呼んだ後に null にする。

## 5. アプリケーション要件

- **APP-01** `ApplicationModel extends ApplicationObject({ReadingBooksDomainModel? overrideReadingBooksDomain})` を定義する。`initState` で `readingBooksDomainModelProvider(this, cycle: init, overrideModel: ...)` を、`disposeState` で `cycle: dispose` を呼ぶ。
- **APP-02** `main()` は `runApp(const ProviderScope(child: App()))` とする。
- **APP-03** `App extends StagedWidget<ApplicationModel>` を定義する。
  - コンストラクタは `{super.key, super.isWidgetsBindingObserve = true, this.overrideReadingBooksDomain}` とする。
  - `createWidgetState` で `ApplicationModel` を生成し、`initState` / `disposeState` で `state!.initState()` / `disposeState()` を呼ぶ。
- **APP-04** `App.build` は `MaterialApp.router` を返す。
  - title は 'Flutter Demo'。
  - theme は `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` の Material 3。
  - darkTheme は `ThemeData.dark(useMaterial3: true)`。
  - `themeMode: ThemeMode.system`、`routerConfig: appRouter`。

## 6. ルーティング要件（`routing/app_router.dart`）

- **RT-01** `enum AppRoutes(path)` を定義する：`home('/')`、`settings('/settings')`、`readingBook('/reading_book')`、`readingGraph('/reading_book/graph')`。
- **RT-02** トップレベル変数 `final GoRouter appRouter` を定義する（`initialLocation: '/'`）。ルート構成は以下の入れ子とする。
  - home（`HomePage`）
    - settings（`SettingsPage`）
    - readingBook（`ReadingBookPage`）
      - readingGraph（`ReadingBookGraphPage`）
- **RT-03** 各ルートは `path: AppRoutes.x.path`、`name: AppRoutes.x.name` を指定する。
- **RT-04** `errorBuilder` は AppBar「Error」と本文 `Page not found: ${state.error}` を表示する。
- **RT-05** `extension AppRouterExtension on BuildContext` に `goSettings()`、`goReadingBook()`、`goReadingGraph()`（いずれも `goNamed`）を定義する。

## 7. ViewModel 要件（`presentation/model/default/`）

- **VM-01** バレル `presentation/model/view_model_packages.dart` は `default/view_model_packages.dart` を export する。そのバレルは 3 つの ViewModel ファイルを export する。

### 7.1 読書中書籍一覧 ViewModel

- **VM-02** `readingBooksProvider = NotifierProvider<ReadingBooksViewModel, ReadingBooksValueObject>` を定義する。
- **VM-03** `build()` で `readingBooksDomainModelProvider(this)` によりドメインを取得し、`stateModel.valueObject` を初期 state として返す。
- **VM-04** `readingBooks`、`currentEditMode`、`currentEditReadingBook` はドメインへ委譲する。`selectReadingBook` / `createReadingBook` / `addReadingBook` / `updateReadingBook` / `removeReadingBook` もドメインへ委譲する。
- **VM-05** `commitReadingBook(book)` はドメインへ委譲した後、`editedReadingBook`（直近にコミットした書籍）を保持し、`state = domain.stateModel.valueObject` で Riverpod の state を更新する。

### 7.2 読書進捗率達成アニメーション ViewModel

- **VM-06** `enum ProgressAnimationTypeEnum { none, progressRate10, progressRate50, progressRate80, progressRate100 }` と `readingProgressAnimationsProvider = NotifierProvider<ReadingProgressAnimationsViewModel, ProgressAnimationTypeEnum>` を定義する（初期値 none）。
- **VM-07** 進捗率の判定は以下とする。
  - rate < 0.1 → none
  - rate < 0.5 → 10%
  - rate < 0.8 → 50%
  - rate < 1.0 → 80%
  - それ以上 → 100%
- **VM-08** `updateAnimationTypeIfProgressChange({required updatedBook, required prevReadingPageNum})` は、更新前後の種別を比較し、更新後の index が大きい場合のみ `updateAnimationType` を呼ぶ。
- **VM-09** `updateAnimationType({required animationType})` は state を更新し、`Timer` で 10 秒後に none に戻す。

### 7.3 読書応援アニメーション ViewModel

- **VM-10** `enum SupportAnimationTypeEnum { none, cheer, scolding }` と `readingSupportAnimationsProvider` を定義する（初期値 none）。
- **VM-11** `updateAnimationType` は VM-09 と同じ動作（10 秒後に none に戻す）とする。`build()` 内で、このメソッドを static な関数変数 `_updateAnimationType` にバインドする。
- **VM-12** デバッグ用に `ToggleSwitchViewModel` 型の `debugStartReading` と `debugEndReading` を持つ（初期値 false）。スイッチを ON にすると 10 秒後に、それぞれ cheer / scolding のアニメーション種別を発行し、スイッチを OFF に戻す。

## 8. 画面要件（`app/screen/`）

- **SCR-01** `HomePage`（ConsumerWidget）：
  - AppBar タイトルは「読書進捗応援」。右上に歯車アイコン（tooltip「設定」）を置き、タップで `goSettings`。
  - 本文は `Stack` で、下から順に次の 3 層を重ねる。
    1. `CurrentlyTasksWidget`（`ref.watch(readingBooksProvider)`）
    2. `ReadingSupportAnimationsWidget`（`ref.watch(readingSupportAnimationsProvider)`）
    3. `ReadingProgressAnimationsWidget`（`ref.watch(readingProgressAnimationsProvider)`）
- **SCR-02** `SettingsPage`：AppBar タイトルは「読書書籍設定」。本文は `ReadingBookSettingsWidget(provider: ref.read(readingBooksProvider.notifier).createReadingBook())`。provider 実行時に create モードに移行する（戻り値は void のため状態値型は `Object?`）。
- **SCR-03** `ReadingBookPage`：
  - AppBar タイトルは、編集モードが create なら「書籍の新規登録」、それ以外は「書籍情報の編集」。
  - 右上に円グラフアイコン（tooltip「グラフ」）を置き、タップで `goReadingGraph`。
  - 本文は `ReadingBookWidget(provider: ref.watch(readingBooksProvider.notifier).currentEditReadingBook!)`。
- **SCR-04** `ReadingBookGraphPage`：AppBar タイトルは「読書進捗グラフ」。本文は `ReadingBookGraphWidget(provider: ref.read(readingBooksProvider.notifier).currentEditReadingBook!)`。
- **SCR-05** ページは UI ウィジェットを `presentation/ui_widget/widget_packages.dart` バレル経由でのみ import する。

## 9. UI ウィジェット切り替え要件

- **UI-01** `presentation/ui_widget/` 配下に `default/`（ベース UI）、`challenge/`（ハンズオン穴あき）、`complete/`（完成版カスタム UI）の 3 ディレクトリを置き、同一のファイル名・クラス名で並行実装する。
- **UI-02** 各ディレクトリの `widget_packages.dart` は、次の 6 ファイルを export する。
  - `home/currently_tasks_widget.dart`
  - `home/reading_progress_animations_widget.dart`
  - `home/reading_support_animations_widget.dart`
  - `reading/reading_book_widget.dart`
  - `reading_graph/reading_book_graph_widget.dart`
  - `settings/reading_book_settings_widget.dart`
- **UI-03** トップのバレル `ui_widget/widget_packages.dart` は、`default/widget_packages.dart` のみを有効な export とし、complete / challenge の export はコメントアウトして切り替え可能にする。ViewModel は 3 系統とも `model/default` を共用する。

## 10. UI ウィジェット要件（default：ベース UI）

### 10.1 CurrentlyTasksWidget

- **UIW-01** `ConsumerStagedWidget<ReadingBooksValueObject, ScrollController>` として定義する。内部状態は `ScrollController` で、disposeState で dispose する。
- **UIW-02** `Scrollbar(thumbVisibility: true)` と `ListView.builder` で書籍を一覧表示する。各行は `Card(margin: 横16/縦8)` と `ListTile(title: 書籍名)` とする。
- **UIW-03** 行をタップすると `selectReadingBook(index)` を呼び、debugLog 出力の後に `goReadingBook()` で遷移する。

### 10.2 ReadingSupportAnimationsWidget

- **UIW-04** `ConsumerStagedWidget<SupportAnimationTypeEnum, Object>` として定義する。内部状態は null、`selectBuild` は `builders[value.index]` とする。
- **UIW-05** 種別ごとの表示：
  - none：`Offstage`
  - cheer：「頑張って！応援してるよ！🎉」（緑背景）
  - scolding：「もっと集中して！喝！🔥」（オレンジ背景）
- **UIW-06** 表示の共通形式は、`Center` + `Container(padding: 16, color)` + `headlineMedium` 白字・中央寄せの Text とする。

### 10.3 ReadingProgressAnimationsWidget（default）

- **UIW-07** `ConsumerStagedWidget<ProgressAnimationTypeEnum, Object>` として定義する。`selectBuild` は `builders[value.index]` とし、`build`（none）は `Offstage` を返す。
- **UIW-08** `build2`〜`build5` は `editedReadingBook?.name` を書名として、青背景で次のテキストを表示する（形式は UIW-06 と同じ）。
  - 10%：「{書名} 読了率 10%を達成しました！ 🔥」
  - 50%：「{書名} 読了率 50%を達成しました！ 🔥」
  - 80%：「{書名} 読了率 80%を達成しました！ 🔥」
  - 100%：「{書名} 読了おめでとうございます！ 🔥」

### 10.4 ReadingBookWidget（書籍編集フォーム）

- **UIW-09** `ConsumerStagedWidget<ReadingBookValueObject, ReadingBookState>` として定義する。`ReadingBookState` は `GlobalKey<FormState>` と TextEditingController 4 つ（name / totalPages / readingPageNum / bookReview）を持つ。disposeState で各 controller を dispose し、フォームを reset する。
- **UIW-10** build のたびに、各 controller に VO の値を設定する。フォームの項目（`OutlineInputBorder`）：
  1. 書籍タイトル（hint「例: Flutter実践入門」）：空なら「書籍タイトルを入力してください」
  2. 書籍総ページ数（数字のみ、hint「例: 300」）：空なら「総ページ数を入力してください」、1 未満または非数値なら「有効なページ数を入力してください」
  3. 読書中のページ番号（読書完了ページ数）（数字のみ、hint「例: 150」）：空なら「読書中のページ番号を入力してください」、負数または非数値なら「有効なページ番号を入力してください」、総ページ数を超えたら「総ページ数を超えることはできません」
  4. 書籍感想（maxLines 3、`alignLabelWithHint`、検証なし）
- **UIW-11** 送信ボタンのラベルは、create モードなら「登録する」、それ以外は「編集する」とする。押下時の処理：
  1. 検証 OK なら `save` する。
  2. 編集前の読了ページ数として、フォームに表示している編集対象書籍（provider から受け取った VO）の `readingPageNum` を `prevReadingPageNum` に取得する。
  3. `updateReadingBook(...)` → `commitReadingBook(...)` を行う。
  4. `updateAnimationTypeIfProgressChange(...)` を呼ぶ。
  5. `Navigator.pop(context, 編集後書籍)` で戻る。
- **UIW-12** edit モードのときのみ、赤字の「この書籍を削除する」ボタンを表示する。押下で AlertDialog を表示する。
  - タイトル「書籍の削除」、本文「「{書名}」を本当に削除しますか？」
  - 「キャンセル」は `pop(false)`。
  - 赤字の「削除」は `removeReadingBook()` → `commitReadingBook()` → `pop(true)`。
  - 削除が確定し `context.mounted` なら、debugLog 出力の後に `Navigator.pop` で戻る。
- **UIW-13** レイアウトは `Padding(16)` > `SingleChildScrollView` > `Form` > `Column(stretch)` とし、項目間隔は 16、ボタン前は 24、削除ボタン前は 12 とする。

### 10.5 ReadingBookSettingsWidget（新規追加・デバッグ設定）

- **UIW-14** `ConsumerStagedWidget<Object?, ReadingBookSettingsState>` として定義する。`ReadingBookSettingsState` は formKey と name / totalPages の controller を持つ。
- **UIW-15** 上段のデバッグセクション：`InputDecorator(labelText: 'デバッグ', 角丸 8)` 内に次を並べる。
  - 説明文「タップ 10秒後にイベントを発行します。」（bodySmall）
  - 「読書開始イベント」+ `ToggleSwitch(debugStartReading)`
  - 「読書終了イベント」+ `ToggleSwitch(debugEndReading)`
- **UIW-16** 下段の新規追加フォーム（初期値は空）：
  - 書籍タイトル：空なら「書籍タイトルを入力してください。」
  - 書籍総ページ数（数字のみ）：空なら「総ページ数を入力してください。」、非数値なら「有効な数値を入力してください。」、1 未満なら「総ページ数は1以上の数値を入力してください。」
- **UIW-17** 「新規追加」ボタン押下時の処理：
  1. 検証 OK なら `addReadingBook` → `commitReadingBook` を行う。
  2. SnackBar「書籍「{書名}」を追加します。」を表示する。
  3. `Navigator.pop` で戻る。

### 10.6 ReadingBookGraphWidget（default）

- **UIW-18** `ConsumerStagedWidget<ReadingBookValueObject, Object>` として定義する。進捗率 = `readingPageNum / totalPages` を 0〜1 に clamp する（どちらかが 0 以下なら 0）。
- **UIW-19** 中央寄せのスクロール可能な Column に、次の順で表示する。
  - 「総ページ数: N」「読了ページ数: N」（titleMedium）
  - 200×200 の `CustomPaint(PieChartPainter)`：中央に「{整数}%」（headlineSmall 太字）
  - 進捗 1.0 のときのみ「読了おめでとうございます！」（緑・太字）
- **UIW-20** `PieChartPainter(progress)` は、灰色（grey[300]）の太さ 20 の円を描き、progress > 0 なら 12 時方向から青の円弧（太さ 20、StrokeCap.round）を描く。`shouldRepaint` は progress の変化で判定する。

## 11. UI ウィジェット要件（complete：完成版カスタム UI）

- **CMP-01** `CurrentlyTasksWidget` / `ReadingSupportAnimationsWidget` / `ReadingBookWidget` / `ReadingBookSettingsWidget` は default と同一の実装とする。

### 11.1 ReadingProgressAnimationsWidget（complete）

- **CMP-02** 種別ごとの build は、`ProgressAchievementAnimation` を以下のパラメータで返す（書名は `editedReadingBook?.name`）。

  | 種別 | % | メッセージ | primary | secondary | アイコン | isCompletion |
  |---|---|---|---|---|---|---|
  | 10% | 10 | 素晴らしいスタート！ | `0xFF2196F3` | `0xFF03DAC6` | rocket_launch | false |
  | 50% | 50 | 折り返し地点到達！ | `0xFFFF9800` | `0xFFFFEB3B` | trending_up | false |
  | 80% | 80 | もうすぐゴール！ | `0xFF9C27B0` | `0xFFE91E63` | speed | false |
  | 100% | 100 | 完読おめでとう！ | `0xFF4CAF50` | `0xFFFFD700` | celebration | true |

- **CMP-03** `ProgressAchievementAnimation`（StatefulWidget + `TickerProviderStateMixin`）の AnimationController と再生時間：
  - main 1500ms、progress 2000ms、particle 4000ms、pulse 800ms、ripple 2500ms、sparkle 3500ms、background 5000ms
- **CMP-04** アニメーションの定義：
  - fade：main の `Interval(0, 0.5, easeOutCubic)`
  - scale：main の `Interval(0.1, 0.7, elasticOut)`
  - bounce：main の `Interval(0.5, 1, bounceOut)`
  - progress：`easeOutQuart`
  - pulse：`Tween(0.95 → 1.15)` + `easeInOutSine`
  - ripple：`easeOutQuart`
  - sparkle：`easeInOut`
  - background：`easeInOutSine`
- **CMP-05** 再生シーケンス：
  1. background と pulse を `repeat(reverse: true)` で再生し、main と ripple を forward する。
  2. 200ms 後に progress を forward する。
  3. さらに 400ms 後に sparkle を repeat する。
  4. さらに、完読時は 800ms 後、それ以外は 1200ms 後に particle を forward する。
  5. dispose では全コントローラを破棄する。
- **CMP-06** build：`Material(transparency)` > 画面サイズの `SizedBox` > `Stack(center)` に、次の順で重ねる。
  1. `DynamicBackgroundWidget`
  2. `RippleEffectWidget`
  3. `AnimatedBuilder`（main / progress / pulse を `Listenable.merge`）> `FadeTransition(fade)` > `Transform.scale(scale × bounce)` > メインコンテンツ
  4. `ParticleEffectWidget`（完読時のみ）
  5. `SparkleEffectWidget`
- **CMP-07** メインコンテンツは幅 400 の Column で、次の順に並べる。
  1. `ProgressCircleWidget`
  2. 間隔 32
  3. `TitleTextWidget`
  4. 間隔 16
  5. `MessageTextWidget`

### 11.2 進捗演出コンポーネント（`home/components/progress/`）

- **CMP-08** `DynamicBackgroundWidget`：`Positioned.fill` の `RadialGradient` を描く。
  - radius = 0.8 + v×0.4
  - 色：primary(α 0.15+v×0.1)、secondary(α 0.08+v×0.05)、primary(α 0.03)、transparent
  - stops：0 / 0.4 / 0.7 / 1
- **CMP-09** `RippleEffectWidget`：4 本の同心円の波紋を描く。
  - 各波紋の遅延は i×0.25。半径は画面長辺の 1/2 × 進行度。
  - 不透明度は (1−進行度)×0.3、線幅は 3−進行度×2。
  - 偶数番は primary、奇数番は secondary。
- **CMP-10** `ProgressCircleWidget`：
  - pulse 値で全体を拡縮する 140×140 の円（RadialGradient：白 0.9 → primary → secondary → primary 0.8）を描く。
  - BoxShadow は 3 層：primary 0.6、blur 25+p×10、spread 8、offset(0,5) ／ secondary 0.4、blur 40+p×15、spread 15 ／ 白ハイライト 0.3、blur 10、spread −5、offset(−3,−3)。
  - 内部の 110×110 の `_Enhanced3DProgressPainter`：半径 = 短辺/2−10、線幅 8+p×4。背景はグラデーション円。progress > 0 のとき SweepGradient の円弧と、白のハイライト円弧（α 0.6+p×0.3、線幅 2）を描く。
  - 中央に白アイコン（size 32、1+p×0.2 で拡縮、半透明白の円背景）を置く。
  - 下部 5px の位置に「{% × progress}%」バッジ（白背景、角丸 12、影付き、primary 色 10pt 太字）を置く。
- **CMP-11** `ParticleEffectWidget`：
  - 爆発粒子 24 個：速度 1+(i%3)×0.5、距離 v×200×速度、サイズ (1−v)×10（1〜10 に clamp）、不透明度 (1−v)×0.9。各粒子の中心に白の小円を重ねる。
  - 白い火花 36 個：距離 v×120、サイズ sin(v·4π)×2+1。
- **CMP-12** `SparkleEffectWidget`：
  - 星形を完読時 20 個、それ以外は 12 個、円周上に配置する。
  - 位相 = (v+i×0.1)%1、距離 80+sin(位相·2π)×40、サイズ 2+sin(位相·4π)×3、不透明度 sin(位相·π)×0.8。
  - 星は 10 頂点で、内径は外径の 0.4 倍とする。
- **CMP-13** `TitleTextWidget`：書名が空なら「読書記録」を表示する。headlineSmall、w700、primary 色、最大 2 行 ellipsis、横 padding 24。
- **CMP-14** `MessageTextWidget`：primary の α0.1 背景・α0.3 枠線、角丸 20 のバッジ内に、primary 色 16pt w600、最大 3 行でメッセージを表示する。

### 11.3 ReadingBookGraphWidget（complete）

- **CMP-15** `ConsumerStagedWidget<ReadingBookValueObject, DonutAnimationState>` として定義する。進捗率は totalPages ≤ 0 なら 0、それ以外は clamp(0,1) とする。
- **CMP-16** build のたびに `addPostFrameCallback` で `animateToProgress(progress)` を予約する。本文は `SingleChildScrollView` > `Padding 24` の Column で、次の順に並べる。
  1. `TitleSection`
  2. 間隔 32
  3. `ProgressDonutChart`（タップで `_onDonutTap`）
  4. 間隔 32
  5. `ProgressInfo`
- **CMP-17** `_onDonutTap` は `triggerPulseAnimation()` と `HapticFeedback.lightImpact()` を呼ぶ。
- **CMP-18** `DonutAnimationState` の仕様：
  - `initializeAnimations(vsync)`：2000ms のコントローラと `Tween(0→0)` + `easeOutCubic` を生成する。
  - `animatedProgress`：`progressAnimation?.value ?? progressValue`
  - `animateToProgress(p)`：目標値が変わった場合のみ、`Tween(現在値→p)` + `easeOutCubic` を作り直し、reset → forward する。
  - `triggerPulseAnimation()`：`pulseValue = 1` にし、300ms 後に 0 に戻す。
  - `dispose()`：二重破棄を防止する。
- **CMP-19** `ProgressDonutChart`（StatefulWidget + `TickerProviderStateMixin`）：
  - initState で `state.initializeAnimations(this)`、dispose で `state.dispose()` を呼ぶ。
  - progressController を監視する `AnimatedBuilder` > `GestureDetector` > 280×280 の円（primary α0.1 の影、blur 20、spread 5）> Stack で、次の順に重ねる。
    1. `BackgroundGlow`
    2. `CustomPaint(ProgressDonutChartPainter)`
    3. `DonutChartCenterContent`
- **CMP-20** `ProgressDonutChartPainter(progress, pulseValue, colorScheme)`：
  - 半径 = 短辺/2−20、線幅 16。背景円は outline α0.2。
  - progress > 0 のとき、次の 3 つを描く。
    1. グロー円弧：primary α(0.3+p×0.2)、線幅 +8、blur 8
    2. 本体円弧：線幅 16+p×4
    3. 終端ドット：グロー 8+p×3（blur 4）、本体 6+p×2
- **CMP-21** `BackgroundGlow`：280×280 の円に、primary α0.1 → transparent の RadialGradient を描く。
- **CMP-22** `DonutChartCenterContent`：`AnimatedSwitcher(600ms)` で切り替える（key は `ValueKey(isCompleted)`）。
  - `animatedProgress ≥ 1.0` のとき `CompletionContent`：celebration_outlined アイコン 48 と「完読達成！」を表示する。
  - それ以外は `ProgressContent`：「残り」「{残ページ数}」（displayMedium w900）「ページ」を表示する。
- **CMP-23** `TitleSection`：
  - 書名（空なら「読書進捗」）：headlineSmall w700、最大 2 行
  - 「{小数1桁}% 完了」：primary 色
- **CMP-24** `ProgressInfo`：角丸 16 の枠内に、`StatItem` を 2 つと縦区切り線（1×40）を並べる。
  - 読了ページ：book_outlined、primary 色
  - 総ページ：menu_book_outlined、secondary 色
- **CMP-25** `StatItem(value, label, icon, color)`：アイコン 24、値（titleMedium w700）、ラベル（bodySmall w500）を縦に並べる。
- **CMP-26** complete と challenge の `progress_donut_chart.dart` は、互いに相手ディレクトリの `progress_donut_chart_painter.dart` を import する。
  - 両ディレクトリの painter は同一内容である。
  - complete と challenge は同時に有効にしない（UI-03 のバレル切り替え）ことを前提とする。

## 12. UI ウィジェット要件（challenge：ハンズオン穴あき版）

- **CHL-01** challenge は complete と同一構成・同一コードとし、以下の箇所だけを `// FIXME コードを完成させてください。` + `// ステップN: …` コメントと、コメントアウトした正解コードに置き換える。置き換えた箇所には、アニメーション値を定数 `1` にした仮コードなどを入れ、ビルドが通る状態にする。
  - `home/reading_progress_animations_widget.dart`：
    - ステップ1：アニメーション設定の分割（再生時間・動き・dispose）
    - ステップ1：複数コントローラの統合監視
    - ステップ2：プログレス円とアイコンの配置
    - ステップ3：アニメーションの配置と実行
    - ステップ4：２層目の波紋、他のアニメーションの重ね合わせ
  - `home/components/progress/dynamic_background_widget.dart`：
    - ステップ2：放射グラデーション（仮コードでは `animation.value` を 1 に置換）
  - `home/components/progress/progress_circle_widget.dart`：
    - ステップ3：アニメーション値による動き（①〜⑤。仮コードでは pulse・progress 値を 1 に置換）
  - `reading_graph/reading_book_graph_widget.dart`：
    - ステップ1：`addPostFrameCallback` による描画予約
    - ステップ2：`Tween` の再生成と reset / forward
  - `reading_graph/components/donut_chart_center_content.dart`：
    - ステップ3：`AnimatedSwitcher` による完読メッセージ切り替え（仮コードでは常に `ProgressContent` を表示）

## 13. テスト要件（`test/`）

- **TST-01** `riverpod_unit_test_utillity.dart`（ファイル名は原文どおり）に `createContainer({parent, overrides, observers})` を実装する。`ProviderContainer` を生成し、`addTearDown(container.dispose)` を登録する。
- **TST-02** 単体テスト `riverpod_reading_books_unit_test.dart`（`'riverpod readingBooksViewModel unit test'`）：
  - 準備：0 件の `ReadingBooksState(overrideValue:)` を渡した `ReadingBooksDomainModel` を作り、`ApplicationModel` を approver として `readingBooksDomainModelProvider(init, overrideModel:)` で初期化する。
  - 検証の流れ：
    1. 初期状態が 0 件であること。
    2. 「Flutter入門」350p を add → commit すると 1 件になること。
    3. index 0 を選択して「Flutter実践入門」に update → commit すると、書名が変わること。
    4. 「Vibeでええやん？」100p を add すると 2 件になること。
    5. index 1 を remove → commit すると 1 件に戻り、残りが「Flutter実践入門」であること。
- **TST-03** ウィジェットテスト `riverpod_reading_books_widget_test.dart`：各テストでは `ProviderScope(child: App(overrideReadingBooksDomain: domain))` を起動する。
  - `addReadingBook smoke test`（0 件で開始）：
    1. 歯車アイコンから SettingsPage へ遷移する。
    2. 1 つ目の TextField に「Flutter入門」、最後の TextField に「350」を入力し、「新規追加」を押す。
    3. HomePage に戻り、一覧に書名が表示されることを確認する。
    4. 書籍カードをタップして ReadingBookPage に遷移し、1・2 番目の TextField の値が「Flutter入門」「350」であることを確認する。
    5. `pageBack` で HomePage に戻る。
  - `updateReadingBook smoke test`（1 件で開始）：
    1. 書籍を開き、4 つの TextField の値が「Flutter入門」「350」「0」「」であることを確認する。
    2. 書名を「Flutter実践入門」に変えて、`ensureVisible` の後に「編集する」を押す（ボタンがなければ `UnsupportedError`）。
    3. HomePage で新しい書名だけが表示されることを確認する。
  - `removeReadingBook smoke test`（1 件で開始）：
    1. 書籍を開き、「この書籍を削除する」を押す。
    2. ダイアログの「削除」を押す。
    3. HomePage に戻り、一覧が空になることを確認する。
- **TST-04** ヘルパー `findTextField(CommonFinders find, int index)` は、index 番目の `TextField` の `controller.text` を返す。
- **TST-05** ウィジェットテストは default の UI（`ui_widget/widget_packages.dart` の default export）が有効な状態で実行する。

## 14. コーディング規約要件

- **STY-01** `analysis_options.yaml` は `package:flutter_lints/flutter.yaml` を include し、`strict-casts` / `strict-inference` / `strict-raw-types` を有効にする。FlutterKaigi 2024 ベースの lint ルール群（`always_specify_types`、`prefer_single_quotes`、`require_trailing_commas`、`always_put_control_body_on_new_line`、`lines_longer_than_80_chars`、`diagnostic_describe_all_properties` 等）に準拠する。
- **STY-02** 1 行は 80 桁以内とし、ローカル変数・ジェネリクスリテラルには型を明示する（例：`<Widget>[...]`）。
- **STY-03** 公開ウィジェットは `debugFillProperties` でプロパティを出力する（出力できない場合は `// ignore: diagnostic_describe_all_properties`）。
- **STY-04** コメント・ドキュメントコメントは日本語で記述する。
