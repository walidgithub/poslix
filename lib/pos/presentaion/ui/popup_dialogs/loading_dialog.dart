import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';

import '../../../shared/constant/padding_margin_values_manager.dart';

class LoadingDialog extends StatefulWidget {
  static void show(BuildContext context) =>
      isApple() ? showCupertinoDialog<void>(context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (_) => const LoadingDialog()).then((_) => FocusScope.of(context).requestFocus(FocusNode())) :
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (_) => const LoadingDialog(),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  const LoadingDialog({super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isApple() ? CupertinoActivityIndicator(
                color: ColorManager.primary,
                radius: 15.w,
              ) : CircularProgressIndicator(
                color: ColorManager.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
