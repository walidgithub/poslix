import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget leftPart(BuildContext context) {
  return Expanded(
      flex: 1,
      child: containerComponent(
          context,
          Column(
            children: [
              Image.asset(
                ImageAssets.loginScreen,
                width: 400.w,
                height: 400.h,
              ),
              SizedBox(
                height: AppConstants.smallDistance,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.manageYourBusiness.tr(),
                    style: TextStyle(
                        fontSize: AppSize.s20.sp, color: ColorManager.black),
                  ),
                  SizedBox(
                    height: AppConstants.smallDistance,
                  ),
                  Text(
                    AppStrings.easilyManageYourStoreWith.tr(),
                    style: TextStyle(
                        fontSize: AppSize.s14.sp, color: ColorManager.gray),
                  ),
                  SizedBox(
                    height: AppConstants.smallerDistance,
                  ),
                  Text(
                    AppStrings.poslixPOSScreen.tr(),
                    style: TextStyle(
                        fontSize: AppSize.s14.sp, color: ColorManager.gray),
                  ),
                ],
              )
            ],
          ),
          height: MediaQuery.of(context).size.height - 80.h,
          padding: const EdgeInsets.all(AppPadding.p5),
          color: ColorManager.secondary,
          borderRadius: AppSize.s5,
          borderColor: ColorManager.secondary,
          borderWidth: 1.5.w));
}