import 'package:flutter/material.dart';

enum DialogType {
  success,
  error,
  warning,
  info,
  confirmation,
}

class DialogUtils {
  // Main common dialog
  static Future<void> showCommonDialog({
    required BuildContext context,
    required String title,
    required String message,
    DialogType type = DialogType.info,
    String positiveText = "OK",
    String? negativeText,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                _getIcon(type),
                color: _getColor(type),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getColor(type),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            if (negativeText != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onNegative != null) onNegative();
                },
                child: Text(
                  negativeText,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getColor(type),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (onPositive != null) onPositive();
              },
              child: Text(positiveText),
            ),
          ],
        );
      },
    );
  }

  // Shortcut methods for trading app use cases

  static void showError(
      BuildContext context,
      String message, {
        String title = "Error",
      }) {
    showCommonDialog(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
    );
  }

  static void showWarning(
      BuildContext context,
      String message, {
        String title = "Warning",
      }) {
    showCommonDialog(
      context: context,
      title: title,
      message: message,
      type: DialogType.warning,
    );
  }

  static void showSuccess(
      BuildContext context,
      String message, {
        String title = "Success",
      }) {
    showCommonDialog(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
    );
  }

  static void showInfo(
      BuildContext context,
      String message, {
        String title = "Info",
      }) {
    showCommonDialog(
      context: context,
      title: title,
      message: message,
      type: DialogType.info,
    );
  }

  static void showConfirmation(
      BuildContext context, {
        String title = "Confirm",
        required String message,
        String positiveText = "Yes",
        String negativeText = "No",
        required VoidCallback onYes,
        VoidCallback? onNo,
      }) {
    showCommonDialog(
      context: context,
      title: title,
      message: message,
      type: DialogType.confirmation,
      positiveText: positiveText,
      negativeText: negativeText,
      onPositive: onYes,
      onNegative: onNo,
    );
  }

  // Private helpers
  static IconData _getIcon(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.error;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.confirmation:
        return Icons.help;
      case DialogType.info:
      default:
        return Icons.info;
    }
  }

  static Color _getColor(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.confirmation:
        return Colors.blueGrey;
      case DialogType.info:
      default:
        return Colors.blue;
    }
  }
}
