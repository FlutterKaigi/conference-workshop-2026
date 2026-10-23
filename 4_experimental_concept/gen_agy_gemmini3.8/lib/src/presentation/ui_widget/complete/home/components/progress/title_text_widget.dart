import 'package:flutter/material.dart';

/// タイトルテキストウィジェット。
class TitleTextWidget extends StatelessWidget {
  /// コンストラクタ。
  const TitleTextWidget({
    required this.title,
    required this.primaryColor,
    super.key,
  });

  /// 書籍タイトル。
  final String? title;

  /// メインカラー。
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final String displayTitle =
        (title != null && title!.isNotEmpty) ? title! : '読書記録';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        displayTitle,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
