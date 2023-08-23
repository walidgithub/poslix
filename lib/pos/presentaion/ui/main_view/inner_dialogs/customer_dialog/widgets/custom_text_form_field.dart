import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../popup_dialogs/custom_dialog.dart';

Widget customTextFormField(BuildContext context,
    FocusNode fn, TextEditingController controller, String hint, String label, TextInputType textInputType,
    {FocusNode? nextFN, String? validateText}) {
  return TextFormField(
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFN);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          CustomDialog.show(
              context,
              validateText!,
              const Icon(Icons.close),
              ColorManager.white,
              AppConstants.durationOfSnackBar,
              ColorManager.delete);
        }
        return null;
      },
      focusNode: fn,
      autofocus: false,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: AppSize.s14.sp, color: ColorManager.primary),
          labelText: label,
          labelStyle: TextStyle(
              fontSize: AppSize.s14.sp, color: ColorManager.primary),
          border: InputBorder.none));
}