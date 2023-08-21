import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/close_button.dart';
import '../../components/text_component.dart';

class ShippingDialog extends StatefulWidget {

  Function getShippingValue;

  static void show(BuildContext context, Function getShippingValue) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => ShippingDialog(
      getShippingValue: getShippingValue,
    ),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  ShippingDialog({required this.getShippingValue, super.key});

  @override
  State<ShippingDialog> createState() => _ShippingDialogState();
}

class _ShippingDialogState extends State<ShippingDialog> {
  TextEditingController numberEditingController = TextEditingController();

  @override
  void dispose() {
    numberEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: 200.w,
          height: 200.h,
          child: Container(
            decoration: BoxDecoration(
                color: ColorManager.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppSize.s5),
                boxShadow: [BoxShadow(color: ColorManager.badge)]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 150.w,
                height: 170.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(AppStrings.shippingValue.tr(),
                            style: TextStyle(
                                fontSize: AppSize.s20.sp,
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: AppConstants.heightBetweenElements,
                    ),
                    Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(AppStrings.editShippingValue.tr(),
                            style: TextStyle(
                                fontSize: AppSize.s18.sp, color: ColorManager.primary))),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: 50.w,
                            child: TextField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: numberEditingController,
                                decoration: InputDecoration(
                                    hintText: '0',
                                    labelText: AppStrings.numberField.tr(),
                                    border: InputBorder.none)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        closeButton(context),
                        Bounceable(
                          duration: Duration(milliseconds: AppConstants.durationOfBounceable),
                          onTap: () async {
                            await Future.delayed(
                                Duration(milliseconds: AppConstants.durationOfBounceable));
                            widget.getShippingValue(double.parse(numberEditingController.text));
                            ShippingDialog.hide(context);
                          },
                          child: Container(
                            height: 30.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                                color: ColorManager.primary,
                                border: Border.all(
                                    color: ColorManager.primary, width: 0.6.w),
                                borderRadius: BorderRadius.circular(AppSize.s5)),
                            child: Center(
                                child: textS14WhiteComponent(context,
                                  AppStrings.update.tr(),
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}