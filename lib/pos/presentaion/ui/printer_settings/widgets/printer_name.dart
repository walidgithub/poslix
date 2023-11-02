import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget printerNameValue(BuildContext context,
    TextEditingController printerNameEditingController, double deviceWidth) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
            autofocus: false,
            keyboardType: TextInputType.number,
            controller: printerNameEditingController,
            decoration: InputDecoration(
                hintText: AppStrings.printerName.tr(),
                contentPadding: const EdgeInsets.fromLTRB(
                    AppPadding.p10, 0, AppPadding.p5, 0),
                hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                labelText: AppStrings.printerName.tr(),
                labelStyle: TextStyle(
                    fontSize: AppSize.s15.sp, color: ColorManager.primary),
                border: InputBorder.none)),
      ],
    ),
  );
}
