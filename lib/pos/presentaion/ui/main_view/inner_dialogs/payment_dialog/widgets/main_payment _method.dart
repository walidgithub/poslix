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
        child: containerComponent(
            context,
            DropdownButton(
              borderRadius:
              BorderRadius.circular(
                  AppSize.s5),
              itemHeight: 50.h,
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
              icon: Icon(
                Icons.arrow_drop_down,
                color: ColorManager.primary,
                size: AppSize.s20.sp,
              ),
              style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: AppSize.s14.sp),
            ),
            height: 47.h,
            padding: const EdgeInsets.fromLTRB(AppPadding.p15, AppPadding.p2, AppPadding.p5, AppPadding.p2),
            borderColor: ColorManager.primary,
            borderWidth: deviceWidth <= 600 ? 1.5.w : 0.5.w,
            borderRadius: AppSize.s5),
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