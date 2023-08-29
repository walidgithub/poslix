import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/brand.dart';

import '../../../../domain/response/brands_model.dart';

Widget brandButtons(BuildContext context, List<BrandsResponse> listOfBrands, Function isSelected, double deviceWidth) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 40.h,
          child: ListView.builder(
            shrinkWrap: true,
            physics:
            const AlwaysScrollableScrollPhysics(),
            scrollDirection:
            Axis.horizontal,
            itemCount:
            listOfBrands.length,
            itemBuilder:
                (BuildContext context,
                int index) {
              return BrandButton(
                id: listOfBrands[index]
                    .id,
                brandName:
                listOfBrands[index]
                    .name,
                selected:
                listOfBrands[index]
                    .selected!,
                isSelected: (int itemId) {
                  isSelected(itemId);
                },
                deviceWidth: deviceWidth,
              );
            },
          ),
        ),
      ),
    ],
  );
}