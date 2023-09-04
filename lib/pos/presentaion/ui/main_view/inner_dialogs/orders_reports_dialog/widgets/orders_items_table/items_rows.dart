import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../domain/response/sales_report_items_model.dart';
import '../../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../../shared/style/colors_manager.dart';

List<DataRow> createOrderItemsRows(int decimalPlaces, List<SalesReportItemsResponse> listOfOrderItems, double deviceWidth) {
  return listOfOrderItems[0]
      .products
      .map((orderItem) => DataRow(cells: [
    DataCell(Text(orderItem.id.toString(),
        style: TextStyle(color: ColorManager.edit),
        textAlign: TextAlign.center)),
    DataCell(SizedBox(
      width: deviceWidth <= 600 ? 130.w : 40.w,
      child: Center(
          child: Text(orderItem.name,
              style: TextStyle(fontSize: AppSize.s14.sp),
              textAlign: TextAlign.center)),
    )),
    DataCell(SizedBox(
      width: deviceWidth <= 600 ? 60.w : 25.w,
      child: Center(
          child: Text(
              orderItem.type == 'single'
                  ? '${orderItem.sellPrice.toString().substring(0, orderItem.sellPrice.toString().indexOf('.'))}${orderItem.sellPrice.toString().substring(orderItem.sellPrice.toString().indexOf('.'), orderItem.sellPrice.toString().indexOf('.') + 1 + decimalPlaces)}'
                  : '${orderItem.variations[0].price.toString().substring(0, orderItem.variations[0].price.toString().indexOf('.'))}${orderItem.variations[0].price.toString().substring(orderItem.variations[0].price.toString().indexOf('.'), orderItem.variations[0].price.toString().indexOf('.') + 1 + decimalPlaces)}',
              style: TextStyle(fontSize: AppSize.s14.sp),
              textAlign: TextAlign.center)),
    )),
    DataCell(SizedBox(
      width: deviceWidth <= 600 ? 55.w : 25.w,
      child: Center(
          child: Text(
              '${orderItem.productQty.toString().substring(0, orderItem.productQty.toString().indexOf('.'))}${orderItem.productQty.toString().substring(orderItem.productQty.toString().indexOf('.'), orderItem.productQty.toString().indexOf('.') + 1 + decimalPlaces)}',
              style: TextStyle(fontSize: AppSize.s14.sp),
              textAlign: TextAlign.center)),
    )),
  ]))
      .toList();
}