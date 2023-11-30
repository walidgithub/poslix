import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../domain/response/payment_method_model.dart';
import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';
import '../../../../components/text_component.dart';

Widget newPaymentMethods(
    BuildContext context,
    Function deletePaymentMethod,
    bool newPayment,
    double innerHeight,
    List paymentRows,
    List<TextEditingController> paymentControllers,
    double total,
    List<TextEditingController> paymentNotesControllers,
    Function selectPaymentType,
    var selectedNewPaymentType,
    double deviceWidth, List<String> paymentMethods) {
  return newPayment
      ? SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: AppConstants.smallerDistance,
              ),
              SizedBox(
                width: deviceWidth <= 600 ? 375.w : 200.w,
                height: innerHeight,
                child: ListView.builder(
                  itemCount: paymentRows.length,
                  padding: const EdgeInsets.only(top: AppSize.s10),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                  cursorColor: ColorManager.primary,
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  controller: paymentControllers[index],
                                  decoration: InputDecoration(
                                      hintText: total.toString(),
                                      hintStyle:
                                          TextStyle(fontSize: AppSize.s12.sp),
                                      labelText: AppStrings.amount.tr(),
                                      labelStyle: TextStyle(
                                          fontSize: AppSize.s15.sp,
                                          color: ColorManager.primary),
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
                                  padding: const EdgeInsets.only(
                                      left: AppPadding.p14,
                                      right: AppPadding.p14),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(AppSize.s5),
                                    border: Border.all(
                                      color: ColorManager.primary,
                                    ),
                                    color: ColorManager.white,
                                  ),
                                  elevation: 2,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 400.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(AppSize.s5),
                                    color: ColorManager.white,
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                    MaterialStateProperty.all<double>(
                                        6),
                                    thumbVisibility:
                                    MaterialStateProperty.all<bool>(
                                        true),
                                  ),
                                ),
                                hint: textS14PrimaryComponent(context,
                                  paymentMethods[0],
                                ),
                                underline: Container(),
                                items: paymentMethods.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
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
                                  selectPaymentType(index, selectedType);
                                },
                                value: selectedNewPaymentType[index],
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
                                  controller: paymentNotesControllers[index],
                                  decoration: InputDecoration(
                                      hintText: AppStrings.paymentNotes.tr(),
                                      hintStyle:
                                          TextStyle(fontSize: AppSize.s12.sp),
                                      labelText: AppStrings.paymentNotes.tr(),
                                      labelStyle: TextStyle(
                                          fontSize: AppSize.s15.sp,
                                          color: ColorManager.primary),
                                      border: InputBorder.none)),
                            ),
                            SizedBox(
                              width: AppConstants.smallDistance,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.action.tr(),
                                  style: TextStyle(
                                      color: ColorManager.primary,
                                      fontSize: AppSize.s18.sp),
                                ),
                                Bounceable(
                                  duration: Duration(
                                      milliseconds:
                                          AppConstants.durationOfBounceable),
                                  onTap: () async {
                                    await Future.delayed(Duration(
                                        milliseconds:
                                            AppConstants.durationOfBounceable));
                                    deletePaymentMethod(index);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: ColorManager.delete,
                                    size: AppSize.s30.sp,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppConstants.smallDistance,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        )
      : const SizedBox.shrink();
}
