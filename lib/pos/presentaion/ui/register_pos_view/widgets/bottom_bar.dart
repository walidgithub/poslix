import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';

import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';

class BottomSheetBar extends StatefulWidget {
  String currencyCode;
  double totalAmount;
  BottomSheetBar({Key? key, required this.currencyCode, required this.totalAmount}) : super(key: key);

  @override
  State<BottomSheetBar> createState() => _BottomSheetBarState();
}

class _BottomSheetBarState extends State<BottomSheetBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorManager.primary,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s10),
                      topRight: Radius.circular(AppSize.s10))
              ),
      child: Padding(
        padding: const EdgeInsets.only(left: AppPadding.p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.add_shopping_cart_sharp,
              color: ColorManager.white,
              size: AppSize.s25.sp,
            ),
            SizedBox(
              width: AppConstants.widthBetweenElements,
            ),
            Text(AppStrings.total.tr(),style: TextStyle(color: ColorManager.white,fontSize: AppSize.s18.sp,fontWeight: FontWeight.bold),),
            SizedBox(
              width: AppConstants.widthBetweenElements,
            ),
            Text(widget.totalAmount.toString(),style: TextStyle(color: ColorManager.white,fontSize: AppSize.s18.sp,fontWeight: FontWeight.bold),),
            SizedBox(
              width: AppConstants.smallDistance,
            ),
            Text(widget.currencyCode.toString(),style: TextStyle(color: ColorManager.white,fontSize: AppSize.s18.sp,fontWeight: FontWeight.bold),),
          ],
        ),
      )
          );
  }
}

