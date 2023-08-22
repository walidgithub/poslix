import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/response/products_model.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../components/container_component.dart';

Widget searchText(BuildContext context, TextEditingController searchEditingController, Function addToTmp, List<ProductsResponse> listOfAllProducts, List<String> searchList) {
  return Autocomplete<String>(
    optionsBuilder:
        (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty) {
        return const Iterable<String>.empty();
      } else {
        return searchList.where((word) => word
            .toLowerCase()
            .contains(textEditingValue.text
            .toLowerCase()));
      }
    },
    onSelected: (String selection) {
      int index = listOfAllProducts.indexWhere(
              (element) =>
          element.name == selection);

      addToTmp(index,context,true);
    },
    fieldViewBuilder: (context,
        textEditingController,
        focusNode,
        onFieldSubmitted) {
      searchEditingController =
          textEditingController;
      return TextField(
          autofocus: false,
          keyboardType: TextInputType.text,
          controller: searchEditingController,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: AppSize.s25.sp,
              ),
              hintText: AppStrings
                  .searchByProduct
                  .tr(),
              hintStyle: TextStyle(
                  fontSize: AppSize.s14,
                  color: ColorManager.primary),
              border: InputBorder.none));
    },
    optionsViewBuilder:
        (context, onSelected, options) => Align(
      alignment: Alignment.topLeft,
      child: Material(
        child:
        containerComponent(
            context,
            ListView(
              children: options
                  .map((e) => Padding(
                padding:
                const EdgeInsets.only(
                    top: AppPadding
                        .p15),
                child: ListTile(
                  onTap: () =>
                      onSelected(e),
                  title: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(e),
                      const Divider()
                    ],
                  ),
                ),
              ))
                  .toList(),
            ),
            width: 120.w,
            height: 200.h,
            color: ColorManager.white,
            borderColor: ColorManager.secondary,
            borderWidth: 0.5.w,
            borderRadius: AppSize.s5
        ),
      ),
    ),
  );
}