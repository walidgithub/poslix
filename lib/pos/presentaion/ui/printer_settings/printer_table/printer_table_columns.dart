import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/strings_manager.dart';

List<DataColumn> createColumns(double deviceWidth) {
  return [
    const DataColumn(
      label: Text('#'),
    ),
    DataColumn(
      label: SizedBox(
          width: deviceWidth <= 600 ? 100.w : 40.w, child: Center(child: Text(AppStrings.printerName.tr()))),
    ),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 100.w : 42.w,
            child: Center(
                child: Text(
                  AppStrings.printerStatus.tr(),
                )))),
    DataColumn(
        label: SizedBox(
            width: deviceWidth <= 600 ? 50.w : 20.w, child: Center(child: Text(AppStrings.action.tr()))))
  ];
}