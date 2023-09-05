import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';

Widget moneyMethods(BuildContext context, String image,String address,String value, String currencyCode, double deviceWidth) {
  return
    containerComponent(
        context,
        Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              image,
              width: deviceWidth <= 600 ? AppSize.s40 : AppSize.s60,
              color: ColorManager.darkGray,
            ),
            SizedBox(
              height: AppConstants
                  .smallDistance,
            ),
            Text(
              address,
              style: TextStyle(
                  fontSize: AppSize.s14.sp),textAlign: TextAlign.center,
            ),
            SizedBox(
              height: AppConstants
                  .smallDistance,
            ),
            Text(
                '$value $currencyCode',
                style: TextStyle(
                    fontSize: AppSize.s18.sp,
                    fontWeight:
                    FontWeight.bold,
                    color: ColorManager
                        .primary),)
          ],
        ),
        width: deviceWidth <= 600 ? 105.w : 50.w,
        height: deviceWidth <= 600 ? 120.h : 200.h,
        padding: deviceWidth <= 600 ? const EdgeInsets.all(
            AppPadding.p5) : const EdgeInsets.all(
            AppPadding.p10),
        color: ColorManager.secondary,
        borderColor: ColorManager.secondary,
        borderWidth: 0.1.w,
        borderRadius: AppSize.s5
    );
}