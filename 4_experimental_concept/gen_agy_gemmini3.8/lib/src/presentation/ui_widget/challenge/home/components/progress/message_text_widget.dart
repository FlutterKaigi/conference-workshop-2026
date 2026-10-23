import 'package:flutter/material.dart';

/// メッセージテキストウィジェット。
class MessageTextWidget extends StatelessWidget {
  /// コンストラクタ。
  const MessageTextWidget({
    required this.message,
    required this.primaryColor,
    super.key,
  });

  /// 表示メッセージ。
  final String message;

  /// メインカラー。
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
