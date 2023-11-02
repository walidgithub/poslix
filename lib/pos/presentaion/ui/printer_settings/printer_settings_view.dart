import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/close_button.dart';
import 'package:poslix_app/pos/presentaion/ui/printer_settings/widgets/printer_ip.dart';
import 'package:poslix_app/pos/presentaion/ui/printer_settings/widgets/printer_name.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/preferences/app_pref.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../../shared/utils/utils.dart';
import '../../di/di.dart';
import '../components/container_component.dart';
import '../main_view/main_view_cubit/main_view_cubit.dart';
import '../main_view/main_view_cubit/main_view_state.dart';

class PrinterSettingsDialog extends StatefulWidget {
  double deviceWidth;
  static void show(BuildContext context, double deviceWidth) =>
      isApple()
          ? showCupertinoDialog<void>(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (_) {
            return PrinterSettingsDialog(
              deviceWidth: deviceWidth,
            );
          }).then((_) => FocusScope.of(context).requestFocus(FocusNode()))
          : showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => PrinterSettingsDialog(
          deviceWidth: deviceWidth,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  PrinterSettingsDialog(
      {required this.deviceWidth, super.key});

  @override
  State<PrinterSettingsDialog> createState() => _PrinterSettingsDialogState();
}

class _PrinterSettingsDialogState extends State<PrinterSettingsDialog> {
  TextEditingController printerNameEditingController = TextEditingController();
  TextEditingController printerIPEditingController = TextEditingController();

  List<String> listOfPrinters = ['hp', 'canon'];
  List<String> listOfPrinterIPs = ['170.121.1.81', '170.121.1.82'];
  List<String> listOfPrinterType = ['receipt', 'A4'];
  List<String> listOfConnectionMethods = ['Wifi', 'USB', 'Bluetooth'];
  List<String> listOfStatus = ['On', 'Off'];

  var _selectedPrinter;
  var _selectedPrinterIP;
  var _selectedPrinterType;
  var _selectedConnectionMethod;
  var _selectedStatus;

  bool keyPadOn = false;

