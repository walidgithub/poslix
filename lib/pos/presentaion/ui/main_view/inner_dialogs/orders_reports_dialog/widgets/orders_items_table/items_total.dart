import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../domain/response/sales_report_data_model.dart';
import '../../../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../../../shared/constant/strings_manager.dart';
import '../../../../../../../shared/style/colors_manager.dart';

Widget itemsTotal(BuildContext context, bool searching, int orderId, List<SalesReportDataModel> listOfOrderHead, List<SalesReportDataModel> listOfOrderHeadForSearch, double totalAmount) {
  if (searching) {
    int orderIndex = listOfOrderHeadForSearch
        .indexWhere((element) => element.id == orderId);
    // totalAmount = listOfOrderHeadForSearch[orderIndex].subTotal;
  } else {
    int orderIndex =
    listOfOrderHead.indexWhere((element) => element.id == orderId);
    // totalAmount = listOfOrderHead[orderIndex].subTotal;
  }
  return Align(
    alignment: AlignmentDirectional.center,
    child: SizedBox(
      height: 50.h,
      child: Padding(
        padding: const EdgeInsets.only(right: AppPadding.p20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''),
            Text(
              AppStrings.total.tr(),
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: ColorManager.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: AppConstants.smallDistance,
            ),
            Text(totalAmount.toString(),
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: ColorManager.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}