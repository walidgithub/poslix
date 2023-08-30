import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';

class CustomDialog extends StatefulWidget {
  String messageText;
  Icon iconName;
  Color iconColor;
  int messageTime;
  Color messageColor;

  static void show(BuildContext context, String messageText, Icon iconName, Color iconColor, int messageTime, Color messageColor) =>
      isApple() ? showCupertinoDialog(context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (dialogContext) {
            Future.delayed(Duration(milliseconds: messageTime), () {
              Navigator.of(dialogContext).pop(true);
            });
            return CustomDialog(
              messageText: messageText,
              iconName: iconName,
              iconColor: iconColor,
              messageTime: messageTime,
              messageColor: messageColor,
            );
          }).then((_) => FocusScope.of(context).requestFocus(FocusNode())) :
      showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        Future.delayed(Duration(milliseconds: messageTime), () {
          Navigator.of(dialogContext).pop(true);
        });
        return CustomDialog(
          messageText: messageText,
          iconName: iconName,
          iconColor: iconColor,
          messageTime: messageTime,
          messageColor: messageColor,
        );
      }).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  CustomDialog({required this.messageText,required this.iconName,required this.iconColor,required this.messageTime,required this.messageColor, super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  bool _isExpanded = false;

  double? deviceWidth;
  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = getDeviceWidth(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.messageTime),
              curve: Curves.easeOut,
              top: 10.h,
              right: _isExpanded ? 10.w : 0.w,
              child: Container(
                height: AppSize.s50,
                width: deviceWidth! <= 600 ? 250.w : 130.w,
                decoration: BoxDecoration(
                    color: widget.messageColor,
                    border: Border.all(
                        color: widget.messageColor,
                        width: 0.5.w),
                    borderRadius:
                    BorderRadius.circular(AppSize.s5),
                    boxShadow: const [BoxShadow(color: Colors.black26)]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,10,10,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: AppSize.s14.sp, fontWeight: FontWeight.bold,color: ColorManager.white,decoration: TextDecoration.none),
                          ),
                          Icon(
                            widget.iconName.icon,
                            size: AppSize.s25.sp,
                            color: widget.iconColor,
                          )
                        ],
                      ),
                    ),
                    ProgressBarAnimation(
                      height: 5.h,
                      width: MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: widget.messageTime),
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.secondary,
                          ColorManager.white,
                        ],
                      ),
                      backgroundColor: Colors.grey.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(seconds: 0));
    setState(() {
      _isExpanded = true;
    });
  }
}
