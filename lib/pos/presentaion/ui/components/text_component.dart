import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/constant/padding_margin_values_manager.dart';

import '../../../shared/style/colors_manager.dart';

Widget textS12Component(BuildContext context,String text,
    {double? fontSize}) {

  return Text(
  text,style: TextStyle(fontSize: AppSize.s12.sp),
  );
}

Widget textS14Component(BuildContext context,String text,
    {double? fontSize}) {

  return Text(
    text,style: TextStyle(fontSize: AppSize.s14.sp),
  );
}

Widget textS14PrimaryComponent(BuildContext context,String text,
    {double? fontSize,Color? color}) {

  return Text(
    text,style: TextStyle(fontSize: AppSize.s14.sp,color: ColorManager.primary),overflow: TextOverflow.ellipsis
  );
}

Widget textS14WhiteComponent(BuildContext context,String text,
    {double? fontSize,Color? color}) {

  return Text(
    text,style: TextStyle(fontSize: AppSize.s14.sp,color: ColorManager.white),
  );
}