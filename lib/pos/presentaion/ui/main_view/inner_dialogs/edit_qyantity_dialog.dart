import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/close_button.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';
import '../../components/text_component.dart';

Future editQuantityDialog(
    BuildContext context, double deviceWidth, Function getValue) {
  TextEditingController editValueEditingController = TextEditingController();
  return isApple() ? showCupertinoDialog<void>(context: context, builder: (context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s5)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: deviceWidth <= 600 ? 130.w : 150.w,
              height: deviceWidth <= 600 ? 100.h : 145.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: editValueEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.editQuantity.tr(),
                            hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                            labelText: AppStrings.editQuantity.tr(),
                            labelStyle: TextStyle(
                                fontSize: AppSize.s15,
                                color: ColorManager.primary),
                            border: InputBorder.none)),
                  ),
                  const Divider(
                    thickness: AppSize.s1,
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
                            getValue(int.parse(editValueEditingController.text));
                            Navigator.of(context).pop();
                          },
                          child:
                          containerComponent(
                              context,
                              Center(
                                  child: textS14WhiteComponent(context,
                                    AppStrings.save.tr(),
                                  )),
                              height: deviceWidth <= 600 ? 40.h : 40.h,
                              width: deviceWidth <= 600 ? 100.w : 50.w,
                              color: ColorManager.primary,
                              borderRadius: AppSize.s5,
                              borderColor: ColorManager.primary,
                              borderWidth: 0.6.w
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }) : showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s5)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: deviceWidth <= 600 ? 130.w : 150.w,
                height: deviceWidth <= 600 ? 100.h : 145.h,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          controller: editValueEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.editQuantity.tr(),
                              hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                              labelText: AppStrings.editQuantity.tr(),
                              labelStyle: TextStyle(
                                  fontSize: AppSize.s15,
                                  color: ColorManager.primary),
                              border: InputBorder.none)),
                    ),
                    const Divider(
                      thickness: AppSize.s1,
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
                              getValue(int.parse(editValueEditingController.text));
                              Navigator.of(context).pop();
                            },
                            child:
                            containerComponent(
                                context,
                                Center(
                                    child: textS14WhiteComponent(context,
                                      AppStrings.save.tr(),
                                    )),
                                height: deviceWidth <= 600 ? 40.h : 40.h,
                                width: deviceWidth <= 600 ? 100.w : 50.w,
                                color: ColorManager.primary,
                                borderRadius: AppSize.s5,
                                borderColor: ColorManager.primary,
                                borderWidth: 0.6.w
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
