import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';

import '../../../../domain/entities/tmp_order_model.dart';
import '../../../../domain/response/pricing_group_model.dart';
import '../../../../domain/response/pricing_group_variants_model.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../di/di.dart';
import '../../components/close_button.dart';
import '../../components/container_component.dart';
import '../../components/text_component.dart';

class ItemOptionsDialog extends StatefulWidget {
  int itemIndex;
  String currencyCode;
  String selectedCustomerTel;
  int selectedPriceGroupId;
  var selectedListName;
  String selectedCustomer;
  List itemOptions;
  double? discount;
  double deviceWidth;
  Function done;
  List<PricingGroupResponse> listOfPricingGroups;

  static void show(
          BuildContext context,
          String currencyCode,
          int itemIndex,
          List itemOptions,
          var selectedListName,
          String selectedCustomerTel,
          String selectedCustomer,
          int selectedPriceGroupId,
          double discount,
          double deviceWidth,
          Function done,
          List<PricingGroupResponse> listOfPricingGroups,
      ) =>
     isApple() ? showCupertinoDialog<void>(context: context, useRootNavigator: false,
         barrierDismissible: false, builder: (_) => ItemOptionsDialog(
         currencyCode: currencyCode,
         itemIndex: itemIndex,
         itemOptions: itemOptions,
         selectedCustomerTel: selectedCustomerTel,
         selectedListName: selectedListName,
         selectedCustomer: selectedCustomer,
         selectedPriceGroupId: selectedPriceGroupId,
         discount: discount,
           deviceWidth: deviceWidth,
           done: done,
           listOfPricingGroups: listOfPricingGroups,
         )).then((_) => FocusScope.of(context).requestFocus(FocusNode())) : showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => ItemOptionsDialog(
            currencyCode: currencyCode,
            itemIndex: itemIndex,
            itemOptions: itemOptions,
            selectedCustomerTel: selectedCustomerTel,
            selectedListName: selectedListName,
            selectedCustomer: selectedCustomer,
            selectedPriceGroupId: selectedPriceGroupId,
            discount: discount,
          deviceWidth: deviceWidth,
          done: done,
          listOfPricingGroups: listOfPricingGroups,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  ItemOptionsDialog(
      {required this.currencyCode,
      required this.itemIndex,
      required this.itemOptions,
      required this.selectedListName,
      required this.selectedCustomerTel,
      required this.selectedCustomer,
      required this.selectedPriceGroupId,
      required this.discount,
      required this.deviceWidth,
      required this.done,
      required this.listOfPricingGroups,
      super.key});

  @override
  State<ItemOptionsDialog> createState() => _ItemOptionsDialogState();
}

class _ItemOptionsDialogState extends State<ItemOptionsDialog> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  DateTime today = DateTime.now();

  int decimalPlaces = 2;
  var pricingGroupProductsResponse;
  List<PricingGroupVariantsResponse> pricingGroupVariantsResponse = [];

