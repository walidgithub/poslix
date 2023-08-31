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
              width: AppSize.s60,
              color: ColorManager.darkGray,
            ),
            SizedBox(
              height: AppConstants
                  .smallDistance,
            ),
            Text(
              address,
              style: TextStyle(
                  fontSize: AppSize.s14.sp),
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
                        .primary))
          ],
        ),
        width: deviceWidth <= 600 ? 130.w : 50.w,
        height: 200.h,
        padding: const EdgeInsets.all(
            AppPadding.p10),
        color: ColorManager.secondary,
        borderColor: ColorManager.secondary,
        borderWidth: 0.1.w,
        borderRadius: AppSize.s5
    );
}