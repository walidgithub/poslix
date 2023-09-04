import 'dart:typed_data';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/printing/wi_fi_thermal_printer/ImagestorByte.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/printing/wi_fi_thermal_printer/printer.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/printing/wi_fi_thermal_printer/bill_format.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/widgets/check_out_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/widgets/new_payment_methods.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/widgets/totals.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_state.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
// import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../../domain/requests/cart_model.dart';
import '../../../../../domain/requests/check_out_model.dart';
import '../../../../../domain/requests/payment_types_model.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/language_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/preferences/app_pref.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../di/di.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../../../popup_dialogs/custom_dialog.dart';
import '../../main_view_cubit/main_view_cubit.dart';
import '../tailor_dialog/widgets/main_note.dart';
import 'widgets/add_payment_row.dart';
import 'widgets/main_payment _method.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

class PaymentDialog extends StatefulWidget {
  double total;
  List<CartRequest> cartRequest;
  int locationId;
  int customerId;
  String discountType;
  String currencyCode;
  double discountAmount;
  String taxType;
  double taxAmount;
  Function done;
  double deviceWidth;
  static void show(
    BuildContext context,
    String currencyCode,
    double total,
    List<CartRequest> cartRequest,
    int locationId,
    int customerId,
    String discountType,
    double discountAmount,
    String taxType,
    double taxAmount,
    Function done,
      double deviceWidth
  ) =>
      isApple()
          ? showCupertinoDialog<void>(
                  context: context,
                  useRootNavigator: false,
                  barrierDismissible: false,
                  builder: (_) => PaymentDialog(
                        currencyCode: currencyCode,
                        total: total,
                        cartRequest: cartRequest,
                        locationId: locationId,
                        customerId: customerId,
                        discountType: discountType,
                        discountAmount: discountAmount,
                        taxType: taxType,
                        taxAmount: taxAmount,
                        done: done,
                    deviceWidth: deviceWidth,
                      ))
              .then((_) => FocusScope.of(context).requestFocus(FocusNode()))
          : showDialog<void>(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (_) => PaymentDialog(
                currencyCode: currencyCode,
                total: total,
                cartRequest: cartRequest,
                locationId: locationId,
                customerId: customerId,
                discountType: discountType,
                discountAmount: discountAmount,
                taxType: taxType,
                taxAmount: taxAmount,
                done: done,
                deviceWidth: deviceWidth,
              ),
            ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  PaymentDialog(
      {required this.currencyCode,
      required this.total,
      required this.cartRequest,
      required this.locationId,
      required this.customerId,
      required this.discountType,
      required this.discountAmount,
      required this.taxType,
      required this.taxAmount,
      required this.done,
      required this.deviceWidth,
      super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  final TextEditingController _notesEditingController = TextEditingController();
  final TextEditingController _amountEditingController =
      TextEditingController();
  final TextEditingController _notesInLineEditingController =
      TextEditingController();

  final List<TextEditingController> _paymentControllers = [];
  final List<TextEditingController> _paymentNotesControllers = [];

  int decimalPlaces = 2;

  @override
  void initState() {
    getDecimalPlaces();
    setState(() {
      isArabic();
    });
    sizedHeight = isRtl ? 370.h : 370.h;

    printType = printTypes[2];

    totalNewPaying = 0;
    totalPaying = 0;
    changeReturn = 0;
    balance = 0;

    selectedPaymentType = AppStrings.cash.tr();
    due = 0.0;
    _amountEditingController.text = widget.total.toString();

    _amountEditingController.addListener(goToCalc);

    changedTotal = widget.total.toString();
    super.initState();
  }

  bool isRtl = false;

  void isArabic() async {
    String currentLang = await _appPreferences.getAppLanguage();
    if (currentLang == 'ar') {
      isRtl = true;
    } else {
      isRtl = false;
    }
  }

  @override
  void dispose() {
    _notesEditingController.dispose();
    _amountEditingController.dispose();
    _notesInLineEditingController.dispose();
    for (var controller in _paymentControllers) {
      controller.dispose();
    }
    for (var controller in _paymentNotesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  var selectedPaymentType;

  List selectedNewPaymentType = [AppStrings.cash.tr()];

  List<PaymentTypesRequest> paymentRequest = [];

  bool newPayment = false;

  DateTime today = DateTime.now();

  String businessImage = '';
  String businessName = '';
  String businessTell = '';
  String businessAddress = '';
  String businessEmail = '';
  String businessVat = '';
  String customerNumber = '';

  List paymentMethods = [];

  ScreenshotController screenshotController = ScreenshotController();

  void goToPrint(String printerIp, Uint8List theimageThatComesfr) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      await testReceipt(printer, theimageThatComesfr);
      await Future.delayed(const Duration(seconds: 3), () {
        printer.disconnect();
      });
    }
  }

  double? totalPaying;
  double? changeReturn;
  double? balance;
  double? due;

  double totalNewPaying = 0.0;

  int orderId = 0;

  List printTypes = ['Bluetooth', 'A4', 'Wi_Fi_Thermal'];
  String? printType = '';

  double? sizedHeight;
  double innerHeight = 60.h;
  int paymentWaysCount = 0;

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getLocationId(PREFS_KEY_DECIMAL_PLACES)!;
  }

  String changedTotal = '';



  void goToCalc() {
    setState(() {
      totalNewPaying = 0.0;
      for (var controller in _paymentControllers) {
        if (controller.text != '') {
          totalNewPaying =
              totalNewPaying + double.parse(controller.text.toString());
        }
      }

      if (_amountEditingController.text == '') {
        changedTotal =
            roundDouble(totalNewPaying + 0.0, decimalPlaces).toString();
        totalPaying = 0.0;
      } else {
        changedTotal = roundDouble(
                totalNewPaying + double.parse(_amountEditingController.text),
                decimalPlaces)
            .toString();
        totalPaying = double.parse(changedTotal);
      }

      if (totalPaying! > widget.total) {
        changeReturn =
            roundDouble(widget.total - totalPaying!, decimalPlaces).abs();
        balance = 0;
      } else if (totalPaying! < widget.total) {
        changeReturn = 0;
        balance = roundDouble(widget.total - totalPaying!, decimalPlaces);
      } else {
        changeReturn = 0;
        balance = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MainViewCubit>()..getAppearance(widget.locationId),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is MainNoInternetState) {
            showNoInternet(context);

            await Future.delayed(
                Duration(milliseconds: AppConstants.durationOfSnackBar));

            PaymentDialog.hide(context);
          }

          if (state is CheckOutSucceed) {
            print('doneeeeeeee');
            orderId = state.checkOutRes.id;
            widget.done('done');
          } else if (state is CheckOutError) {
            print('erroooorrrrrrrrrrrrrrrrrr');
            CustomDialog.show(
                context,
                AppStrings.errorInPayment.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);

            await Future.delayed(
                Duration(milliseconds: AppConstants.durationOfSnackBar));

            PaymentDialog.hide(context);
          }
          if (state is LoadedAppearance) {
            businessImage = state.appearanceResponse.logo;
            businessName = state.appearanceResponse.name;
            businessTell = state.appearanceResponse.tell;
            businessEmail = state.appearanceResponse.email;
            businessAddress = state.appearanceResponse.address;
            businessVat = state.appearanceResponse.vatNumber;
            customerNumber = state.appearanceResponse.customerNumber;
          } else if (state is LoadingErrorAppearance) {}
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox.expand(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: widget.deviceWidth <= 600 ? 375.w : 200.w,
                        height: sizedHeight,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(AppSize.s5),
                                boxShadow: [
                                  BoxShadow(color: ColorManager.badge)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Text(
                                        AppStrings.payment.tr(),
                                        style: TextStyle(
                                            fontSize: AppSize.s20.sp,
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                                    ),
                                    mainNotes(context, _notesEditingController),
                                    SizedBox(
                                      height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                                    ),
                                    mainPaymentMethod(
                                        context,
                                        widget.total,
                                        selectMainPaymentMethod,
                                        _amountEditingController,
                                        _notesInLineEditingController,
                                        selectedPaymentType, widget.deviceWidth),
                                    newPaymentMethods(
                                        context,
                                        deletePaymentMethod,
                                        newPayment,
                                        innerHeight,
                                        paymentMethods,
                                        _paymentControllers,
                                        widget.total,
                                        _paymentNotesControllers,
                                        selectPaymentType,
                                        selectedNewPaymentType, widget.deviceWidth),
                                    SizedBox(
                                      height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                                    ),
                                    addNewPaymentRow(context, addPaymentRow, widget.deviceWidth),
                                    SizedBox(
                                      height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                                    ),
                                    totals(
                                        context,
                                        widget.total,
                                        changedTotal,
                                        changeReturn!,
                                        balance!,
                                        widget.currencyCode, widget.deviceWidth),
                                    SizedBox(
                                      height: AppConstants.smallerDistance,
                                    ),
                                    const Divider(
                                      thickness: AppSize.s1,
                                    ),
                                    checkOutButtons(context, checkOut, widget.deviceWidth),
                                    SizedBox(
                                      height: AppConstants.bigHeightBetweenElements,
                                    ),
                                    SizedBox(
                                      height: AppConstants.bigHeightBetweenElements,
                                    ),
                                    billModel(
                                        context,
                                        screenshotController,
                                        today,
                                        businessName,
                                        businessImage,
                                        businessTell,
                                        orderId,
                                        widget.taxAmount,
                                        widget.discountAmount,
                                        widget.total,
                                        totalPaying!,
                                        due!),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ))));
        },
      ),
    );
  }

