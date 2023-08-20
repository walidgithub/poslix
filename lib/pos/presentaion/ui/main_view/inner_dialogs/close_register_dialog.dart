import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/requests/close_register_model.dart';
import '../../../../domain/requests/close_register_report_model.dart';
import '../../../../shared/constant/assets_manager.dart';
import '../../../../shared/constant/constant_values_manager.dart';
import '../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../shared/constant/strings_manager.dart';
import '../../../../shared/preferences/app_pref.dart';
import '../../../../shared/style/colors_manager.dart';
import '../../../di/di.dart';
import '../../../router/app_router.dart';
import '../../components/close_button.dart';
import '../../components/container_component.dart';
import '../../components/text_component.dart';
import '../../popup_dialogs/custom_dialog.dart';
import '../main_view_cubit/main_view_cubit.dart';
import '../main_view_cubit/main_view_state.dart';

class CloseRegisterDialog extends StatefulWidget {
  int locationId;
  static void show(BuildContext context, int locationId) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => CloseRegisterDialog(
          locationId: locationId,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  CloseRegisterDialog(
      {required this.locationId, super.key});

  @override
  State<CloseRegisterDialog> createState() => _CloseRegisterDialogState();
}

class _CloseRegisterDialogState extends State<CloseRegisterDialog> {
  final TextEditingController _notesEditingController = TextEditingController();

  final AppPreferences _appPreferences = sl<AppPreferences>();

  int? cashInHand;

  double? total_cash;
  double? total_cheque;
  double? total_bank;
  double? total_cart;
  double? totalAmount;

  String currencyCode = '';

  @override
  void initState() {
    cashInHand = 0;
    total_cash = 0;
    total_cheque = 0;
    total_bank = 0;
    total_cart = 0;
    totalAmount = 0;
    super.initState();
  }

  @override
  void dispose() {
    _notesEditingController.dispose();
    super.dispose();
  }

  String calcTotal() {
    return (cashInHand! + total_cash! + total_cheque! + total_bank! + total_cart!).toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainViewCubit>()
        ..openCloseRegister(CloseRegisterReportRequest(today: true),
            widget.locationId)
        ..getCurrency(widget.locationId)
      ..getRegisterData(widget.locationId),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is MainNoInternetState) {
            CustomDialog.show(context,AppStrings.noInternet.tr(),const Icon(Icons.wifi),ColorManager.white,AppConstants.durationOfSnackBar,ColorManager.delete);
          }

          if (state is CloseRegisterSucceed) {
          } else if (state is CloseRegisterError) {
            CustomDialog.show(context,AppStrings.errorInCloseRegister.tr(),const Icon(Icons.close),ColorManager.white,AppConstants.durationOfSnackBar,ColorManager.delete);
          }

          if (state is OpenCloseRegisterSucceed) {
            cashInHand = MainViewCubit.get(context).cashInHand;
          } else if (state is OpenCloseRegisterError) {

          }

          if (state is LoadedRegisterData) {
            setState(() {
              total_cash = MainViewCubit.get(context).total_cash;
              total_cheque = MainViewCubit.get(context).total_cheque;
              total_bank = MainViewCubit.get(context).total_bank;
              total_cart = MainViewCubit.get(context).total_cart;
            });
          } else if (state is LoadingErrorRegisterData) {

          }

