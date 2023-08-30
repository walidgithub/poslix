import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget ordersBtnMobile() {
  return Container(
    height: 50.h,
    width: 150.w,
    decoration: BoxDecoration(
        color: ColorManager.primary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(AppSize.s10),
    ),
    child: Center(child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          ImageAssets.listOrders,
          width: AppSize.s25,
          color: ColorManager.white
        ),
        Text(AppStrings.orders.tr(),style: TextStyle(color: ColorManager.white,fontSize: AppSize.s18.sp,fontWeight: FontWeight.bold),)
      ],
    )),
  );
}