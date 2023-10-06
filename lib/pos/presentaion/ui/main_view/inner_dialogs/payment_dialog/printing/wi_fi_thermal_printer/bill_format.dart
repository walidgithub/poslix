import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../domain/entities/order_model.dart';
import '../../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../../shared/style/colors_manager.dart';
import '../../../../../../../shared/utils/utils.dart';

Widget billModel(
    BuildContext context,
    ScreenshotController screenshotController,
    DateTime today,
    String businessName,
    String businessImage,
    String businessTell,
    int orderId,
    double taxAmount,
    double discountAmount,
    double total,
    double totalPaying,
    double due,
    double deviceWidth,
    int decimalPlaces) {
  return Screenshot(
    controller: screenshotController,
    child: SizedBox(
        width: deviceWidth <= 600 ? 180.w : 150.w,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: deviceWidth <= 600 ? 30.w : 50.w,
                  height: deviceWidth <= 600 ? 10.h : 150.h,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorManager.badge, width: 0.5.w),
                      borderRadius: BorderRadius.circular(
                          deviceWidth <= 600 ? AppSize.s0 : AppSize.s5),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(businessImage),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Text(
                  businessName,
                  style: TextStyle(
                      fontSize:
                          deviceWidth <= 600 ? AppSize.s10.sp : AppSize.s20.sp),
                ),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Text(businessTell,
                    style: TextStyle(
                        fontSize: deviceWidth <= 600
                            ? AppSize.s10.sp
                            : AppSize.s20.sp)),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.customer,
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                      Text(listOfOrders[0].customer!,
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                    ]),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.orderNo,
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                      Text(orderId.toString(),
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                    ]),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.date,
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                      Text(today.toString().substring(0, 10),
                          style: TextStyle(
                              fontSize: deviceWidth <= 600
                                  ? AppSize.s10.sp
                                  : AppSize.s20.sp)),
                    ]),
                Divider(
                  thickness: deviceWidth <= 600 ? 1 : 2,
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
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Text("Item",
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Total",
                      style: TextStyle(
                          fontSize: deviceWidth <= 600
                              ? AppSize.s10.sp
                              : AppSize.s20.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppConstants.smallerDistance,
            ),
            Divider(
              thickness: deviceWidth <= 600 ? 1 : 2,
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
                                style: TextStyle(
                                    fontSize: deviceWidth <= 600
                                        ? AppSize.s8.sp
                                        : AppSize.s16.sp),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Text(listOfOrders[index].itemName.toString(),
                                style: TextStyle(
                                    fontSize: deviceWidth <= 600
                                        ? AppSize.s8.sp
                                        : AppSize.s16.sp),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              roundDouble(double.parse(listOfOrders[index].itemAmount.toString()), decimalPlaces).toString(),
                              style: TextStyle(
                                  fontSize: deviceWidth <= 600
                                      ? AppSize.s8.sp
                                      : AppSize.s16.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.smallerDistance,
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
              thickness: deviceWidth <= 600 ? 1 : 2,
              color: ColorManager.black,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: deviceWidth <= 600
                      ? const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p0,
                          AppPadding.p20, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p5,
                          AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.tax.tr(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        roundDouble(taxAmount, decimalPlaces).toString(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: deviceWidth <= 600 ? 1 : 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: deviceWidth <= 600
                      ? const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p0,
                          AppPadding.p20, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p5,
                          AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.discount3.tr(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        roundDouble(discountAmount, decimalPlaces).toString(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: deviceWidth <= 600 ? 1 : 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: deviceWidth <= 600
                      ? const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p0,
                          AppPadding.p20, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p5,
                          AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.total2.tr(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        roundDouble(total, decimalPlaces).toString(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: deviceWidth <= 600 ? 1 : 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: deviceWidth <= 600
                      ? const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p0,
                          AppPadding.p20, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p5,
                          AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.amountPaid.tr(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        roundDouble(totalPaying, decimalPlaces).toString(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: deviceWidth <= 600 ? 1 : 2,
                  color: ColorManager.black,
                ),
                Padding(
                  padding: deviceWidth <= 600
                      ? const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p0,
                          AppPadding.p20, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p20, AppPadding.p5,
                          AppPadding.p20, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalDue.tr(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        roundDouble(due, decimalPlaces).toString(),
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: deviceWidth <= 600 ? 1 : 2,
              color: ColorManager.black,
            ),
            Text(AppStrings.termsAndConditions.tr(),
                style: TextStyle(
                    fontSize:
                        deviceWidth <= 600 ? AppSize.s10.sp : AppSize.s20.sp))
          ],
        )),
  );
}
