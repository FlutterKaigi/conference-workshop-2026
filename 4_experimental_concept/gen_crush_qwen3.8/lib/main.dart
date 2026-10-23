/// エントリポイント。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/app.dart';

/// アプリケーションのエントリポイント。
void main() {
  runApp(const ProviderScope(child: App()));
}
