/// アプリケーションのエラーハンドリング関連ウィジェット。
library;

import 'package:flutter/material.dart';

/// アプリのエラーハンドリング。
class AppErrorHandlerDialog {
  /// 使用を禁止するコンストラクタ。
  AppErrorHandlerDialog._();

  /// エラー内容を表すアラートダイアログを表示する。
  ///
  /// [isExitApp] が false のときのみ「OK」ボタンを表示する。
  static void showErrorAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    bool isExitApp = false,
  }) {
    if (!context.mounted) {
      return;
    }
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: isExitApp
                ? <Widget>[]
                : <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
