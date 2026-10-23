import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// テスト用の ProviderContainer を生成するユーティリティ。
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const <Override>[],
  List<ProviderObserver>? observers,
}) {
  final ProviderContainer container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );
  addTearDown(container.dispose);
  return container;
}
