import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/close_button.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';

import '../../../../../domain/entities/hold_order_items_model.dart';
import '../../../../../domain/entities/hold_order_names_model.dart';
import '../../../../../domain/entities/tmp_order_model.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/core/local_db/dbHelper.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../di/di.dart';
import '../../../components/container_component.dart';
import '../../../components/text_component.dart';
import '../../../popup_dialogs/custom_dialog.dart';
import 'local_main_view_cubit/local_main_view_cubit.dart';
import 'local_main_view_cubit/local_main_view_state.dart';

Future holdOrdersDialog(
    BuildContext context, List<TmpOrderModel> listOfTmpOrders, double discount, String customerTel, String customerName, Function done) {
  TextEditingController holdNameEditingController = TextEditingController();
  DateTime today = DateTime.now();

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s5)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 150.w,
                height: 120.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(AppStrings.holdOrders.tr(),
                            style: TextStyle(
                                fontSize: AppSize.s20.sp,
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          controller: holdNameEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.enterName.tr(),
                              hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                              labelText: AppStrings.enterName.tr(),
                              labelStyle: TextStyle(
                                  fontSize: AppSize.s15,
                                  color: ColorManager.primary),
                              border: InputBorder.none)),
                    ),
                    const Divider(
                      thickness: AppSize.s1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        closeButton(context),
                        BlocProvider(
                          create: (context) => sl<MainViewLocalCubit>(),
                          child: BlocConsumer<MainViewLocalCubit,
                              MainViewLocalState>(
                            listener: (context, state) {
                              if (state is InsertHoldCards) {
                                CustomDialog.show(context,AppStrings.orderHeldSuccessfully.tr(),const Icon(Icons.check),ColorManager.white,AppConstants.durationOfSnackBar,ColorManager.success);
                              } else if (state is InsertHoldCardsItems) {

                              } else if (state is InsertErrorHoldCards) {

                              } else if (state is InsertErrorHoldCardsItems) {

                              }
                            },
                            builder: (context, state) {
                              return Bounceable(
                                duration: Duration(milliseconds: AppConstants.durationOfBounceable),
                                onTap: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: AppConstants.durationOfBounceable));
                                  HoldOrderNamesModel holdOrderNamesModel =
                                      HoldOrderNamesModel(
                                          customerTel: customerTel,
                                          customer: customerName,
                                          discount: discount.toString(),
                                          date: today.toString(),
                                          holdText:
                                              holdNameEditingController.text);

                                  await MainViewLocalCubit.get(context)
                                      .insertHoldCard(holdOrderNamesModel);

                                  for (var element in listOfTmpOrder) {
                                    HoldOrderItemsModel holdOrderItemsModel =
                                        HoldOrderItemsModel(
                                            holdOrderId:
                                                DbHelper.insertedNewHoldId,
                                            date: today.toString(),
                                            category: element.category,
                                            brand: element.brand,
                                            customer: customerName,
                                            customerTel: customerTel,
                                            itemAmount: element.itemAmount,
                                            itemName: element.itemName,
                                            itemPrice: element.itemPrice,
                                            itemQuantity: element.itemQuantity,
                                            discount:
                                                discount.toString(),
                                            holdText:
                                                holdNameEditingController.text,
                                            itemOption: element.itemOption,
                                            variationId: element.variationId,
                                            productId: element.productId);
                                    await MainViewLocalCubit.get(context)
                                        .insertHoldCardItems(
                                            holdOrderItemsModel);
                                  }

                                  await Future.delayed(
                                      Duration(milliseconds: AppConstants.durationOfSnackBar));

                                  done('done');

                                  Navigator.of(context).pop();
                                },
                                child:
                                containerComponent(
                                    context,
                                    Center(
                                        child: textS14WhiteComponent(context,
                                          AppStrings.save.tr(),
                                        )),
                                    height: 30.h,
                                    width: 50.w,
                                    color: ColorManager.primary,
                                    borderRadius: AppSize.s5,
                                    borderColor: ColorManager.primary,
                                    borderWidth: 0.6.w
                                )
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
