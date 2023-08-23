

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';

import '../../presentaion/ui/popup_dialogs/custom_dialog.dart';
import '../constant/constant_values_manager.dart';
import '../constant/strings_manager.dart';

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

Future<bool> onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.warning.tr()),
          content: Text(AppStrings.closeApp.tr()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppStrings.no.tr())),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(AppStrings.yes.tr())),
          ],
        );
      });
  return exitApp;
}

Future<bool> onBackButtonPressedInIOS(BuildContext context) async {
  bool exitApp = await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppStrings.warning.tr()),
          content: Text(AppStrings.closeApp.tr()),
          actions: [
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(AppStrings.no.tr())),
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                isDestructiveAction: true,
                child: Text(AppStrings.yes.tr())),
          ],
        );
      });
  return exitApp;
}

void showNoInternet(BuildContext context) {
  CustomDialog.show(
      context,
      AppStrings.noInternet.tr(),
      const Icon(Icons.wifi),
      ColorManager.white,
      AppConstants.durationOfSnackBar,
      ColorManager.delete);
}

void tryAgainLater(BuildContext context) {
  CustomDialog.show(
      context,
      AppStrings.errorTryAgain.tr(),
      const Icon(Icons.close),
      ColorManager.white,
      AppConstants.durationOfSnackBar,
      ColorManager.delete);
}

void noCredit(BuildContext context) {
  CustomDialog.show(
      context,
      AppStrings.noCredit.tr(),
      const Icon(Icons.warning_amber_rounded),
      ColorManager.white,
      AppConstants.durationOfSnackBar,
      ColorManager.hold);
}

double roundDouble(double value, int places) {
  String roundedNumber = value.toStringAsFixed(places);
  return double.parse(roundedNumber);
}

String getClearName(String? firstName, String? lastName, {bool comma = false}) {
  return (firstName ?? '') + (firstName == null ? '' : firstName.isEmpty ? ''
      : comma ? lastName == null ? '' : lastName.isEmpty ? '' : ', ' : ' ')
      + (lastName ?? '');
}