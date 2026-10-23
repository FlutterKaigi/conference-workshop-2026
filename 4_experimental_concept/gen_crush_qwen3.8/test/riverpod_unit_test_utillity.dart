/// Riverpod 用の ProviderContainer を生成するヘルパー。
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// [ProviderContainer] を生成してテスト用に返す。
///
/// [parent] / [overrides] / [observers] を渡すこともできる。
/// テスト終了時に自動的に dispose される。
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override>? overrides,
  List<ProviderObserver>? observers,
}) {
  final ProviderContainer container = ProviderContainer(
    parent: parent,
    overrides: overrides ?? const <Override>[],
    observers: observers ?? const <ProviderObserver>[],
  );
  addTearDown(() => container.dispose());
  return container;
}
