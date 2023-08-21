import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../../shared/utils/global_values.dart';
import '../../components/text_component.dart';

Widget constantsAndTotal(BuildContext context, double estimatedTax, int tax, Function editShipping, Function editDiscount, double shippingCharge, double discount, String currencyCode, double totalAmount, double differenceValue) {
  return Column(
    children: [
      Divider(
        height: 20.h,
        color: ColorManager.primary,
      ),

      // tax and shipping
      Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  textS12Component(context,
                    '${AppStrings.estimatedTax.tr()} ($tax%)',
                  ),
                  textS12Component(context,estimatedTax.toString(),),
                ],
              )),
          SizedBox(
            width: AppConstants
                .smallWidthBetweenElements,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                textS12Component(context,AppStrings.shippingCharge.tr()),
                Bounceable(
                  duration: Duration(
                      milliseconds: AppConstants
                          .durationOfBounceable),
                  onTap: () async {
                    await Future.delayed(Duration(
                        milliseconds: AppConstants
                            .durationOfBounceable));
                    editShipping(context);
                  },
                  child: Icon(
                    Icons.edit,
                    color: ColorManager.primary,
                    size: AppSize.s20.sp,
                  ),
                ),
                textS12Component(context,shippingCharge.toString(),),
              ],
            ),
          ),
        ],
      ),

      SizedBox(
        height: AppConstants.smallDistance,
      ),

      // discount and total
      Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                textS12Component(context,AppStrings.discount.tr(),),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Bounceable(
                      duration: Duration(
                          milliseconds: AppConstants
                              .durationOfBounceable),
                      onTap: () async {
                        await Future.delayed(Duration(
                            milliseconds: AppConstants
                                .durationOfBounceable));
                        editDiscount(context);
                      },
                      child: Icon(
                        Icons.edit,
                        color: ColorManager.primary,
                        size: AppSize.s20.sp,
                      ),
                    ),
                    SizedBox(
                      width: AppConstants
                          .smallDistance,
                    ),
                    textS12Component(context,
                      '${discount.toString()} $currencyCode',),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: AppConstants
                .smallWidthBetweenElements,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                textS12Component(context,AppStrings.totalAmount.tr()),
                textS12Component(context,totalAmount.toString()),
                textS12Component(context,currencyCode,),
              ],
            ),
          )
        ],
      ),

      SizedBox(
        height: AppConstants.smallDistance,
      ),

      // difference
      GlobalValues.getEditOrder
          ? Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          const Text(''),
          const Text(''),
          textS12Component(context,AppStrings.difference.tr()),
          textS12Component(context,differenceValue.toString()),
        ],
      )
          : const SizedBox.shrink(),
      SizedBox(
        height: AppConstants.smallDistance,
      ),
    ],
  );
}