import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../domain/entities/order_model.dart';
import '../../../../../../../domain/response/appearance_model.dart';
import '../../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../../shared/style/colors_manager.dart';
import '../../../../../../../shared/utils/utils.dart';

Widget billModel(
    BuildContext context,
    ScreenshotController screenshotController,
    DateTime today,
    AppearanceResponse appearanceResponse,
    int orderId,
    double taxAmount,
    double discountAmount,
    double total,
    double totalPaying,
    double due,
    double deviceWidth,
    int decimalPlaces,bool isMultiLang) {
  return Screenshot(
    controller: screenshotController,
    child: SizedBox(
        width: deviceWidth <= 600 ? 180.w : 150.w,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: deviceWidth <= 600 ? 50.w : 50.w,
                  height: deviceWidth <= 600 ? 20.h : 150.h,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: ColorManager.badge, width: 0.5.w),
                      borderRadius: BorderRadius.circular(
                          deviceWidth <= 600 ? AppSize.s0 : AppSize.s5),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(appearanceResponse.en.logo),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Text(
                  isMultiLang ? '${appearanceResponse.en.name} ${appearanceResponse.ar.name}' : appearanceResponse.en.name,
                  style: TextStyle(
                      fontSize:
                          deviceWidth <= 600 ? AppSize.s10.sp : AppSize.s20.sp),
                ),
                SizedBox(
                    height: deviceWidth <= 600
                        ? AppConstants.smallerDistance
                        : AppConstants.smallDistance),
                Text(appearanceResponse.en.tell,
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
                      Text(isMultiLang ? '${appearanceResponse.en.txtCustomer} ${appearanceResponse.ar.txtCustomer}' : appearanceResponse.en.txtCustomer,
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
                      Text(isMultiLang ? '${appearanceResponse.en.orderNo} ${appearanceResponse.ar.orderNo}' : appearanceResponse.en.orderNo,
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
                      Text(isMultiLang ? '${appearanceResponse.en.txtDate} ${appearanceResponse.ar.txtDate}' : appearanceResponse.en.txtDate,
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
                  flex: 3,
                  child: Center(
                    child: Text(isMultiLang ? '${appearanceResponse.en.txtQty} ${appearanceResponse.ar.txtQty}' : appearanceResponse.en.txtQty,
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
                    child: Text(isMultiLang ? '${appearanceResponse.en.txtItem} ${appearanceResponse.ar.txtItem}' : appearanceResponse.en.txtItem,
                        style: TextStyle(
                            fontSize: deviceWidth <= 600
                                ? AppSize.s10.sp
                                : AppSize.s20.sp),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      isMultiLang ? '${appearanceResponse.en.txtAmount} ${appearanceResponse.ar.txtAmount}' : appearanceResponse.en.txtAmount,
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
                          flex: 3,
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
                          flex: 4,
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
                      ? const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p0,
                          AppPadding.p10, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p5,
                          AppPadding.p10, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMultiLang ? '${appearanceResponse.en.txtTax} ${appearanceResponse.ar.txtTax}' : appearanceResponse.en.txtTax,
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
                      ? const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p0,
                          AppPadding.p10, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p5,
                          AppPadding.p10, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMultiLang ? '${AppStrings.discount3} الخصم' : AppStrings.discount3,
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
                      ? const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p0,
                          AppPadding.p10, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p5,
                          AppPadding.p10, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMultiLang ? '${appearanceResponse.en.txtTotal} ${appearanceResponse.ar.txtTotal}' : appearanceResponse.en.txtTotal,
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
                      ? const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p0,
                          AppPadding.p10, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p5,
                          AppPadding.p10, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMultiLang ? '${AppStrings.amountPaid} اجمالى المدفوعات' : AppStrings.amountPaid,
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
                      ? const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p0,
                          AppPadding.p10, AppPadding.p0)
                      : const EdgeInsets.fromLTRB(AppPadding.p10, AppPadding.p5,
                          AppPadding.p10, AppPadding.p5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMultiLang ? '${AppStrings.totalDue} الباقى' : AppStrings.totalDue,
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
                        deviceWidth <= 600 ? AppSize.s10.sp : AppSize.s20.sp)),
            SizedBox(
                height: deviceWidth <= 600
                    ? AppConstants.smallerDistance
                    : AppConstants.smallDistance
            ),
            Text(isMultiLang ? '${appearanceResponse.en.footer} ${appearanceResponse.ar.footer}' : appearanceResponse.en.footer,
                style: TextStyle(
                    fontSize:
                    deviceWidth <= 600 ? AppSize.s10.sp : AppSize.s20.sp))
          ],
        )),
  );
}
