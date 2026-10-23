import 'package:conference_handson_2025/src/domain/model/reading_books_value_object.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/widget_packages.dart';
import 'package:conference_handson_2025/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ホーム画面。
class HomePage extends ConsumerWidget {
  /// コンストラクタ。
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('読書進捗応援'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () => context.goSettings(),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          CurrentlyTasksWidget(
            provider: (ref) =>
                ref.watch<ReadingBooksValueObject>(readingBooksProvider),
          ),
          ReadingSupportAnimationsWidget(
            provider: (ref) => ref.watch<SupportAnimationTypeEnum>(
              readingSupportAnimationsProvider,
            ),
          ),
          ReadingProgressAnimationsWidget(
            provider: (ref) => ref.watch<ProgressAnimationTypeEnum>(
              readingProgressAnimationsProvider,
            ),
          ),
        ],
      ),
    );
  }
}
