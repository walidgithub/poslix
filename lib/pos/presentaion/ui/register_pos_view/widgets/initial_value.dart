import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget putInitialValue(BuildContext context,
    TextEditingController posInitialEditingController, double deviceWidth) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(AppStrings.initialPosValue.tr(),
                style: TextStyle(
                    fontSize: AppSize.s20.sp,
                    color: ColorManager.primary,
                    fontWeight: deviceWidth <= 600
                        ? FontWeight.w500
                        : FontWeight.bold))),
        SizedBox(
          height: deviceWidth <= 600
              ? AppConstants.smallWidthBetweenElements
              : AppConstants.smallDistance,
        ),
        TextField(
            autofocus: false,
            cursorColor: ColorManager.primary,
            keyboardType: TextInputType.number,
            controller: posInitialEditingController,
            decoration: InputDecoration(
                hintText: AppStrings.enterValue.tr(),
                contentPadding: const EdgeInsets.fromLTRB(
                    AppPadding.p10, 0, AppPadding.p5, 0),
                hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                labelText: AppStrings.enterValue.tr(),
                labelStyle: TextStyle(
                    fontSize: AppSize.s15.sp, color: ColorManager.primary),
                border: InputBorder.none)),
      ],
    ),
  );
}
