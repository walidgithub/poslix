import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';

Widget total(BuildContext context, double calcTotal) {
  return Row(
    children: [
      Text(
          AppStrings.lineTotal.tr(),
          style: TextStyle(
              color: ColorManager.primary, fontSize: AppSize.s14.sp)),
      SizedBox(
        width: AppConstants.smallDistance,
      ),
      Text(
          calcTotal == 0 ? AppStrings.selectFirst.tr() : calcTotal.toString(),
          style: TextStyle(
              color: ColorManager.primary, fontSize: AppSize.s14.sp)),
    ],
  );
}