import 'package:flutter/material.dart';

/// エラーダイアログの表示ユーティリティ。
class AppErrorHandlerDialog {
  AppErrorHandlerDialog._();

  /// エラー通知ダイアログを表示する。
  static Future<void> showErrorAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    bool isExitApp = false,
  }) async {
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              if (!isExitApp)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
            ],
          ),
        );
      },
    );
  }
}
