import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget leftPart(BuildContext context) {
  return Expanded(
      flex: 1,
      child: containerComponent(
          context,
          Center(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAssets.logo,
                  width: 100.w,
                  height: 100.h,
                ),
              ],
            ),
          ),
          height:
          MediaQuery.of(context).size.height - 50.h,
          color: ColorManager.secondary,
          borderRadius: AppSize.s5,
          borderColor: ColorManager.secondary,
          borderWidth: 1.5.w));
}