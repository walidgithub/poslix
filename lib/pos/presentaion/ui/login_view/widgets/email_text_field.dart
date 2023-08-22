import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';

Widget emailText(BuildContext context, RegExp regexMail,FocusNode loginPassFN, FocusNode loginEmailFN, TextEditingController loginEmailEditingController) {
  return Expanded(
    flex: 1,
    child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return AppStrings
                .emailFieldIsRequired
                .tr();
          }
          if (!regexMail
              .hasMatch(value)) {
            return AppStrings
                .emailNotValid
                .tr();
          } else {
            return null;
          }
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context)
              .requestFocus(
              loginPassFN);
        },
        focusNode: loginEmailFN,
        autofocus: false,
        keyboardType:
        TextInputType
            .emailAddress,
        controller:
        loginEmailEditingController,
        decoration:
        InputDecoration(
            errorStyle:
            const TextStyle(
              height:
              AppSize.s16,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorManager
                        .grayText,
                    width: AppSize
                        .s1_5),
                borderRadius: const BorderRadius.all(
                    Radius.circular(
                        AppSize
                            .s5))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorManager
                        .grayText,
                    width: AppSize
                        .s1_5),
                borderRadius:
                const BorderRadius.all(Radius.circular(AppSize.s5))),
            hintText: AppStrings.enterEmail.tr(),
            hintStyle: TextStyle(fontSize: AppSize.s12.sp),
            labelText: AppStrings.enterEmail.tr(),
            labelStyle: TextStyle(fontSize: AppSize.s15.sp, color: ColorManager.gray),
            border: InputBorder.none)),
  );
}