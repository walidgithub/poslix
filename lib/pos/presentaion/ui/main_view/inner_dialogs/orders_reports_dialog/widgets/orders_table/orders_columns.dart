import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/constant/strings_manager.dart';

List<DataColumn> createOrdersColumns(double deviceWidth) {
  return [
    const DataColumn(
      label: Text('#'),
    ),
    DataColumn(
      label: SizedBox(
          width: deviceWidth <= 600 ? 120.w : 40.w, child: Center(child: Text(AppStrings.customer.tr()))),
    ),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 70.w : 25.w, child: Center(child: Text(AppStrings.total.tr())))),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 80.w : 20.w, child: Center(child: Text(AppStrings.action.tr()))))
  ];
}