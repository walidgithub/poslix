import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/text_component.dart';

import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/style/colors_manager.dart';
import 'container_component.dart';

Widget closeButton(BuildContext context) {
  return Bounceable(
    duration: Duration(
        milliseconds: AppConstants
            .durationOfBounceable),
    onTap: () async {
      await Future.delayed(Duration(
          milliseconds: AppConstants
              .durationOfBounceable));
      Navigator.of(context).pop();
    },
    child:
    containerComponent(
        context,
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceEvenly,
          children: [
            Center(
                child: textS14PrimaryComponent(context,
                  AppStrings.close.tr(),
                )),
            Icon(
              Icons.close,
              size: AppSize.s20.sp,
              color: ColorManager.delete,
            )
          ],
        ),
        height: 30.h,
        width: 50.w,
        color: ColorManager.white,
        borderColor: ColorManager.primary,
        borderWidth: 0.6.w,
        borderRadius: AppSize.s5
    ),
  );
}