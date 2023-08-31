import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';
import '../../../../components/container_component.dart';
import '../../../../components/text_component.dart';

Widget addNewPaymentRow(BuildContext context, Function addPaymentRow, double deviceWidth) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Bounceable(
      duration: Duration(milliseconds: AppConstants.durationOfBounceable),
      onTap: () async {
        await Future.delayed(
            Duration(milliseconds: AppConstants.durationOfBounceable));
        addPaymentRow(context);
      },
      child: containerComponent(
          context,
          Center(
              child: textS14WhiteComponent(
                context,
                AppStrings.addPaymentRow.tr(),
              )),
          height: deviceWidth <= 600 ? 40.h : 30.h,
          width: deviceWidth <= 600 ? 150.w : 50.w,
          color: ColorManager.primary,
          borderColor: ColorManager.primary,
          borderWidth: 0.6.w,
          borderRadius: AppSize.s5),
    ),
  );
}