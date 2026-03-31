import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OverlayManager {
  OverlayManager._();

  static final OverlayManager instance = OverlayManager._();

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<bool?> showSnackBar(String message, {bool isLong = false}) async {
    final snackBar = SnackBar(
      duration: isLong ? Duration(seconds: 4) : Duration(seconds: 1),
      content: Text(message),
    );
    scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    return true;
  }

  Future<bool?> showToast(String message, {bool isLong = false}) async {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<dynamic> showDraggableBottomSheet({
    required BuildContext context,
    required Widget widget,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
  }) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      scrollControlDisabledMaxHeightRatio: 0.3,
      elevation: 0,
      context: context,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize,
          // Initial height (60% of screen)
          minChildSize: minChildSize,
          // Minimum height
          maxChildSize: maxChildSize,
          builder: (BuildContext context, ScrollController scrollController) {
            return Scaffold(
              body: SingleChildScrollView(controller: scrollController, child: widget),
            );
          },
        );
      },
    );
  }
}