  @override
  void dispose() {
    printerNameEditingController.dispose();
    printerIPEditingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainViewCubit>(),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: SingleChildScrollView(
                      child: Container(
                          width: widget.deviceWidth <= 600 ? 350.w : 450.w,
                          height: 530.h,
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
                                        AppStrings.printerSettings.tr(),
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
                                    printerData(context),
                                    buttons(context)
                                  ],
                                ),
                              ))))));
        },
      ),
    );
  }

  // right part --------------------------------------------------------------
  Widget printerData(BuildContext context) {
    return Expanded(
        flex: 1,
        child: containerComponent(
            context,
            Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newPrinter(context),
                    printerNameValue(
                        context, printerNameEditingController, widget.deviceWidth!),
                    printerIPValue(
                        context, printerIPEditingController, widget.deviceWidth!),
                    choosePrintType(context),
                    chooseConnectionMethod(context),
                    choosePrinterStatus(context),
                    const Divider(
                      thickness: AppSize.s1,
                    ),
                    keyPadOn
                        ? Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).viewInsets.bottom +
                                300))
                        : SizedBox(
                      height: AppConstants.heightBetweenElements,
                    )
                  ],
                ),
              ),
            ),
            height: MediaQuery.of(context).size.height - 40.h,
            padding: const EdgeInsets.all(AppPadding.p15),
            color: ColorManager.white,
            borderRadius: AppSize.s5,
            borderColor: ColorManager.white,
            borderWidth: 1.w));
  }

  Widget choosePrinter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: 280.w,
              padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                border: Border.all(
                  color: ColorManager.primary,
                ),
                color: ColorManager.white,
              ),
              elevation: 2,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                color: ColorManager.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            underline: Container(),
            items: listOfPrinters.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedPrinter) {
              setState(() {
                _selectedPrinter = selectedPrinter;
              });
            },
            value: _selectedPrinter,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePrinterName.tr(),
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: AppSize.s15.sp),
                ),
                SizedBox(
                  width: AppConstants.smallDistance,
                )
              ],
            ),
            style: TextStyle(
                color: ColorManager.primary, fontSize: AppSize.s20.sp),
          ),
        ],
      ),
    );
  }

  Widget choosePrinterIP(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: 280.w,
              padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                border: Border.all(
                  color: ColorManager.primary,
                ),
                color: ColorManager.white,
              ),
              elevation: 2,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                color: ColorManager.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            underline: Container(),
            items: listOfPrinterIPs.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedPrinterIP) {
              setState(() {
                _selectedPrinterIP = selectedPrinterIP;
              });
            },
            value: _selectedPrinterIP,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePrinterIP.tr(),
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: AppSize.s15.sp),
                ),
                SizedBox(
                  width: AppConstants.smallDistance,
                )
              ],
            ),
            style: TextStyle(
                color: ColorManager.primary, fontSize: AppSize.s20.sp),
          ),
        ],
      ),
    );
  }

  Widget choosePrintType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: 280.w,
              padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                border: Border.all(
                  color: ColorManager.primary,
                ),
                color: ColorManager.white,
              ),
              elevation: 2,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                color: ColorManager.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            underline: Container(),
            items: listOfPrinterType.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedPrinterType) {
              setState(() {
                _selectedPrinterType = selectedPrinterType;
              });
            },
            value: _selectedPrinterType,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePrintType.tr(),
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: AppSize.s15.sp),
                ),
                SizedBox(
                  width: AppConstants.smallDistance,
                )
              ],
            ),
            style: TextStyle(
                color: ColorManager.primary, fontSize: AppSize.s20.sp),
          ),
        ],
      ),
    );
  }

  Widget chooseConnectionMethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: 280.w,
              padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                border: Border.all(
                  color: ColorManager.primary,
                ),
                color: ColorManager.white,
              ),
              elevation: 2,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                color: ColorManager.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            underline: Container(),
            items: listOfConnectionMethods.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedConnectionMethod) {
              setState(() {
                _selectedConnectionMethod = selectedConnectionMethod;
              });
            },
            value: _selectedConnectionMethod,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.chooseConnectionMethod.tr(),
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: AppSize.s15.sp),
                ),
                SizedBox(
                  width: AppConstants.smallDistance,
                )
              ],
            ),

            style: TextStyle(
                color: ColorManager.primary, fontSize: AppSize.s20.sp),
          ),
        ],
      ),
    );
  }

  Widget choosePrinterStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: 280.w,
              padding: const EdgeInsets.only(left: AppPadding.p14, right: AppPadding.p14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                border: Border.all(
                  color: ColorManager.primary,
                ),
                color: ColorManager.white,
              ),
              elevation: 2,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400.h,
              width: 270.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s5),
                color: ColorManager.white,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),

            underline: Container(),
            items: listOfStatus.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedStatus) {
              setState(() {
                _selectedStatus= selectedStatus;
              });
            },
            value: _selectedStatus,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePrinterStatus.tr(),
                  style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: AppSize.s15.sp),
                ),
                SizedBox(
                  width: AppConstants.smallDistance,
                )
              ],
            ),

            style: TextStyle(
                color: ColorManager.primary, fontSize: AppSize.s20.sp),
          ),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        closeButton(context),
        Bounceable(
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            onTap: () async {
              await addOrEditPrinter(context);
            },
            child: containerComponent(
                context,
                Center(
                    child: Text(
                      AppStrings.addPrinter.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                height: 40.h,
                width: widget.deviceWidth <= 600 ? 170.h : 50.w,
                color: ColorManager.primary,
                borderRadius: AppSize.s5,
                borderColor: ColorManager.primary,
                borderWidth: 0.6.w)),
      ],
    );
  }

  Widget newPrinter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Bounceable(
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            onTap: () async {
              await addOrEditPrinter(context);
            },
            child: containerComponent(
                context,
                Center(
                    child: Text(
                      AppStrings.newPrinter.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                height: 40.h,
                width: widget.deviceWidth <= 600 ? 170.h : 50.w,
                color: ColorManager.primary,
                borderRadius: AppSize.s5,
                borderColor: ColorManager.primary,
                borderWidth: 0.6.w)),
      ],
    );
  }

  Future<void> addOrEditPrinter(BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));
  }
}
