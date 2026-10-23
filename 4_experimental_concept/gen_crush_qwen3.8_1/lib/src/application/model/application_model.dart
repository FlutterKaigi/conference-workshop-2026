/// アプリケーション全体のモデル（ドメインモデルの生命周期の管理）。
library;

import '../../domain/model/reading_books_domain_model.dart';
import '../../fundamental/model/base_objects_model.dart';

/// アプリケーション層のモデル。
///
/// アプリの生存期間中にドメインモデルを生成・破棄する。
class ApplicationModel extends ApplicationObject {
  /// コンストラクタ。
  ApplicationModel({ReadingBooksDomainModel? overrideReadingBooksDomain})
    : _overrideReadingBooksDomain = overrideReadingBooksDomain;

  /// 初期化/破棄時に渡すテスト用のドメインモデル。
  final ReadingBooksDomainModel? _overrideReadingBooksDomain;

  /// 初期化時にドメインモデルを初期化する。
  @override
  void initState() {
    readingBooksDomainModelProvider(
      this,
      cycle: ModelCycle.init,
      overrideModel: _overrideReadingBooksDomain,
    );
  }

  /// 破棄時にドメインモデルを破棄する。
  @override
  void disposeState() {
    readingBooksDomainModelProvider(this, cycle: ModelCycle.dispose);
  }
}
