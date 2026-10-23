/// モデルのライフサイクルを表す列挙型。
enum ModelCycle {
  /// 初期化
  init,

  /// 破棄
  dispose,

  /// 取得
  get,
}

/// 承認された呼び出し元に対してのみモデルを提供する汎用関数。
T modelProvider<A, T>(
  Object approver, {
  ModelCycle cycle = ModelCycle.get,
  T? overrideModel,
  T Function()? initModel,
  T Function()? disposeModel,
  T? Function()? getModel,
  bool Function(Object)? isApproved,
}) {
  if (approver is! A) {
    final bool approved = isApproved?.call(approver) ?? false;
    if (!approved || cycle != ModelCycle.get) {
      throw ArgumentError('Unauthorized approver.');
    }
  }

  if (cycle != ModelCycle.init && overrideModel != null) {
    throw ArgumentError('Unexpected parameter paring.');
  }

  switch (cycle) {
    case ModelCycle.init:
      if (getModel?.call() != null) {
        throw ArgumentError('Already initialized..');
      }
      return initModel!();
    case ModelCycle.get:
      final T? model = getModel?.call();
      if (model == null) {
        throw ArgumentError('Non initialized.');
      }
      return model;
    case ModelCycle.dispose:
      if (getModel?.call() == null) {
        throw ArgumentError('Non initialized.');
      }
      return disposeModel!();
  }
}

/// アプリケーションオブジェクトの基底クラス。
abstract class ApplicationObject {
  /// 初期化処理。
  void initState();

  /// 破棄処理。
  void disposeState();
}

/// ドメインオブジェクトの基底クラス。
abstract class DomainObject<S extends StateObject<ValueObject>> {
  /// 状態モデルを取得する。
  S get stateModel;

  /// 初期化処理。
  void initState();

  /// 破棄処理。
  void disposeState();
}

/// 状態オブジェクトの基底クラス。
abstract class StateObject<V extends ValueObject> {
  /// シリアル番号を取得する。
  int get serialNumber;

  /// 値オブジェクトを取得する。
  V get valueObject;

  /// 初期化処理。
  void init();

  /// 破棄処理。
  void dispose();

  /// 状態を更新する。
  void update(V value);
}

/// 値オブジェクトの基底クラス。
abstract class ValueObject {
  /// コンストラクタ。
  const ValueObject({required this.stateType});

  /// 状態の型。
  final Type stateType;

  /// 等価性比較に用いるプロパティのリスト。
  List<Object?> get props;
}
