/// タイトルテキスト（完成版）。
library;

import 'package:flutter/material.dart';

/// タイトルテキスト。
///
/// 書名が表示される。書名が空の場合は「読書記録」。
class TitleTextWidget extends StatelessWidget {
  /// コンストラクタ。
  const TitleTextWidget({required this.bookName, super.key});

  /// 書名。
  final String bookName;

  @override
  Widget build(BuildContext context) {
    final TextTheme themeTextTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        bookName.isEmpty ? '読書記録' : bookName,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: themeTextTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
