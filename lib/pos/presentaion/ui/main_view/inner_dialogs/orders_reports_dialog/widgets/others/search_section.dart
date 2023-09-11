import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../../shared/style/colors_manager.dart';
import '../../../../../components/container_component.dart';

Widget searchSection(BuildContext context, Function searchAction, TextEditingController searchEditingController, bool orderFilter, var selectedSearchType, double deviceWidth) {
  return Expanded(
    flex: 1,
    child: DropdownButton2(
      buttonStyleData: ButtonStyleData(
        height: deviceWidth <= 600 ? 44.h : 47.h,
        width: 250.w,
        padding: const EdgeInsets.only(left: AppPadding.p12, right: AppPadding.p12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s5),
          border: Border.all(
            color: ColorManager.primary,
          ),
          color: ColorManager.white,
        ),
        elevation: 2,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 400.h,
        width: 110.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s5),
          color: ColorManager.white,
        ),
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      hint: Text(
        AppStrings.customer.tr(),
        style:
        TextStyle(fontSize: AppSize.s14, color: ColorManager.primary),
      ),
      underline: Container(),
      items: <String>[
        AppStrings.customer.tr(),
        AppStrings.tel.tr(),
        orderFilter ? AppStrings.orderId.tr() : AppStrings.holdName.tr()
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
      style: TextStyle(
          color: ColorManager.primary, fontSize: AppSize.s14.sp),
    ),
  );
}