import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../../shared/utils/global_values.dart';
import '../../components/container_component.dart';
import '../../components/text_component.dart';

Widget buttons(BuildContext context, Function hold, Function delete, Function getOrders, Function checkOut) {
  return Column(
    children: [
      // delete and hold and orders
      Row(
        children: [
          Expanded(
            flex: 1,
            child: Bounceable(
              duration: Duration(
                  milliseconds: AppConstants
                      .durationOfBounceable),
              onTap: () async {
                await Future.delayed(Duration(
                    milliseconds: AppConstants
                        .durationOfBounceable));
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                          Text(AppStrings.warning.tr()),
                          SizedBox(
                            width: AppConstants.smallDistance,
                          ),
                          Icon(Icons.warning_amber_rounded,color: ColorManager.hold,)
                        ],),
                        content: Text(AppStrings.assertDelete.tr()),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(AppStrings.no.tr())),
                          TextButton(
                              onPressed: () {
                                delete(context);
                              },
                              child: Text(AppStrings.yes.tr())),
                        ],
                      );
                    });
              },
              child:
              containerComponent(
                  context,
                  Center(
                      child: textS14WhiteComponent(context,
                        AppStrings.delete.tr(),
                      )),
                  height: 30.h,
                  color: ColorManager.delete,
                  borderColor: ColorManager.delete,
                  borderWidth: 1.w,
                  borderRadius: AppSize.s5
              ),
            ),
          ),
          SizedBox(
            width: AppConstants.smallDistance,
          ),
          Expanded(
            flex: 2,
            child: Bounceable(
              duration: Duration(
                  milliseconds: AppConstants
                      .durationOfBounceable),
              onTap: () async {
                await Future.delayed(Duration(
                    milliseconds: AppConstants
                        .durationOfBounceable));
                hold(context);
              },
              child:
              containerComponent(
                  context,
                  Center(
                      child: textS14WhiteComponent(context,
                        AppStrings.holdCard.tr(),
                      )),
                  height: 30.h,
                  color: ColorManager.hold,
                  borderColor: ColorManager.hold,
                  borderWidth: 1.w,
                  borderRadius: AppSize.s5
              ),
            ),
          ),
          SizedBox(
            width: AppConstants.smallDistance,
          ),
          Expanded(
              flex: 1,
              child: Bounceable(
                duration: Duration(
                    milliseconds: AppConstants
                        .durationOfBounceable),
                onTap: () async {
                  await Future.delayed(Duration(
                      milliseconds: AppConstants
                          .durationOfBounceable));

                  getOrders(context);
                },
                child:
                containerComponent(
                    context,
                    Center(
                        child: textS14WhiteComponent(context,
                          AppStrings.orders.tr(),
                        )),
                    height: 30.h,
                    color: ColorManager.orders,
                    borderColor: ColorManager.orders,
                    borderWidth: 1.w,
                    borderRadius: AppSize.s5
                ),
              )),
        ],
      ),

      SizedBox(
        height: AppConstants.smallDistance,
      ),

      //check out
      Bounceable(
        duration: Duration(
            milliseconds:
            AppConstants.durationOfBounceable),
        onTap: () async {
          await Future.delayed(Duration(
              milliseconds: AppConstants
                  .durationOfBounceable));
          checkOut(context);
        },
        child:
        containerComponent(
            context,
            Center(
                child: Text(
                  GlobalValues.getEditOrder
                      ? AppStrings.saveOrder.tr()
                      : AppStrings.checkOut.tr(),
                  style: TextStyle(
                      color: ColorManager.white,
                      fontSize: AppSize.s18.sp),
                )),
            height: 40.h,
            color: ColorManager.primary,
            borderColor: ColorManager.primary,
            borderWidth: 1.w,
            borderRadius: AppSize.s5
        ),
      )
    ],
  );
}