  void selectMainPaymentMethod(String selectedType) {
    setState(() {
      selectedPaymentType = selectedType;
    });
  }

  void selectPaymentType(int index, var selectedType) {
    setState(() {
      selectedNewPaymentType[index] = selectedType;
    });
  }

  void deletePaymentMethod(int index) {
    setState(() {
      _paymentControllers.removeAt(index);
      _paymentNotesControllers.removeAt(index);
      paymentMethods.removeAt(index);

      selectedNewPaymentType.removeAt(index);

      paymentWaysCount--;

      if (paymentMethods.length == 1) {
        innerHeight = isRtl ? 70 : 60.h;
        sizedHeight = isRtl ? 450 : 430.h;
      } else if (paymentMethods.length > 1) {
        innerHeight = isRtl ? 145 : 125.h;
        sizedHeight = isRtl ? 525 : 490.h;
      } else if (paymentMethods.isEmpty) {
        newPayment = false;
        sizedHeight = isRtl ? 380 : 365.h;
      }
    });
  }

  void addPaymentRow(BuildContext context) {
    setState(() {
      _paymentNotesControllers.add(TextEditingController());
      _paymentControllers.add(TextEditingController());

      _paymentControllers[paymentWaysCount].addListener(goToCalc);

      selectedNewPaymentType.add(AppStrings.cash.tr());

      totalNewPaying = 0.0;
      for (var controller in _paymentControllers) {
        if (controller.text != '') {
          totalNewPaying =
              totalNewPaying + double.parse(controller.text.toString());
        }
      }

      if (double.parse(_amountEditingController.text) + totalNewPaying >
          widget.total) {
        _paymentControllers[paymentWaysCount].text = '0.0';
      } else {
        _paymentControllers[paymentWaysCount].text = roundDouble(
                (widget.total -
                    (double.parse(_amountEditingController.text) +
                        totalNewPaying)),
                decimalPlaces)
            .toString();
      }

      newPayment = true;
      paymentMethods.add(paymentWaysCount);
      if (paymentMethods.length == 1) {
        innerHeight = isRtl ? 70 : 60.h;
        sizedHeight = isRtl ? 450 : 430.h;
      } else if (paymentMethods.length > 1) {
        innerHeight = isRtl ? 145 : 125.h;
        sizedHeight = isRtl ? 525 : 490.h;
      } else if (paymentMethods.isEmpty) {
        newPayment = false;
        sizedHeight = isRtl ? 380 : 365.h;
      }
      paymentWaysCount++;
    });
  }