          if (state is LoadedCurrency) {
            currencyCode = state.currencyCode;
          } else if (state is LoadingErrorCurrency) {}
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: SingleChildScrollView(
                      child: Container(
                          width: 300.w,
                          height: 520.h,
                          decoration: BoxDecoration(
                              color: ColorManager.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(AppSize.s5),
                              boxShadow: [
                                BoxShadow(color: ColorManager.badge)
                              ]),
                          child: Padding(
                              padding: const EdgeInsets.all(AppPadding.p10),
                              child: Center(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        AppStrings.closeRegister.tr(),
                                        style: TextStyle(
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppSize.s18.sp),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          AppConstants.heightBetweenElements,
                                    ),

                                    Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      collections(ImageAssets.moneyBillWave, AppStrings.cashInHand.tr(), cashInHand.toString()),
                                      SizedBox(
                                        width: AppConstants.smallDistance,
                                      ),
                                      collections(ImageAssets.moneyBillTransfer, AppStrings.cartPayment.tr(), total_cart.toString()),
                                      SizedBox(
                                        width: AppConstants.smallDistance,
                                      ),
                                      collections(ImageAssets.building, AppStrings.bankPayment.tr(), total_bank.toString()),
                                      SizedBox(
                                        width: AppConstants.smallDistance,
                                      ),
                                      collections(ImageAssets.creditCard, AppStrings.cashPayment.tr(), total_cash.toString()),
                                      SizedBox(
                                        width: AppConstants.smallDistance,
                                      ),
                                      collections(ImageAssets.moneyCheck, AppStrings.chequePayment.tr(), total_cheque.toString()),
                                    ]
                                ),

                                    SizedBox(
                                      height: AppConstants.smallDistance,
                                    ),
                                    const Divider(
                                      thickness: AppSize.s1,
                                    ),
                                    SizedBox(
                                      height:
                                          AppConstants.heightBetweenElements,
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.all(AppPadding.p20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.monetization_on_outlined,
                                                size: AppSize.s18.sp,
                                                color: ColorManager.black,
                                              ),
                                              Text(
                                                AppStrings.totalAmount.tr(),
                                                style: TextStyle(
                                                    fontSize: AppSize.s18.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${calcTotal()} $currencyCode',
                                            style: TextStyle(
                                                fontSize: AppSize.s18.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          AppConstants.heightBetweenElements,
                                    ),
                                    TextField(
                                        autofocus: false,
                                        keyboardType: TextInputType.text,
                                        controller: _notesEditingController,
                                        decoration: InputDecoration(
                                            hintText:
                                                AppStrings.yourNoteHere.tr(),
                                            hintStyle: TextStyle(
                                                fontSize: AppSize.s14.sp,
                                                color: ColorManager.primary),
                                            border: InputBorder.none)),
                                    SizedBox(
                                      height:
                                          AppConstants.heightBetweenElements,
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          closeButton(context),
                                          SizedBox(
                                            width: AppConstants.smallDistance,
                                          ),
                                          Bounceable(
                                            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
                                            onTap: () async {
                                              await Future.delayed(
                                                  Duration(milliseconds: AppConstants.durationOfBounceable));
                                              CloseRegisterRequest
                                                  closeRegisterRequest =
                                                  CloseRegisterRequest(
                                                      note:
                                                          _notesEditingController
                                                              .text,
                                                      handCash: cashInHand!);
                                              await MainViewCubit.get(context)
                                                  .closeRegister(
                                                      closeRegisterRequest,
                                                      widget.locationId);

                                              _appPreferences
                                                  .removeDecimalPlaces(
                                                      PREFS_KEY_DECIMAL_PLACES);
                                              _appPreferences.removeLocationId(
                                                  PREFS_KEY_LOCATION_ID);
                                              _appPreferences.removeTaxValue(
                                                  PREFS_KEY_TAX_VALUE);
                                              _appPreferences
                                                  .userClosedRegister();

                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      Routes.registerPosRoute);
                                            },
                                            child:
                                            containerComponent(
                                                context,
                                                Center(
                                                    child: Text(
                                                      AppStrings.closeRegister.tr(),
                                                      style: TextStyle(
                                                          color: ColorManager.white,
                                                          fontSize: AppSize.s14.sp),
                                                    )),
                                                height: 30.h,
                                                width: 50.w,
                                                color: ColorManager.primary,
                                                borderColor: ColorManager.primary,
                                                borderWidth: 0.6.w,
                                                borderRadius: AppSize.s5
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))))));
        },
      ),
    );
  }

  Widget collections(String image,String address,String value) {
    return
      containerComponent(
          context,
          Column(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                image,
                width: AppSize.s60,
                color: ColorManager.darkGray,
              ),
              SizedBox(
                height: AppConstants
                    .smallDistance,
              ),
              Text(
                address,
                style: TextStyle(
                    fontSize: AppSize.s14.sp),
              ),
              SizedBox(
                height: AppConstants
                    .smallDistance,
              ),
              Text(
                  '$value $currencyCode',
                  style: TextStyle(
                      fontSize: AppSize.s18.sp,
                      fontWeight:
                      FontWeight.bold,
                      color: ColorManager
                          .primary))
            ],
          ),
          width: 50.w,
          height: 200.h,
          padding: const EdgeInsets.all(
              AppPadding.p10),
          color: ColorManager.secondary,
          borderColor: ColorManager.secondary,
          borderWidth: 0.1.w,
          borderRadius: AppSize.s5
    );
  }
}
