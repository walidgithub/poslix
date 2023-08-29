import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget passText(BuildContext context, FocusNode loginPassFN, TextEditingController loginPassEditingController, bool showPass, Function toggleEye) {
  return Expanded(
    flex: 1,
    child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return AppStrings.passwordFieldIsRequired.tr();
          }
          return null;
        },
        focusNode: loginPassFN,
        autofocus: false,
        keyboardType: TextInputType.visiblePassword,
        controller: loginPassEditingController,
        obscureText: !showPass,
        decoration: InputDecoration(
            errorStyle: const TextStyle(
              height: AppSize.s16,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                toggleEye();
              },
              icon: Icon(
                showPass ? Icons.visibility_off : Icons.visibility,
                size: AppSize.s25,
                color: ColorManager.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorManager.grayText, width: AppSize.s1_5),
                borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.s5))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorManager.grayText, width: AppSize.s1_5),
                borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.s5))),
            hintText: AppStrings.enterPassword.tr(),
            hintStyle: TextStyle(fontSize: AppSize.s12.sp),
            labelText: AppStrings.enterPassword.tr(),
            labelStyle:
            TextStyle(fontSize: AppSize.s15.sp, color: ColorManager.gray),
            border: InputBorder.none)),
  );
}