  Future<void> checkOut(BuildContext context) async {
    paymentRequest.add(PaymentTypesRequest(
        paymentId: '1',
        amount: roundDouble(
            double.parse(_amountEditingController.text), decimalPlaces),
        note: _notesEditingController.text));

    for (int n = 0; n < selectedNewPaymentType.length - 1; n++) {
      paymentRequest.add(PaymentTypesRequest(
          paymentId: selectedNewPaymentType[n],
          amount: roundDouble(
              double.parse(_paymentControllers[n].text), decimalPlaces),
          note: _paymentNotesControllers[n].text));
    }

    CheckOutRequest checkOutRequest = CheckOutRequest(
        locationId: widget.locationId,
        customerId: widget.customerId,
        discountType: widget.discountType,
        discountAmount: widget.discountAmount.toString(),
        notes: _notesInLineEditingController.text,
        cart: widget.cartRequest,
        taxType: widget.taxType,
        taxAmount: widget.taxAmount,
        payment: paymentRequest);

    await MainViewCubit.get(context).checkout(checkOutRequest);
    setState(() {});

    for (var n in _paymentControllers) {
      totalPaying = roundDouble(double.parse(n.text), decimalPlaces);
    }

    totalPaying = totalPaying! +
        roundDouble(double.parse(_amountEditingController.text), decimalPlaces);

    due = widget.total - totalPaying!;

    await Future.delayed(const Duration(milliseconds: 1000));

    if (printType == 'Bluetooth') {
      // Navigator.of(context).pushNamed(
      //     Routes.thermalPrint,
      //     arguments: GoToThermal(
      //         total: widget.total.toString()));
    } else if (printType == 'A4') {
      // final image = await imageFromAssetBundle(
      //   "assets/images/logo.jpeg",
      // );
      // final doc = pw.Document();
      // doc.addPage(pw.Page(
      //     pageFormat: PdfPageFormat.a4,
      //     build: (pw.Context context) {
      //       return buildPrintableData(image,
      //           businessAddress,
      //           businessEmail,
      //           businessVat,
      //           customerNumber,
      //           widget.currencyCode
      //           ,today,
      //           businessName,
      //           businessImage,
      //           businessTell,
      //           orderId,
      //           widget.taxAmount,
      //           widget.discountAmount,
      //           widget.total,
      //           totalPaying!,
      //           due!);
      //     }));
      // await Printing.layoutPdf(
      //     onLayout: (PdfPageFormat format) async => doc.save());

    } else if (printType == 'Wi_Fi_Thermal') {
      screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((capturedImage) async {
        theImageThatComesFromThePrinter = capturedImage!;
        setState(() {
          theImageThatComesFromThePrinter = capturedImage;
          goToPrint(AppConstants.printerIp, theImageThatComesFromThePrinter);
        });
      }).catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });
    }
    PaymentDialog.hide(context);
  }
}