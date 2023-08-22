import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../domain/entities/order_model.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/style/colors_manager.dart';

Widget billModel(BuildContext context, ScreenshotController screenshotController, DateTime today, String businessName, String businessImage, String businessTell, int orderId, double taxAmount, double discountAmount, double total, double totalPaying, double due) {
  return Screenshot(
    controller: screenshotController,
    child: SizedBox(
        width: 200.w,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: 50.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: ColorManager.badge, width: 0.5.w),
                      borderRadius: BorderRadius.circular(AppSize.s5),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(businessImage),
                          fit: BoxFit.fill)),
                ),
                SizedBox(height: AppConstants.smallDistance),
                Text(
                  businessName,
                  style: TextStyle(fontSize: AppSize.s20.sp),
                ),
                SizedBox(height: AppConstants.smallDistance),
                Text(businessTell,
                    style: TextStyle(fontSize: AppSize.s20.sp)),
                SizedBox(height: AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.customer,
                          style: TextStyle(fontSize: AppSize.s20.sp)),
                      Text(listOfOrders[0].customer!,
                          style: TextStyle(fontSize: AppSize.s20.sp)),
                    ]),
                SizedBox(height: AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.orderNo,
                          style: TextStyle(fontSize: AppSize.s20.sp)),
                      Text(orderId.toString()),
                    ]),
                SizedBox(height: AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.date,
                          style: TextStyle(fontSize: AppSize.s20.sp)),
                      Text(today.toString().substring(0, 10),
                          style: TextStyle(fontSize: AppSize.s20.sp)),
                    ]),
                Divider(
                  thickness: 2,
                  color: ColorManager.black,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("Qty",
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Text("Item",
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Total",
                      style: TextStyle(fontSize: AppSize.s20.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.smallDistance,
            ),
            Divider(
              thickness: 2,
              color: ColorManager.black,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: listOfOrders.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                                listOfOrders[index].itemQuantity.toString(),
                                style: TextStyle(fontSize: AppSize.s16.sp),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Text(
                                listOfOrders[index].itemName.toString(),
                                style: TextStyle(fontSize: AppSize.s16.sp),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              listOfOrders[index].itemAmount.toString(),
                              style: TextStyle(fontSize: AppSize.s16.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    )
                  ],
                );
              },
            ),
            Divider(
              thickness: 2,
              color: ColorManager.black,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p5, AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.tax.tr(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        taxAmount.toString(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p5, AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.discount3.tr(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        discountAmount.toString(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p5, AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.total2.tr(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        total.toString(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p5, AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.amountPaid.tr(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        totalPaying.toString(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p5, AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalDue.tr(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        due.toString(),
                        style: TextStyle(fontSize: AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: ColorManager.black,
            ),
            Text(AppStrings.termsAndConditions.tr(),
                style: TextStyle(fontSize: AppSize.s20.sp))
          ],
        )),
  );
}