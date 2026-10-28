import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SayMiraLoader.dart';

class SayMiraLoadingDialog {

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SayMiraLoader(),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
