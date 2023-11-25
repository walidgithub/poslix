import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/close_button.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';

import '../../../../domain/entities/search_list_model.dart';
import '../../../../domain/response/products_model.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../../shared/utils/utils.dart';
import '../../components/container_component.dart';

double? deviceWidth;
Widget searchText(
    BuildContext context,
    TextEditingController searchEditingController,
    Function addToTmp,
    List<ProductsResponse> listOfAllProducts,
    List<SearchListModel> searchList) {
  deviceWidth = getDeviceWidth(context);
  return Autocomplete<SearchListModel>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text.isEmpty || textEditingValue == null) {
        return const Iterable<SearchListModel>.empty();
      } else {
        var selectedName = searchList.where((word) =>
            word.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
        var selectedSku = searchList.where((word) =>
            word.sku.toLowerCase().contains(textEditingValue.text.toLowerCase()));

        var selected;
        if (selectedName != null && selectedName.isNotEmpty) {
          selected = selectedName.where((word) =>
              word.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
        } else if (selectedSku != null && selectedSku.isNotEmpty) {
          selected = selectedSku.where((word) =>
              word.sku.toLowerCase().contains(textEditingValue.text.toLowerCase()));
        } else {
          return const Iterable<SearchListModel>.empty();
        }
        return selected;
      }
    },
    onSelected: (SearchListModel selection) {
      int index =
          listOfAllProducts.indexWhere((element) => element.name == selection.name);

      addToTmp(index, context, true);
    },
    fieldViewBuilder:
        (context, textEditingController, focusNode, onFieldSubmitted) {
      searchEditingController = textEditingController;
      return TextField(
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          autofocus: false,
          keyboardType: TextInputType.text,
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: AppSize.s25.sp,
              ),
              hintText: AppStrings.searchByProduct.tr(),
              hintStyle:
                  TextStyle(fontSize: AppSize.s14, color: ColorManager.primary),
              border: InputBorder.none));
    },
    optionsViewBuilder: (context, onSelected, options) => Align(
      alignment: Alignment.topLeft,
      child: Material(
        child: containerComponent(
            context,
            ListView(
              children: options
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p15),
                        child: ListTile(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            onSelected(e);
                            searchEditingController.text = '${e.name} | Sku: ${e.sku}';
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Row(children: [
                              Text(e.name),
                              SizedBox(
                                width: AppConstants.smallDistance,
                              ),
                              const Text('| Sku: '),
                              SizedBox(
                                width: AppConstants.smallDistance,
                              ),
                              Text(e.sku)
                            ],), const Divider()],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            width: deviceWidth! <= 600 ? 320.w : 120.w,
            height: 200.h,
            color: ColorManager.white,
            borderColor: ColorManager.secondary,
            borderWidth: 0.5.w,
            borderRadius: AppSize.s5),
      ),
    ),
  );
}
