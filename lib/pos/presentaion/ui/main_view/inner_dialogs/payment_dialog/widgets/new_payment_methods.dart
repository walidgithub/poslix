import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';
import '../../../../components/text_component.dart';

Widget newPaymentMethods(BuildContext context, Function deletePaymentMethod, bool newPayment, double innerHeight, List paymentMethods, List<TextEditingController> paymentControllers, double total, List<TextEditingController> paymentNotesControllers, Function selectPaymentType, var selectedNewPaymentType, double deviceWidth) {
  return newPayment
      ? SingleChildScrollView(
    physics:
    const AlwaysScrollableScrollPhysics(),
    child: Column(
      children: [
        SizedBox(
          height: AppConstants
              .smallerDistance,
        ),
        SizedBox(
          width: deviceWidth <= 600 ? 375.w : 200.w,
          height: innerHeight,
          child: ListView.builder(
            itemCount:
            paymentMethods.length,
            padding:
            const EdgeInsets.only(
                top: AppSize.s10),
            itemBuilder:
                (BuildContext context,
                int index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                            autofocus:
                            false,
                            keyboardType:
                            TextInputType
                                .number,
                            controller:
                            paymentControllers[
                            index],
                            decoration: InputDecoration(
                                hintText: total
                                    .toString(),
                                hintStyle: TextStyle(
                                    fontSize: AppSize
                                        .s12.sp),
                                labelText: AppStrings
                                    .amount
                                    .tr(),
                                labelStyle: TextStyle(
                                    fontSize: AppSize
                                        .s15.sp,
                                    color: ColorManager
                                        .primary),
                                border:
                                InputBorder.none)),
                      ),
                      SizedBox(
                        width: AppConstants
                            .smallDistance,
                      ),
                      Expanded(
                        flex: 1,
                        child:
                        containerComponent(
                            context,
                            DropdownButton(
                              borderRadius:
                              BorderRadius.circular(AppSize.s5),
                              itemHeight:
                              50.h,
                              hint:
                              textS14PrimaryComponent(context,
                                selectedNewPaymentType[index],
                              ),
                              underline:
                              Container(),
                              items: <
                                  String>[
                                AppStrings.cash.tr(),
                                AppStrings.bank.tr(),
                                AppStrings.cheque.tr(),
                                AppStrings.card.tr()
                              ].map<DropdownMenuItem<String>>((String
                              value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: AppSize.s14.sp),
                                  ),
                                );
                              }).toList(),
                              onChanged:
                                  (selectedType) {
                                selectPaymentType(index, selectedType);
                              },
                              value:
                              selectedNewPaymentType[index],
                              isExpanded:
                              true,
                              icon:
                              Icon(
                                Icons.arrow_drop_down,
                                color:
                                ColorManager.primary,
                                size:
                                AppSize.s20.sp,
                              ),
                              style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: AppSize.s14.sp),
                            ),
                            height: deviceWidth <= 600 ? 44.h : 47.h,
                            padding: const EdgeInsets.fromLTRB(AppPadding
                                .p15, AppPadding
                                .p2, AppPadding
                                .p5, AppPadding
                                .p2),
                            color: ColorManager
                                .white,
                            borderColor:
                            ColorManager
                                .primary,
                            borderWidth:
                            deviceWidth <= 600 ? 1.5.w : 0.5
                                .w,
                            borderRadius:
                            AppSize.s5),
                      ),
                      SizedBox(
                        width: AppConstants
                            .smallDistance,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                            autofocus:
                            false,
                            keyboardType:
                            TextInputType
                                .text,
                            controller:
                            paymentNotesControllers[
                            index],
                            decoration: InputDecoration(
                                hintText: AppStrings
                                    .paymentNotes
                                    .tr(),
                                hintStyle: TextStyle(
                                    fontSize: AppSize
                                        .s12.sp),
                                labelText: AppStrings
                                    .paymentNotes
                                    .tr(),
                                labelStyle: TextStyle(
                                    fontSize:
                                    AppSize.s15.sp,
                                    color: ColorManager.primary),
                                border: InputBorder.none)),
                      ),
                      SizedBox(
                        width: AppConstants
                            .smallDistance,
                      ),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text(
                            AppStrings
                                .action
                                .tr(),
                            style: TextStyle(
                                color: ColorManager
                                    .primary,
                                fontSize: AppSize
                                    .s18
                                    .sp),
                          ),
                          Bounceable(
                            duration: Duration(
                                milliseconds:
                                AppConstants.durationOfBounceable),
                            onTap:
                                () async {
                              await Future.delayed(Duration(
                                  milliseconds:
                                  AppConstants.durationOfBounceable));
                              deletePaymentMethod(index);
                            },
                            child: Icon(
                              Icons
                                  .delete,
                              color: ColorManager
                                  .delete,
                              size: AppSize
                                  .s30
                                  .sp,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppConstants
                        .smallDistance,
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