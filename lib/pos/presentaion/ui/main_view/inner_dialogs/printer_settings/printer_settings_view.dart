import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/components/close_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/printer_settings/printer_table/printer_table_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/printer_settings/printer_table/printer_table_head.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/printer_settings/widgets/printer_ip.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/printer_settings/widgets/printer_name.dart';

import 'package:poslix_app/pos/shared/constant/strings_manager.dart';

import '../../../../../domain/entities/printing_settings_model.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../../di/di.dart';
import '../../../components/container_component.dart';
import '../../../popup_dialogs/custom_dialog.dart';
import '../../main_view_cubit/main_view_cubit.dart';
import '../../main_view_cubit/main_view_state.dart';


class PrinterSettingsDialog extends StatefulWidget {
  double deviceWidth;
  static void show(BuildContext context, double deviceWidth) => isApple()
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

  PrinterSettingsDialog({required this.deviceWidth, super.key});

  @override
  State<PrinterSettingsDialog> createState() => _PrinterSettingsDialogState();
}

class _PrinterSettingsDialogState extends State<PrinterSettingsDialog> {
  TextEditingController printerNameEditingController = TextEditingController();
  TextEditingController printerIPEditingController = TextEditingController();

  List<String> listOfPrinters = [];
  List<String> listOfPrinterIPs = [];
  List<String> listOfPrinterType = ['receipt', 'A4'];
  List<String> listOfConnectionMethods = ['Wifi', 'USB', 'Bluetooth'];
  List<String> listOfStatus = ['On', 'Off'];

  int getIndex(int index) {
    int finalIndex = index + 1;
    return finalIndex;
  }

  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;

  String _selectedPrinter = '';
  String _selectedPrinterIP = '';
  var _selectedPrinterType;
  var _selectedConnectionMethod;
  var _selectedStatus;
  List<PrintSettingModel> printSettingsData = [];
  int? _selectedPrinterId;

  bool keyPadOn = false;
  bool addNew = true;
  bool editData = false;
  bool endNameEdit = false;
  bool endIPEdit = false;
  bool showPrinterIP = true;

  @override
  void dispose() {
    printerNameEditingController.dispose();
    printerIPEditingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainViewCubit>()..getPrintingSettings(),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is InsertPrintingSettings) {
            CustomDialog.show(
                context,
                AppStrings.printerAddedSuccessfully.tr(),
                const Icon(Icons.check),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.success);
          } else if (state is InsertErrorPrintingSettings) {}

          if (state is DeletePrintingSettings) {
            CustomDialog.show(
                context,
                AppStrings.printerDeletedSuccessfully.tr(),
                const Icon(Icons.check),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.success);
          } else if (state is DeleteErrorPrintingSettings) {}

          if (state is UpdatePrintingSettings) {
            CustomDialog.show(
                context,
                AppStrings.printerUpdatedSuccessfully.tr(),
                const Icon(Icons.check),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.success);
          } else if (state is UpdateErrorPrintingSettings) {}

          if (state is LoadedPrintingSettings) {
            printSettingsData = state.printSettingResponse;
          } else if (state is LoadingErrorPrintingSettings) {}

          if (state is LoadedByIdPrintingSettings) {
              _selectedPrinterId  = state.printSettingResponse.id;
              _selectedPrinter = state.printSettingResponse.printerName!;
              printerNameEditingController.text = state.printSettingResponse.printerName!;
              _selectedPrinterIP = state.printSettingResponse.printerIP!;
              printerIPEditingController.text = state.printSettingResponse.printerIP!;
              _selectedConnectionMethod =
                  state.printSettingResponse.connectionMethod;
              _selectedPrinterType = state.printSettingResponse.printType;
              _selectedStatus =
                  state.printSettingResponse.printerStatus == 1 ? 'On' : 'Off';
              if (_selectedConnectionMethod == 'USB' || _selectedConnectionMethod == 'Bluetooth') {
                setState(() {
                  showPrinterIP = false;
                });
              } else {
                setState(() {
                  showPrinterIP = true;
                });
              }
          } else if (state is LoadingByIdErrorPrintingSettings) {}
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: SingleChildScrollView(
                      child: Container(
                          width: widget.deviceWidth <= 600 ? 350.w : 450.w,
                          height: 540.h,
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
                                    newPrinter(context),
                                    SizedBox(
                                      height:
                                          AppConstants.heightBetweenElements,
                                    ),
                                    addNew
                                        ? printerData(context)
                                        : Expanded(
                                            flex: 2,
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: createDataTable(
                                                        context,
                                                        _currentSortColumn,
                                                        _isSortAsc,
                                                        createColumns(
                                                            widget.deviceWidth),
                                                        createRows(
                                                            context,
                                                            widget
                                                                .deviceWidth)))),
                                          ),
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
                    printerNameValue(context, printerNameEditingController,
                        widget.deviceWidth, editData, _selectedPrinter, getNewPrinterNameValue, endNameEdit),
                    showPrinterIP ? printerIPValue(context, printerIPEditingController,
                        widget.deviceWidth, editData, _selectedPrinterIP, getNewPrinterIPValue, endIPEdit) : Container(),
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

