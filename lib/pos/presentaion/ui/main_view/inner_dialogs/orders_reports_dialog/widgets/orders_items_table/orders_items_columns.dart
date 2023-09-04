import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/constant/strings_manager.dart';

List<DataColumn> createOrderItemsColumns(double deviceWidth) {
  return [
    const DataColumn(
      label: Text(
        '#',
        textAlign: TextAlign.center,
      ),
    ),
    DataColumn(
      label: SizedBox(
          width: deviceWidth <= 600 ? 130.w : 40.w,
          child: Center(
              child: Text(
                AppStrings.name.tr(),
                textAlign: TextAlign.center,
              ))),
    ),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 60.w : 25.w,
            child: Center(
                child: Text(
                  AppStrings.price.tr(),
                  textAlign: TextAlign.center,
                )))),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 55.w : 25.w,
            child: Center(
                child: Text(
                  AppStrings.qny.tr(),
                  textAlign: TextAlign.center,
                )))),
  ];
}