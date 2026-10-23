/// モデル基底クラス群を定義する。
///
/// - [ModelCycle]：モデルの生存サイクルの種別
/// - [modelProvider]：承認者を制限してモデルへアクセスする汎用関数
/// - [ApplicationObject]：アプリケーション層のモデル基底クラス
/// - [DomainObject]：ドメイン層のモデル基底クラス
/// - [StateObject]：状態モデルの基底クラス
/// - [ValueObject]：不変な値オブジェクトの基底クラス
library;

/// モデルの生存サイクルの種別。
enum ModelCycle {
  /// 初期化。
  init,

  /// 破棄。
  dispose,

  /// 取得。
  get,
}

/// 承認者を制限してモデルへのアクセスを行う汎用関数。
///
/// [approver] が型 [A] ではなく、かつ [isApproved] で認められて
/// いなければ、`cycle == ModelCycle.get` のときのみ許可し、
/// それ以外は `ArgumentError('Unauthorized approver.')` を投げる。
T modelProvider<A, T>(
  Object approver, {
  ModelCycle cycle = ModelCycle.get,
  T? overrideModel,
  T Function()? initModel,
  T? Function()? disposeModel,
  T? Function()? getModel,
  bool Function(Object)? isApproved,
}) {
  final bool isAppropriateType = approver is A;
  final bool isApprovedByFunction = isApproved?.call(approver) ?? false;
  if (!isAppropriateType &&
      !(isApprovedByFunction && cycle == ModelCycle.get)) {
    throw ArgumentError('Unauthorized approver.');
  }
  if (cycle != ModelCycle.init && overrideModel != null) {
    throw ArgumentError('Unexpected parameter paring.');
  }
  final T? model = getModel?.call();
  switch (cycle) {
    case ModelCycle.init:
      if (model != null) {
        throw ArgumentError('Already initialized..');
      }
      return initModel?.call() as T;
    case ModelCycle.dispose:
      if (model == null) {
        throw ArgumentError('Non initialized.');
      }
      final T? disposeResult = disposeModel?.call();
      return disposeResult ?? model;
    case ModelCycle.get:
      if (model == null) {
        throw ArgumentError('Non initialized.');
      }
      return model;
  }
}

/// アプリケーション層のモデル基底クラス。
abstract class ApplicationObject {
  /// 状態の初期化。
  void initState();

  /// 状態の破棄。
  void disposeState();
}

/// ドメイン層のモデル基底クラス。
abstract class DomainObject<S extends StateObject<ValueObject>> {
  /// 状態モデルへの参照。
  S get stateModel;

  /// 状態の初期化。
  void initState();

  /// 状態の破棄。
  void disposeState();
}

/// 状態モデルの基底クラス。
abstract class StateObject<V extends ValueObject> {
  /// 状態の更新回数。
  int serialNumber = -1;

  /// 現在のカレントな状態。
  V get valueObject;

  /// 初期化。
  void init();

  /// 破棄。
  void dispose();

  /// 状態の更新。
  void update(V value);
}

/// 不変な値オブジェクトの基底クラス。
abstract class ValueObject {
  /// 定数コンストラクタ。
  const ValueObject({required this.stateType});

  /// その値オブジェクトを保持する状態モデルの型。
  final Type stateType;

  /// 等価比較に用いるプロパティの一覧。
  List<Object> get props;
}
