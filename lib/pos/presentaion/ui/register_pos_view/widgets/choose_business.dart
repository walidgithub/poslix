import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget chooseBusiness(BuildContext context, List<dynamic> listOfBusinesses, Function dropDown) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 150.w,
      height: 80.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment:
              AlignmentDirectional
                  .topStart,
              child: Text(
                  AppStrings.chooseBusiness
                      .tr(),
                  style: TextStyle(
                      fontSize:
                      AppSize.s20.sp,
                      color: ColorManager
                          .primary,
                      fontWeight: FontWeight
                          .bold))),
          SizedBox(
            height:
            AppConstants.smallDistance,
          ),
          Expanded(
              flex: 1,
              child: containerComponent(
                  context,
                  dropDown(context, listOfBusinesses, AppStrings.chooseBusiness.tr()),
                  height: 10.h,
                  padding: const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p2, AppPadding.p5, AppPadding.p2),
                  borderRadius: AppSize.s5,
                  borderColor:
                  ColorManager.primary,
                  borderWidth: 0.6.w)),
        ],
      ),
    ),
  );
}