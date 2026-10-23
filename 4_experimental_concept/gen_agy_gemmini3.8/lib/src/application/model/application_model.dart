import 'package:conference_handson_2025/src/domain/model/reading_books_domain_model.dart';
import 'package:conference_handson_2025/src/fundamental/model/base_objects_model.dart';

/// アプリケーション全体のモデルを管理するクラス。
class ApplicationModel extends ApplicationObject {
  /// コンストラクタ。
  ApplicationModel({ReadingBooksDomainModel? overrideReadingBooksDomain})
      : _overrideReadingBooksDomain = overrideReadingBooksDomain;

  final ReadingBooksDomainModel? _overrideReadingBooksDomain;

  @override
  void initState() {
    readingBooksDomainModelProvider(
      this,
      cycle: ModelCycle.init,
      overrideModel: _overrideReadingBooksDomain,
    );
  }

  @override
  void disposeState() {
    readingBooksDomainModelProvider(
      this,
      cycle: ModelCycle.dispose,
    );
  }
}
