import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';

import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';

class CategoryButton extends StatefulWidget {
  final int id;
  final String categoryName;
  final bool selected;
  final Function isSelected;
  final double deviceWidth;
  const CategoryButton({required this.id, required this.categoryName, required this.selected, required this.isSelected, required this.deviceWidth, super.key});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Bounceable(
          onTap: () {
            widget.isSelected(widget.id);
          },
          child: Container(
            height: 30.h,
            width: widget.deviceWidth <= 800 ? 90.w :50.w,
            decoration: BoxDecoration(
                color: widget.selected ? ColorManager.black : ColorManager.white,
                border: Border.all(
                    color: ColorManager.black,
                    width: 0.6.w),
                borderRadius: BorderRadius.circular(AppSize.s5)),
            child: Center(child: Text(widget.categoryName,style: TextStyle(color: widget.selected ? ColorManager.white : ColorManager.black,fontSize: AppSize.s14.sp),)),
          ),
        ),
        SizedBox(
          width: AppConstants.smallDistance,
        )
      ],
    );
  }
}
