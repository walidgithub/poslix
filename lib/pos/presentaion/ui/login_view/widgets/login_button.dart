import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget loginButton(BuildContext context, Function loginAction, bool login) {
  return Bounceable(
    duration: const Duration(milliseconds: 300),
    onTap: () async {
      await loginAction(context);
    },
    child: containerComponent(
        context,
        Center(
            child: Text(
              login ? AppStrings.signIn.tr() : AppStrings.signUp.tr(),
              style:
              TextStyle(fontSize: AppSize.s20.sp, color: ColorManager.white),
              textAlign: TextAlign.center,
            )),
        height: 50.h,
        color: ColorManager.primary,
        borderRadius: AppSize.s5,
        borderColor: ColorManager.primary,
        borderWidth: 1.w),
  );
}