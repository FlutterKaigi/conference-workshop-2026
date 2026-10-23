/// メッセージテキスト（完成版）。
library;

import 'package:flutter/material.dart';

/// メッセージテキスト。
///
/// バッジスタイルでメッセージを表示する。
class MessageTextWidget extends StatelessWidget {
  /// コンストラクタ。
  const MessageTextWidget({
    required this.message,
    required this.primaryColor,
    super.key,
  });

  /// メッセージ。
  final String message;

  /// 主色。
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
