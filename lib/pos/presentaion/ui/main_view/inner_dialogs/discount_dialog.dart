import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../../shared/utils/utils.dart';
import '../../components/close_button.dart';
import '../../components/container_component.dart';
import '../../components/text_component.dart';

class DiscountDialog extends StatefulWidget {

  Function getDiscount;
  Function getDiscountType;

  static void show(BuildContext context, Function getDiscount, Function getDiscountType) =>
     isApple() ? showCupertinoDialog<void>(context: context,useRootNavigator: false,
         barrierDismissible: false, builder: (_) => DiscountDialog(
       getDiscount: getDiscount,
       getDiscountType: getDiscountType,
     )).then((_) => FocusScope.of(context).requestFocus(FocusNode())) : showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => DiscountDialog(
      getDiscount: getDiscount,
      getDiscountType: getDiscountType,
    ),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  DiscountDialog({required this.getDiscount, required this.getDiscountType,super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  TextEditingController numberEditingController = TextEditingController();

  var selectedDiscountType;
  double? deviceWidth;

  @override
  void dispose() {
    numberEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = getDeviceWidth(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return Center(
      child: SizedBox(
        width: deviceWidth! <= 600 ? 350.w : 200.w,
        height: deviceWidth! <= 600 ? 180.h : 200.h,
        child: Container(
          decoration: BoxDecoration(
              color: ColorManager.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(AppSize.s5),
              boxShadow: [BoxShadow(color: ColorManager.badge)]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 150.w,
              height: 170.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(AppStrings.discount2.tr(),
                          style: TextStyle(
                              fontSize: AppSize.s20.sp,
                              color: ColorManager.primary,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: AppConstants.heightBetweenElements,
                  ),
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(AppStrings.editDiscount.tr(),
                          style: TextStyle(
                              fontSize: AppSize.s18.sp, color: ColorManager.primary))),
                  SizedBox(
                    height: AppConstants.smallDistance,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 70.w,
                          child:
                          containerComponent(
                              context,
                              DropdownButton(
                                borderRadius: BorderRadius.circular(AppSize.s5),
                                itemHeight: 50.h,
                                hint: Text(
                                  AppStrings.fixed.tr(),
                                  style: TextStyle(
                                      fontSize: AppSize.s14.sp,
                                      color: ColorManager.primary),
                                ),
                                underline: Container(),
                                items: <String>[AppStrings.fixed.tr(), AppStrings.percent.tr()]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: AppSize.s14.sp),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (selectedType) {
                                  setState(() {
                                    selectedDiscountType = selectedType;
                                  });
                                },
                                value: selectedDiscountType,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: ColorManager.primary,
                                  size: AppSize.s14.sp,
                                ),
                                style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: AppSize.s18.sp),
                              ),
                              width: 10.w,
                              height: 45.h,
                              padding: const EdgeInsets.fromLTRB(AppPadding.p5, AppPadding.p2, AppPadding.p5, AppPadding.p2),
                              borderRadius: AppSize.s5,
                              borderColor: ColorManager.primary,
                              borderWidth: deviceWidth! <= 600 ? 1.5.w : 0.6.w
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppConstants.smallDistance,
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 50.w,
                          child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              controller: numberEditingController,
                              decoration: InputDecoration(
                                  hintText: '0',
                                  labelText: AppStrings.numberField.tr(),
                                  border: InputBorder.none)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: deviceWidth! <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      closeButton(context),
                      Bounceable(
                        duration: Duration(milliseconds: AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(
                              Duration(milliseconds: AppConstants.durationOfBounceable));
                          bool? fixed;
                          if (selectedDiscountType == AppStrings.fixed.tr()) {
                            fixed = true;
                          } else {
                            fixed = false;
                          }
                          widget.getDiscount(double.parse(numberEditingController.text), fixed);
                          widget.getDiscountType(selectedDiscountType);
                          DiscountDialog.hide(context);
                        },
                        child:
                        containerComponent(
                            context,
                            Center(
                                child: textS14WhiteComponent(context,
                                  AppStrings.update.tr(),
                                )),
                            height: deviceWidth! <= 600 ? 40.h : 30.h,
                            width: deviceWidth! <= 600 ? 100.w : 50.w,
                            color: ColorManager.primary,
                            borderRadius: AppSize.s5,
                            borderColor: ColorManager.primary,
                            borderWidth: 0.6.w
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
