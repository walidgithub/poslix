import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../shared/style/colors_manager.dart';

Widget autoComplete(BuildContext context, TextEditingController _searchEditingController, searchInList) {
  return Expanded(
      flex: 3,
      child: TextField(
          autofocus: false,
          keyboardType: TextInputType.text,
          controller: _searchEditingController,
          onChanged: searchInList,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: AppSize.s25.sp,
              ),
              hintText: AppStrings.search.tr(),
              hintStyle: TextStyle(
                  fontSize: AppSize.s14, color: ColorManager.primary),
              border: InputBorder.none)));
}