import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';
import '../../../../components/text_component.dart';

Widget mainPaymentMethod(BuildContext context, double total, Function selectMainPaymentMethod, TextEditingController amountEditingController, TextEditingController _notesInLineEditingController, String selectedPaymentType, double deviceWidth) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: TextField(
            autofocus: false,
            keyboardType:
            TextInputType.number,
            controller:
            amountEditingController,
            decoration: InputDecoration(
                hintText:
                total.toString(),
                hintStyle: TextStyle(
                    fontSize: AppSize.s12.sp),
                labelText:
                AppStrings.amount.tr(),
                labelStyle: TextStyle(
                    fontSize: AppSize.s15.sp,
                    color:
                    ColorManager.primary),
                border: InputBorder.none)),
      ),
      SizedBox(
        width: AppConstants.smallDistance,
      ),
      Expanded(
        flex: 1,
        child: DropdownButton2(
          buttonStyleData: ButtonStyleData(
            height: deviceWidth <= 600 ? 44.h : 47.h,
            width: 250.w,
            padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
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
          hint: textS14PrimaryComponent(context,
            AppStrings.cash.tr(),
          ),
          underline: Container(),
          items: <String>[
            AppStrings.cash.tr(),
            AppStrings.bank.tr(),
            AppStrings.cheque.tr(),
            AppStrings.card.tr()
          ].map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<
                    String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize:
                        AppSize.s14.sp),
                  ),
                );
              }).toList(),
          onChanged: (selectedType) {
            selectMainPaymentMethod(selectedType);
          },
          value: selectedPaymentType,
          isExpanded: true,
          style: TextStyle(
              color: ColorManager.primary,
              fontSize: AppSize.s14.sp),
        ),
      ),
      SizedBox(
        width: AppConstants.smallDistance,
      ),
      Expanded(
        flex: 1,
        child: TextField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller:
            _notesInLineEditingController,
            decoration: InputDecoration(
                hintText: AppStrings
                    .paymentNotes
                    .tr(),
                hintStyle: TextStyle(
                    fontSize: AppSize.s12.sp),
                labelText: AppStrings
                    .paymentNotes
                    .tr(),
                labelStyle: TextStyle(
                    fontSize: AppSize.s15.sp,
                    color:
                    ColorManager.primary),
                border: InputBorder.none)),
      ),
    ],
  );
}