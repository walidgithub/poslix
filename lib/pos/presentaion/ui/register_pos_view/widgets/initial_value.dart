import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget putInitialValue(BuildContext context,TextEditingController posInitialEditingController,double deviceWidth) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: deviceWidth <= 800 ? 300.w : 150.w,
      height: deviceWidth <= 800 ? 70.h : 125.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment:
              AlignmentDirectional
                  .topStart,
              child: Text(
                  AppStrings.initialPosValue
                      .tr(),
                  style: TextStyle(
                      fontSize:
                      AppSize.s20.sp,
                      color: ColorManager
                          .primary,
                      fontWeight: deviceWidth <= 800 ? FontWeight.w500 : FontWeight
                          .bold))),
          SizedBox(
            height:
            AppConstants.smallWidthBetweenElements,
          ),
          Expanded(
            flex: 1,
            child: TextField(
                autofocus: false,
                keyboardType:
                TextInputType.number,
                controller:
                posInitialEditingController,
                decoration: InputDecoration(
                    hintText: AppStrings
                        .enterValue
                        .tr(),
                    contentPadding:
                    const EdgeInsets.only(
                        left: AppPadding
                            .p15),
                    hintStyle: TextStyle(
                        fontSize:
                        AppSize.s12.sp),
                    labelText: AppStrings
                        .enterValue
                        .tr(),
                    labelStyle: TextStyle(
                        fontSize:
                        AppSize.s15.sp,
                        color: ColorManager
                            .primary),
                    border: InputBorder.none)),
          ),
        ],
      ),
    ),
  );
}