  void getNewPrinterNameValue(String newValue) {
    endNameEdit = true;
    endIPEdit = true;
    printerNameEditingController.text = newValue;
  }

  void getNewPrinterIPValue(String newValue) {
    endIPEdit = true;
    endNameEdit = true;
    printerIPEditingController.text = newValue;
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
              padding: const EdgeInsets.only(
                  left: AppPadding.p14, right: AppPadding.p14),
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
                      color: ColorManager.primary, fontSize: AppSize.s15.sp),
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
              padding: const EdgeInsets.only(
                  left: AppPadding.p14, right: AppPadding.p14),
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
                if (_selectedConnectionMethod == 'USB' || _selectedConnectionMethod == 'Bluetooth') {
                  showPrinterIP = false;
                } else {
                  showPrinterIP = true;
                }
              });
            },
            value: _selectedConnectionMethod,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.chooseConnectionMethod.tr(),
                  style: TextStyle(
                      color: ColorManager.primary, fontSize: AppSize.s15.sp),
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
              padding: const EdgeInsets.only(
                  left: AppPadding.p14, right: AppPadding.p14),
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
                _selectedStatus = selectedStatus;
              });
            },
            value: _selectedStatus,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePrinterStatus.tr(),
                  style: TextStyle(
                      color: ColorManager.primary, fontSize: AppSize.s15.sp),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        closeButton(context),
        SizedBox(
          width: AppConstants.smallDistance,
        ),
        addNew
            ? Bounceable(
                duration:
                    Duration(milliseconds: AppConstants.durationOfBounceable),
                onTap: () async {
                  await addOrEditPrinter(context);
                },
                child: containerComponent(
                    context,
                    Center(
                        child: Text(
                      editData
                          ? AppStrings.editPrinter.tr()
                          : AppStrings.addPrinter.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                    height: 40.h,
                    width: widget.deviceWidth <= 600 ? 170.h : 50.w,
                    color: ColorManager.primary,
                    borderRadius: AppSize.s5,
                    borderColor: ColorManager.primary,
                    borderWidth: 0.6.w))
            : Container(),
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
              setState(() {
                addNew = !addNew;
                if (!addNew) {
                  MainViewCubit.get(context).getPrintingSettings();
                } else if (addNew) {
                  reload();
                  editData = false;
                }
              });
            },
            child: containerComponent(
                context,
                Center(
                    child: Text(
                  addNew
                      ? editData ? AppStrings.cancel.tr() : AppStrings.allPrinters.tr()
                      : AppStrings.newPrinter.tr(),
                  style: TextStyle(
                      color: ColorManager.white, fontSize: AppSize.s14.sp),
                )),
                height: 40.h,
                width: widget.deviceWidth <= 600 ? 170.h : 50.w,
                color: addNew ? editData ? ColorManager.delete : ColorManager.primary : ColorManager.primary,
                borderRadius: AppSize.s5,
                borderColor: addNew ? editData ? ColorManager.delete : ColorManager.primary : ColorManager.primary,
                borderWidth: 0.6.w)),
      ],
    );
  }

  Future<void> addOrEditPrinter(BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));
    if (_selectedConnectionMethod == 'USB' || _selectedConnectionMethod == 'Bluetooth') {
      printerIPEditingController.text = 'No IP';
    }
    if (printerNameEditingController.text == '' ||
        printerIPEditingController.text == '' ||
        _selectedPrinterType == null ||
        _selectedConnectionMethod == null ||
        _selectedStatus == null) {
      CustomDialog.show(
          context,
          AppStrings.completeRequired.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
      return;
    }
    if (!editData) {
      PrintSettingModel printSettingModel = PrintSettingModel(
        id: null,
        printerName: printerNameEditingController.text,
        printerIP: printerIPEditingController.text,
        printType: _selectedPrinterType,
        connectionMethod: _selectedConnectionMethod,
        printerStatus: _selectedStatus == 'On' ? 1 : 0,
      );

      for(var t in printSettingsData) {
        if (t.printerName == printerNameEditingController.text) {
          CustomDialog.show(
              context,
              AppStrings.samePrinterName.tr(),
              const Icon(Icons.warning_amber_rounded),
              ColorManager.white,
              AppConstants.durationOfSnackBar,
              ColorManager.hold);
          return;
        }
      }

      if (_selectedStatus == 'On') {
        await MainViewCubit.get(context).updateAllPrintingSetting();
      }

      await MainViewCubit.get(context).addPrintingSetting(printSettingModel);

    } else {
      PrintSettingModel printSettingModel = PrintSettingModel(
        id: _selectedPrinterId,
        printerName: printerNameEditingController.text,
        printerIP: printerIPEditingController.text,
        printType: _selectedPrinterType,
        connectionMethod: _selectedConnectionMethod,
        printerStatus: _selectedStatus == 'On' ? 1 : 0,
      );


      for(var t in printSettingsData) {
        if (t.printerName == printerNameEditingController.text && t.id != _selectedPrinterId) {
          CustomDialog.show(
              context,
              AppStrings.samePrinterName.tr(),
              const Icon(Icons.warning_amber_rounded),
              ColorManager.white,
              AppConstants.durationOfSnackBar,
              ColorManager.hold);
          return;
        }
      }

      if (_selectedStatus == 'On') {
        await MainViewCubit.get(context).updateAllPrintingSetting();
      }

      await MainViewCubit.get(context)
          .updatePrintingSetting(printSettingModel, _selectedPrinterId!);
    }

    setState(() {
      editData = false;
      addNew = true;
      reload();
    });
  }

  void reload() {
    printerNameEditingController.text = '';
    printerIPEditingController.text = '';
  }

  List<DataRow> createRows(BuildContext context, double deviceWidth) {
    return printSettingsData
        .map((tmpOrder) => DataRow(cells: [
              DataCell(Text(
                getIndex(printSettingsData.indexOf(tmpOrder)).toString(),
                style: TextStyle(color: ColorManager.edit),
              )),
              DataCell(SizedBox(
                width: widget.deviceWidth <= 600 ? 100.w : 40.w,
                child: Center(
                    child: Text(
                        printSettingsData[printSettingsData.indexOf(tmpOrder)]
                            .printerName
                            .toString(),
                        style: TextStyle(fontSize: AppSize.s12.sp),
                        textAlign: TextAlign.center)),
              )),
              DataCell(SizedBox(
                width: widget.deviceWidth <= 600 ? 100.w : 42.w,
                child: Center(
                    child: Text(
                        printSettingsData[printSettingsData.indexOf(tmpOrder)]
                            .printerStatus == 1 ? 'On' : 'Off',
                        style: TextStyle(fontSize: AppSize.s12.sp),
                        textAlign: TextAlign.center)),
              )),
              DataCell(SizedBox(
                width: widget.deviceWidth <= 600 ? 50.w : 20.w,
                child: Center(
                    child: Row(
                      children: [
                        Bounceable(
                            duration: Duration(
                                milliseconds: AppConstants.durationOfBounceable),
                            onTap: () async {
                              await Future.delayed(Duration(
                                  milliseconds: AppConstants.durationOfBounceable));
                              await MainViewCubit.get(context).getPrinterById(printSettingsData[printSettingsData.indexOf(tmpOrder)]
                                  .id!);
                              setState(() {
                                addNew = !addNew;
                                editData = true;
                              });
                            },
                            child: Icon(
                              Icons.edit,
                              color: ColorManager.edit,
                              size: AppSize.s20.sp,
                            )),
                        SizedBox(
                          width: AppConstants.smallDistance,
                        ),
                        Bounceable(
                            duration: Duration(
                                milliseconds: AppConstants.durationOfBounceable),
                            onTap: () async {
                              await Future.delayed(Duration(
                                  milliseconds: AppConstants.durationOfBounceable));
                              await MainViewCubit.get(context).deletePrintingSetting(printSettingsData[printSettingsData.indexOf(tmpOrder)]
                                  .id!);
                              await MainViewCubit.get(context).getPrintingSettings();
                              setState(() {

                              });
                            },
                            child: Icon(
                              Icons.delete,
                              color: ColorManager.delete,
                              size: AppSize.s20.sp,
                            ))
                      ],
                    )),
              )),
            ]))
        .toList();
  }
}