  @override
  void initState() {
    getDecimalPlaces();
    if (widget.selectedPriceGroupId != 0) {
       pricingGroupProductsResponse =
       widget.listOfPricingGroups.firstWhere((element) => element.id == widget.selectedPriceGroupId).products;
       for (var p in pricingGroupProductsResponse) {
         if (p.id == widget.selectedListName[widget.itemIndex].id) {
           pricingGroupVariantsResponse = p.variants;
         }
       }
    }
    super.initState();
  }

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getLocationId(PREFS_KEY_DECIMAL_PLACES)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    height: 350.h,
                    width: widget.deviceWidth <= 600 ? 350.w : 170.w,
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(AppSize.s5),
                        boxShadow: [BoxShadow(color: ColorManager.badge)]),
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              AppStrings.chooseOne.tr(),
                              style: TextStyle(
                                  fontSize: AppSize.s20.sp,
                                  color: ColorManager.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: AppConstants.smallDistance,
                          ),

                          // -----------------------------------------------------------

                          // item options,
                          itemOptions(context),
                          // -----------------------------------------------------------

                          SizedBox(
                            height: AppConstants.smallerDistance,
                          ),
                          const Divider(
                            thickness: AppSize.s1,
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                closeButton(context),
                              ],
                            ),
                          )
                        ],
                      ),
                    )))));
  }

  Widget itemOptions(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      child: GridView.count(
          crossAxisCount: widget.deviceWidth <= 600 ? 2 : 3,
          crossAxisSpacing: AppSize.s12,
          mainAxisSpacing: AppSize.s12,
          childAspectRatio: widget.deviceWidth <= 600 ? 1 / 1.25 : 10 / 12,
          physics: const ScrollPhysics(),
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(widget.itemOptions.length, (index) {
            return Bounceable(
              duration:
                  Duration(milliseconds: AppConstants.durationOfBounceable),
              onTap: () async {
                await selectOption(context, index);
              },
              child: containerComponent(
                  context,
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.itemOptions[index].name,
                              style: TextStyle(
                                  fontSize: AppSize.s16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallerDistance,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textS14PrimaryComponent(
                              context,
                              widget.selectedPriceGroupId != 0 ? pricingGroupVariantsResponse[index].price.toString() :
                              widget.itemOptions[index].price.toString(),
                            ),
                            SizedBox(
                              width: AppConstants.smallerDistance,
                            ),
                            Text(widget.currencyCode,
                                style: TextStyle(
                                    fontSize: AppSize.s12.sp,
                                    color: ColorManager.grayText)),
                          ],
                        ),
                        SizedBox(
                          height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallerDistance,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textS14PrimaryComponent(
                              context,
                              widget.itemOptions[index].stock.toString(),
                            ),
                            SizedBox(
                              width: AppConstants.smallerDistance,
                            ),
                            textS14PrimaryComponent(
                                context, AppStrings.remaining.tr()),
                          ],
                        ),
                        SizedBox(
                          height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallerDistance,
                        ),
                        containerComponent(
                            context,
                            Center(
                                child: Icon(
                              Icons.ads_click,
                              size: AppSize.s15.sp,
                              color: ColorManager.white,
                            )),
                            height: widget.deviceWidth <= 600 ? 30.h : 30.h,
                            width: widget.deviceWidth <= 600 ? 30.w : 10.w,
                            padding: const EdgeInsets.all(AppPadding.p08),
                            margin:
                                const EdgeInsets.only(bottom: AppPadding.p8),
                            color: ColorManager.primary,
                            borderRadius: AppSize.s5,
                            borderColor: ColorManager.primary,
                            borderWidth: 1.w),
                      ],
                    ),
                  ),
                  height: 50.h,
                  padding: const EdgeInsets.all(AppPadding.p10),
                  color: ColorManager.secondary,
                  borderColor: ColorManager.secondary,
                  borderWidth: 0.1.w,
                  borderRadius: AppSize.s5),
            );
          })),
    ));
  }

  Future<void> selectOption(BuildContext context, int index) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));
    if (widget.selectedListName[widget.itemIndex].stock == 0) {
      noCredit(context);
      return;
    }

    int qty = widget.selectedListName[widget.itemIndex].variations[index].stock;

    if (qty == 0) {
      noCredit(context);
      return;
    }

    if (listOfTmpOrder.isNotEmpty) {
      int listOfTmpOrderIndex = listOfTmpOrder.indexWhere((element) =>
          element.productId == widget.selectedListName[widget.itemIndex].id);

      if (listOfTmpOrderIndex >= 0) {
        if (int.parse(
                listOfTmpOrder[listOfTmpOrderIndex].itemQuantity.toString()) >=
            widget.selectedListName[widget.itemIndex].variations[index].stock) {
          noCredit(context);
          return;
        }
      }
    }

    setState(() {
      for (var entry in listOfTmpOrder) {
        if (widget.selectedListName[widget.itemIndex].name + " " + widget.selectedListName[widget.itemIndex].variations[index].name == entry.itemName &&
            widget.itemOptions[index].name == entry.itemOption) {
          int? itemCount = entry.itemQuantity;
          itemCount = itemCount! + 1;
          entry.itemQuantity = itemCount;
          entry.itemAmount =
              (itemCount * double.parse(entry.itemPrice.toString())).toString();
          return;
        }
      }

      String sellPrice = widget.itemOptions[index].price;

      if (widget.selectedPriceGroupId != 0) {
        var pricingGroupProductsResponse =
            widget.listOfPricingGroups.firstWhere((element) => element.id == widget.selectedPriceGroupId).products;
        for (var p in pricingGroupProductsResponse) {
          if (p.id == widget.selectedListName[widget.itemIndex].id) {
            sellPrice = '${p.price}.000000000000000000000';
          }
        }
      }

      listOfTmpOrder.add(TmpOrderModel(
        productId: widget.selectedListName[widget.itemIndex].id,
        variationId:
            widget.selectedListName[widget.itemIndex].variations.isNotEmpty
                ? widget.selectedListName[widget.itemIndex].variations[index].id
                : 0,
        id: widget.selectedListName[widget.itemIndex].id,
        itemName: widget.selectedListName[widget.itemIndex].name + " " + widget.selectedListName[widget.itemIndex].variations[index].name,
        itemQuantity: 1,
        itemAmount:
            '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}',
        itemPrice: widget.itemOptions[index].price,
        customer: widget.selectedCustomer,
        category:
            widget.selectedListName[widget.itemIndex].categoryId.toString(),
        orderDiscount: widget.discount,
        brand: widget.selectedListName[widget.itemIndex].brandId.toString(),
        customerTel: widget.selectedCustomerTel,
        pricingGroupId: widget.selectedPriceGroupId,
        date: today.toString().split(" ")[0],
        itemOption: widget.itemOptions.isNotEmpty
            ? widget.selectedListName[widget.itemIndex].variations[index].name
            : '',
          productType: widget.selectedListName[widget.itemIndex].type
      ));
    });

    widget.done('done');

    ItemOptionsDialog.hide(context);
  }
}
