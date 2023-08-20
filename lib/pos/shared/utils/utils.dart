

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';

void errorToast({
  required String? code,
  required String? message,
}) {
  Fluttertoast.showToast(
      msg: getClearName(code, message, comma: true),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorManager.primary,
      textColor: ColorManager.white,
      fontSize: 16.0
  );
}

bool isApple() {
  return defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS;
}

String getClearName(String? firstName, String? lastName, {bool comma = false}) {
  return (firstName ?? '') + (firstName == null ? '' : firstName.isEmpty ? ''
      : comma ? lastName == null ? '' : lastName.isEmpty ? '' : ', ' : ' ')
      + (lastName ?? '');
}