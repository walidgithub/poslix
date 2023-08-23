import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';
import '../../../../components/text_component.dart';

Widget totals(BuildContext context, double total,String changedTotal, double changeReturn, double balance, String currencyCode) {
  return containerComponent(
      context,
      Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              textS14WhiteComponent(context,
                AppStrings.totalPayable.tr(),
              ),
              SizedBox(
                height:
                AppConstants.smallDistance,
              ),
              textS14WhiteComponent(context,
                '$total $currencyCode',
              ),
            ],
          ),
          Column(
            children: [
              textS14WhiteComponent(context,
                AppStrings.totalPaying.tr(),
              ),
              SizedBox(
                height:
                AppConstants.smallDistance,
              ),
              textS14WhiteComponent(context,
                '$changedTotal $currencyCode',
              ),
            ],
          ),
          Column(
            children: [
              textS14WhiteComponent(context,
                AppStrings.changeReturn.tr(),
              ),
              SizedBox(
                height:
                AppConstants.smallDistance,
              ),
              textS14WhiteComponent(context,
                '$changeReturn $currencyCode',
              ),
            ],
          ),
          Column(
            children: [
              textS14WhiteComponent(context,
                AppStrings.balance.tr(),
              ),
              SizedBox(
                height:
                AppConstants.smallDistance,
              ),
              textS14WhiteComponent(context,
                '$balance $currencyCode',
              ),
            ],
          ),
        ],
      ),
      height: 75.h,
      width: 200.w,
      padding: const EdgeInsets.all(AppPadding.p10),
      color: ColorManager.primary,
      borderColor: ColorManager.primary,
      borderWidth: 0.6.w,
      borderRadius: AppSize.s5
  );
}