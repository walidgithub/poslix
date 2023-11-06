
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';

Widget printerNameValue(BuildContext context,
    TextEditingController printerNameEditingController, double deviceWidth, bool editMode, String oldValue, Function getNewValue, bool endEdit) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
            onSubmitted: (String value) {
              oldValue = value;
              endEdit == true;
              getNewValue(value);
            },
            autofocus: true,
            keyboardType: TextInputType.text,
            controller: editMode ? !endEdit ? TextEditingController(text: oldValue) : printerNameEditingController : printerNameEditingController,
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
