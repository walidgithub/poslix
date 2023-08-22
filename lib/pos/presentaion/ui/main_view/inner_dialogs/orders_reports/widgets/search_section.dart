import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';

Widget searchSection(BuildContext context, Function searchAction, TextEditingController searchEditingController, bool orderFilter, var selectedSearchType) {
  return Expanded(
    flex: 1,
    child: containerComponent(
        context,
        DropdownButton(
          borderRadius: BorderRadius.circular(AppSize.s5),
          itemHeight: 50.h,
          hint: Text(
            AppStrings.customer.tr(),
            style:
            TextStyle(fontSize: AppSize.s14, color: ColorManager.primary),
          ),
          underline: Container(),
          items: <String>[
            AppStrings.customer.tr(),
            AppStrings.tel.tr(),
            orderFilter! ? AppStrings.orderId.tr() : AppStrings.holdName.tr()
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: AppSize.s14.sp),
              ),
            );
          }).toList(),
          onChanged: (selectedSearch) {
            searchEditingController.text = '';
            searchAction(selectedSearch);
          },
          value: selectedSearchType,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: ColorManager.primary,
            size: AppSize.s20.sp,
          ),
          style: TextStyle(
              color: ColorManager.primary, fontSize: AppSize.s14.sp),
        ),
        height: 47.h,
        padding: const EdgeInsets.fromLTRB(
            AppPadding.p15, AppPadding.p2, AppPadding.p5, AppPadding.p2),
        borderColor: ColorManager.primary,
        borderWidth: 0.5.w,
        borderRadius: AppSize.s5),
  );
}