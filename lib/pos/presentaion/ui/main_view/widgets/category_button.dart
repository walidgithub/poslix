import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/category.dart';

import '../../../../domain/response/categories_model.dart';

Widget categoryButtons(BuildContext context, List<CategoriesResponse> listOfCategories, Function isSelected, double deviceWidth) {
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
            listOfCategories.length,
            itemBuilder:
                (BuildContext context,
                int index) {
              return CategoryButton(
                id: listOfCategories[
                index]
                    .id,
                categoryName:
                listOfCategories[
                index]
                    .name,
                selected:
                listOfCategories[
                index]
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