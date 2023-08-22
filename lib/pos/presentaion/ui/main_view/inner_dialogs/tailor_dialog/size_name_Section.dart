import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/style/colors_manager.dart';

Widget sizeName(BuildContext context, TextEditingController sizeNameEditingController) {
  return TextField(
      autofocus: false,
      keyboardType: TextInputType.text,
      controller: sizeNameEditingController,
      decoration: InputDecoration(
          hintText: AppStrings.sizeName.tr(),
          hintStyle: TextStyle(fontSize: AppSize.s12.sp),
          labelText: AppStrings.sizeName.tr(),
          labelStyle: TextStyle(
              fontSize: AppSize.s15.sp, color: ColorManager.primary),
          border: InputBorder.none));
}