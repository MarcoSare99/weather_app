import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DialogWidget {
  BuildContext context;
  ProgressDialog? pd;
  DialogWidget({required this.context}) {
    pd = ProgressDialog(context: context);
  }

  void showProgress() {
    pd!.show(
        msg: "Espere por favor",
        msgColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
        progressBgColor: Colors.purple,
        progressValueColor: Colors.pinkAccent,
        barrierColor: Colors.white.withOpacity(0.2));
  }

  void closeProgress() {
    pd!.close();
  }
}
