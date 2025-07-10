import 'package:flutter/material.dart';
import 'common_widgets/res/app_color.dart';

class Utils {

  static Future<void> successSnackBar({
    required BuildContext context,
    required String msg,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            const Icon(Icons.check_circle, color: Colors.white, size: 36),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(8),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show a warning snackbar
  static Future<void> warningSnackBar({
    required BuildContext context,
    required String msg,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 36),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orangeAccent.shade200,
        padding: const EdgeInsets.all(8),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show an error snackbar
  static Future<void> errorSnackBar({
    required BuildContext context,
    required String msg,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(msg)),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white, size: 36),
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(8),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Change focus to next field
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
