import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/constant/strings_manager.dart';

List<DataColumn> createOrderItemsColumns() {
  return [
    const DataColumn(
      label: Text(
        '#',
        textAlign: TextAlign.center,
      ),
    ),
    DataColumn(
      label: SizedBox(
          width: 40.w,
          child: Center(
              child: Text(
                AppStrings.name.tr(),
                textAlign: TextAlign.center,
              ))),
    ),
    DataColumn(
        label: SizedBox(
            width: 25.w,
            child: Center(
                child: Text(
                  AppStrings.price.tr(),
                  textAlign: TextAlign.center,
                )))),
    DataColumn(
        label: SizedBox(
            width: 25.w,
            child: Center(
                child: Text(
                  AppStrings.qny.tr(),
                  textAlign: TextAlign.center,
                )))),
  ];
}