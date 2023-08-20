import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/style/colors_manager.dart';

Widget mainNotes(BuildContext context, TextEditingController _notesEditingController) {
  return TextField(
      autofocus: false,
      keyboardType: TextInputType.text,
      controller: _notesEditingController,
      decoration: InputDecoration(
          hintText:
          AppStrings.paymentNotes.tr(),
          hintStyle: TextStyle(
              fontSize: AppSize.s12.sp),
          labelText:
          AppStrings.paymentNotes.tr(),
          labelStyle: TextStyle(
              fontSize: AppSize.s15.sp,
              color: ColorManager.primary),
          border: InputBorder.none));
}