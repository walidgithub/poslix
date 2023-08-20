import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';

Widget backButton(BuildContext context, Function backAction) {
  return Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Bounceable(
      duration: Duration(milliseconds: AppConstants.durationOfBounceable),
      onTap: () async {
        await Future.delayed(
            Duration(milliseconds: AppConstants.durationOfBounceable));
        await backAction();
      },
      child: containerComponent(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.arrow_back,
                size: AppSize.s20.sp,
                color: ColorManager.white,
              ),
              Center(
                  child: Text(
                    AppStrings.back.tr(),
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ColorManager.white,
                        fontSize: AppSize.s14.sp),
                  )),
            ],
          ),
          height: 30.h,
          width: 50.w,
          color: ColorManager.primary,
          borderColor: ColorManager.primary,
          borderWidth: 0.6.w,
          borderRadius: AppSize.s5),
    ),
  );
}