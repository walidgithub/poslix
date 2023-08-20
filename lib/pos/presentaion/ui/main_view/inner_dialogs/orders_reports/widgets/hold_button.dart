import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../shared/constant/assets_manager.dart';
import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';

Widget holdButton(BuildContext context, Function holdAction, bool orderItems, bool orderFilter) {
  return Bounceable(
    duration: Duration(milliseconds: AppConstants.durationOfBounceable),
    onTap: () async {
      await Future.delayed(
          Duration(milliseconds: AppConstants.durationOfBounceable));
      await holdAction();
    },
    child: Container(
      height: 40.h,
      width: 60.w,
      padding: const EdgeInsets.fromLTRB(
          AppPadding.p0, AppPadding.p5, AppPadding.p0, AppPadding.p5),
      decoration: BoxDecoration(
          color: orderItems
              ? ColorManager.white
              : orderFilter
              ? ColorManager.white
              : ColorManager.primary,
          border: Border.all(color: ColorManager.primary, width: 0.5.w),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSize.s5),
              topLeft: Radius.circular(AppSize.s5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(ImageAssets.hold,
              width: AppSize.s25.sp,
              color: orderItems
                  ? ColorManager.primary
                  : orderFilter
                  ? ColorManager.primary
                  : ColorManager.white),
          Center(
              child: Text(
                AppStrings.hold.tr(),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: orderItems
                      ? ColorManager.primary
                      : orderFilter
                      ? ColorManager.primary
                      : ColorManager.white,
                  fontSize: AppSize.s18.sp,
                ),
              ))
        ],
      ),
    ),
  );
}