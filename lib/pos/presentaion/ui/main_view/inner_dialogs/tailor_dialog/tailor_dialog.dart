import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/domain/entities/fabrics_model.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/tailor_dialog/widgets/size_name_Section.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/tailor_dialog/widgets/total_section.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';

import '../../../../../domain/entities/tmp_order_model.dart';
import '../../../../../domain/response/customer_model.dart';
import '../../../../../domain/response/prices_model.dart';
import '../../../../../domain/response/tailoring_types_model.dart';
import '../../../../../shared/constant/assets_manager.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/preferences/app_pref.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../di/di.dart';
import '../../../components/close_button.dart';
import '../../../components/container_component.dart';
import '../../../popup_dialogs/custom_dialog.dart';
import 'widgets/main_note.dart';

class TailorDialog extends StatefulWidget {
  String currencyCode;
  int itemIndex;
  var selectedListName;
  TailoringTypesModel tailoringType;
  List listOfFabrics;
  List<PricesResponse> listOfPackagePrices;
  List<CustomerResponse> listOfCustomers;
  double? discount;
  int? decimalPlaces;
  String selectedCustomer;
  String selectedCustomerTel;
  double deviceWidth;

  static void show(
          BuildContext context,
          String currencyCode,
          int itemIndex,
          var selectedListName,
          TailoringTypesModel tailoringType,
          List listOfFabrics,
          List<PricesResponse> listOfPackagePrices,
          List<CustomerResponse> listOfCustomers,
          double discount,
          int decimalPlaces,
          String selectedCustomer,
          String selectedCustomerTel,
      double deviceWidth
      ) =>
      isApple()
          ? showCupertinoDialog<void>(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (_) => TailorDialog(
                    currencyCode: currencyCode,
                    itemIndex: itemIndex,
                    selectedListName: selectedListName,
                    tailoringType: tailoringType,
                    listOfFabrics: listOfFabrics,
                    listOfPackagePrices: listOfPackagePrices,
                    listOfCustomers: listOfCustomers,
                    discount: discount,
                    decimalPlaces: decimalPlaces,
                    selectedCustomer: selectedCustomer,
                    selectedCustomerTel: selectedCustomerTel,
                deviceWidth: deviceWidth,
                  ))
          : showDialog<void>(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (_) => TailorDialog(
                currencyCode: currencyCode,
                itemIndex: itemIndex,
                selectedListName: selectedListName,
                tailoringType: tailoringType,
                listOfFabrics: listOfFabrics,
                listOfPackagePrices: listOfPackagePrices,
                listOfCustomers: listOfCustomers,
                discount: discount,
                decimalPlaces: decimalPlaces,
                selectedCustomer: selectedCustomer,
                selectedCustomerTel: selectedCustomerTel,
                deviceWidth: deviceWidth,
              ),
            ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  TailorDialog({required this.currencyCode,
      required this.itemIndex,
      required this.selectedListName,
      required this.tailoringType,
      required this.listOfFabrics,
      required this.listOfPackagePrices,
      required this.listOfCustomers,
      required this.discount,
      required this.decimalPlaces,
      required this.selectedCustomer,
      required this.selectedCustomerTel,
      required this.deviceWidth,
      super.key});

  @override
  State<TailorDialog> createState() => _TailorDialogState();
}

class _TailorDialogState extends State<TailorDialog> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  final TextEditingController _notesEditingController = TextEditingController();
  final TextEditingController _sizeNameEditingController =
      TextEditingController();

  final ScrollController _inputsScrollController = ScrollController();
  final ScrollController _wholeScrollController = ScrollController();

  final List<TextEditingController> _sizesControllers = [];

  CustomerResponse? _selectedCustomer;

  List<FabricsModel> fabricDetails = [];

  List<FabricsModel> selectedFabrics = [];

  List sizes = [];

  String? _selectedCustomerName;

  int? _selectedCustomerId;

  DateTime today = DateTime.now();

  double dialogWidth = 200.w;

  double calcTotal = 0;

  void isSelected(int itemId) {
    setState(() {
      final currentId =
          fabricDetails.indexWhere((element) => element.id == itemId);
      fabricDetails[currentId].selected = !fabricDetails[currentId].selected!;
      if (fabricDetails[currentId].selected!) {
        selectedFabrics.add(FabricsModel(
            itemPrice: fabricDetails[currentId].itemPrice,
            id: fabricDetails[currentId].id));
      } else {
        selectedFabrics.removeWhere(
            (element) => element.id == fabricDetails[currentId].id);
      }
    });
  }

  @override
  void initState() {
    sizes = widget.tailoringType.sizes!.toList();

    for (int i = 0; i < sizes.length; i++) {
      _sizesControllers.add(TextEditingController());
      _sizesControllers[i].addListener(goToCalc);
    }

    for (var nToId in widget.listOfFabrics) {
      if (nToId != '') {
        for (var nToImage in widget.selectedListName) {
          if (nToId.toString() == nToImage.id.toString()) {
            String fabricPrice =
                '${nToImage.sellPrice.substring(0, nToImage.sellPrice.indexOf('.'))}${nToImage.sellPrice.substring(nToImage.sellPrice.indexOf('.'), nToImage.sellPrice.indexOf('.') + 1 + widget.decimalPlaces)}';
            fabricDetails.add(FabricsModel(
                id: int.parse(nToId),
                itemImage: nToImage.image,
                itemName: nToImage.name,
                selected: false,
                itemPrice: fabricPrice));
          }
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _notesEditingController.dispose();
    _sizeNameEditingController.dispose();

    for (var controller in _sizesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void goToCalc() {
    setState(() {
      calcTotal = 0.0;
      if (selectedFabrics.isEmpty) {
        CustomDialog.show(
            context,
            AppStrings.selectFabricFirst.tr(),
            const Icon(Icons.warning_amber_rounded),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.hold);
      } else {
        for (var nOfFabric in selectedFabrics) {
          int sizeIndex = 0;
          String itemPrice =
              '${nOfFabric.itemPrice.toString().substring(0, nOfFabric.itemPrice.toString().indexOf('.'))}${nOfFabric.itemPrice.toString().substring(nOfFabric.itemPrice.toString().indexOf('.'), nOfFabric.itemPrice.toString().indexOf('.') + 1 + widget.decimalPlaces!)}';
          for (var nOfSize in _sizesControllers) {
            if (nOfSize.text != '') {
              if (double.parse(widget.tailoringType.multipleValue.toString()) >
                  1) {
                if (sizes[sizeIndex].isPrimary == 1) {
                  calcTotal = calcTotal +
                      (double.parse(nOfSize.text.toString()) *
                          double.parse(itemPrice) *
                          double.parse(
                              widget.tailoringType.multipleValue.toString()));
                } else {
                  calcTotal = calcTotal +
                      (double.parse(nOfSize.text.toString()) *
                          double.parse(itemPrice));
                }
              } else {calcTotal = calcTotal +
                    (double.parse(nOfSize.text.toString()) *
                        double.parse(itemPrice));
              }
            }
            sizeIndex++;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Scrollbar(
            thumbVisibility: true,
            controller: _wholeScrollController,
            child: Container(
                height: widget.deviceWidth <= 600 ? 500.h : 580.h,
                width: widget.deviceWidth <= 600 ? 350.w : dialogWidth,
                decoration: BoxDecoration(
                    color: ColorManager.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(AppSize.s5),
                    boxShadow: [BoxShadow(color: ColorManager.badge)]),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                      AppPadding.p20, AppPadding.p20, AppPadding.p10),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: _wholeScrollController,
                    child: Container(
                      height: widget.deviceWidth <= 600 ? 550.h : 580.h,
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              AppStrings.completeTheForm.tr(),
                              style: TextStyle(
                                  fontSize: AppSize.s20.sp,
                                  color: ColorManager.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          SizedBox(
                            height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallDistance,
                          ),

                          // -----------------------------------------------------------
                          customerDropDown(context),

                          SizedBox(
                            height: AppConstants.smallDistance,
                          ),
                          // -----------------------------------------------------------

                          // Choices Fields
                          containerComponent(
                              context,
                              Column(
                                children: [
                                  tailoringTypesFields(context),
                                ],
                              ),
                              height: widget.deviceWidth <= 600 ? 110.h : 120.h,
                              color: ColorManager.white,
                              borderColor: ColorManager.white,
                              borderWidth: 0.w,
                              borderRadius: AppSize.s5),

                          SizedBox(
                            height: AppConstants.smallerDistance,
                          ),

                          sizeName(context, _sizeNameEditingController),

                          SizedBox(
                            height: AppConstants.smallDistance,
                          ),

                          // select a fabric
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.selectFabric.tr(),
                                style: TextStyle(
                                    color: ColorManager.primary,
                                    fontSize: AppSize.s14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: AppConstants.smallDistance,
                          ),

                          // fabrics
                          fabrics(context),

                          const Divider(
                            thickness: AppSize.s1,
                          ),

                          mainNotes(context, _notesEditingController),

                          SizedBox(
                            height: widget.deviceWidth <= 600 ? AppConstants.smallWidthBetweenElements : AppConstants.smallerDistance,
                          ),

                          total(context, calcTotal),

                          SizedBox(
                            height: AppConstants.smallerDistance,
                          ),

                          const Divider(
                            thickness: AppSize.s1,
                          ),

                          buttons(context)
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget tailoringTypesFields(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      thumbVisibility: true,
      controller: _inputsScrollController,
      child: GridView.count(
          controller: _inputsScrollController,
          crossAxisCount: widget.deviceWidth <= 600 ? 2 : 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
          childAspectRatio: widget.deviceWidth <= 600 ? 2.5 / 1 : 6 / 2,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(sizes.length, (index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppPadding.p0, AppPadding.p5, AppPadding.p5, AppPadding.p5),
              child: TextField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  controller: _sizesControllers[index],
                  decoration: InputDecoration(
                      hintText: sizes[index].name,
                      hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                      labelText: sizes[index].name,
                      labelStyle: TextStyle(
                          fontSize: AppSize.s15.sp,
                          color: ColorManager.primary),
                      border: InputBorder.none)),
            );
          })),
    ));
  }

  Widget customerDropDown(BuildContext context) {
    return containerComponent(
        context,
        DropdownButton(
          borderRadius: BorderRadius.circular(AppSize.s5),
          itemHeight: 50.h,
          underline: Container(),
          value: _selectedCustomer,
          items: widget.listOfCustomers.map((item) {
            return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    Text(item.firstName,
                        style: TextStyle(
                            color: ColorManager.primary,
                            fontSize: AppSize.s14.sp)),
                    SizedBox(width: AppConstants.smallerDistance),
                    Text(item.lastName,
                        style: TextStyle(
                            color: ColorManager.primary,
                            fontSize: AppSize.s14.sp)),
                    Row(
                      children: [
                        SizedBox(width: AppConstants.smallerDistance),
                        Text('|',
                            style: TextStyle(
                                color: ColorManager.primary,
                                fontSize: AppSize.s14.sp)),
                        SizedBox(width: AppConstants.smallerDistance),
                        Text(item.mobile,
                            style: TextStyle(
                                color: ColorManager.primary,
                                fontSize: AppSize.s14.sp))
                      ],
                    ),
                  ],
                ));
          }).toList(),
          onChanged: (selectedCustomer) {
            setState(() {
              _selectedCustomer = selectedCustomer;
              _selectedCustomerName =
                  '${selectedCustomer?.firstName} ${selectedCustomer?.lastName}';
              _selectedCustomerId = selectedCustomer?.id;
            });
          },
          isExpanded: true,
          hint: Row(
            children: [
              Text(
                AppStrings.selectFromPrev.tr(),
                style: TextStyle(
                    color: ColorManager.primary, fontSize: AppSize.s14.sp),
              ),
              SizedBox(
                width: AppConstants.smallDistance,
              )
            ],
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: ColorManager.primary,
            size: AppSize.s20.sp,
          ),
          style:
              TextStyle(color: ColorManager.primary, fontSize: AppSize.s14.sp),
        ),
        padding: const EdgeInsets.fromLTRB(
            AppPadding.p15, AppPadding.p2, AppPadding.p5, AppPadding.p2),
        height: widget.deviceWidth <= 600 ? 44.h : 47.h,
        borderColor: ColorManager.primary,
        borderWidth: widget.deviceWidth <= 600 ? 1.5.w : 0.5.w,
        borderRadius: AppSize.s5);
  }

  Widget fabrics(BuildContext context) {
    return Expanded(
      flex: 1,
      child: containerComponent(
          context,
          padding: const EdgeInsets.all(AppPadding.p2),
          Column(
            children: [
              SizedBox(
                height: widget.deviceWidth <= 600 ? 150.h : 90.h,
                width: widget.deviceWidth <= 600 ? 300.w : 190.w,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  scrollDirection: widget.deviceWidth <= 600 ? Axis.vertical : Axis.horizontal,
                  itemCount: fabricDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(AppPadding.p5),
                      child: Bounceable(
                        duration: Duration(
                            milliseconds: AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds: AppConstants.durationOfBounceable));

                          isSelected(fabricDetails[index].id!);
                        },
                        child: containerComponent(
                            context,
                            Column(
                              children: [
                                Container(
                                  height: widget.deviceWidth <= 600 ? 70.h : 59.h,
                                  width: widget.deviceWidth <= 600 ? 170.w : 45.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(AppSize.s5),
                                          topRight:
                                              Radius.circular(AppSize.s5)),
                                      image: fabricDetails[index]
                                                  .itemImage
                                                  .toString() ==
                                              'n'
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                  ImageAssets.noItem),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  fabricDetails[index]
                                                      .itemImage
                                                      .toString()),
                                              fit: BoxFit.cover)),
                                ),
                                Container(
                                  height: widget.deviceWidth <= 600 ? 35.h : 18.h,
                                  width: widget.deviceWidth <= 600 ? 170.w : 45.w,
                                  decoration: BoxDecoration(
                                      color: ColorManager.badge,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft:
                                              Radius.circular(AppSize.s5),
                                          bottomRight:
                                              Radius.circular(AppSize.s5))),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fabricDetails[index]
                                              .itemName
                                              .toString(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontSize: AppSize.s12.sp),
                                        ),
                                        SizedBox(
                                            width:
                                                AppConstants.smallerDistance),
                                        Text(
                                          '-',
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontSize: AppSize.s12.sp),
                                        ),
                                        SizedBox(
                                            width:
                                                AppConstants.smallerDistance),
                                        Text(
                                          fabricDetails[index]
                                              .itemPrice
                                              .toString(),
                                          style: TextStyle(
                                              color: ColorManager.white,
                                              fontSize: AppSize.s12.sp),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height: widget.deviceWidth <= 600 ? 110.h : 50.h,
                            color: ColorManager.white,
                            borderColor: fabricDetails[index].selected!
                                ? ColorManager.primary
                                : ColorManager.secondary,
                            borderWidth: 0.5.w,
                            borderRadius: AppSize.s5),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          height: 120.h,
          color: ColorManager.white,
          borderColor: ColorManager.badge,
          borderWidth: 0.5.w,
          borderRadius: AppSize.s5),
    );
  }

  Widget buttons(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              closeButton(context),
              SizedBox(
                width: AppConstants.widthBetweenElements,
              ),
              Bounceable(
                duration:
                    Duration(milliseconds: AppConstants.durationOfBounceable),
                onTap: () async {
                  await Future.delayed(Duration(
                      milliseconds: AppConstants.durationOfBounceable));

                  saveTailoring(context);
                },
                child: containerComponent(
                    context,
                    Center(
                        child: Text(
                      AppStrings.save.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                    height: widget.deviceWidth <= 600 ? 40.h : 30.h,
                    width: widget.deviceWidth <= 600 ? 120 : 50.w,
                    color: ColorManager.primary,
                    borderColor: ColorManager.primary,
                    borderWidth: 0.6.w,
                    borderRadius: AppSize.s5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveTailoring(BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    if (selectedFabrics.isEmpty) {
      CustomDialog.show(
          context,
          AppStrings.selectFabricFirst.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
    }
    if (_sizeNameEditingController.text == "") {
      CustomDialog.show(
          context,
          AppStrings.sizeNameRequired.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
      return;
    }

    for (var n in _sizesControllers) {
      if (n.text == '') {
        CustomDialog.show(
            context,
            AppStrings.inputsRequired.tr(),
            const Icon(Icons.warning_amber_rounded),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.hold);
        return;
      }
    }

    setState(() {
      listOfTmpOrder.add(TmpOrderModel(
          productId: widget.selectedListName[widget.itemIndex].id,
          variationId: 0,
          id: widget.selectedListName[widget.itemIndex].id,
          itemName: widget.selectedListName[widget.itemIndex].name,
          itemQuantity: 1,
          itemAmount: calcTotal.toString(),
          itemPrice: calcTotal.toString(),
          customer: widget.selectedCustomer,
          category:
              widget.selectedListName[widget.itemIndex].categoryId.toString(),
          orderDiscount: widget.discount,
          brand: widget.selectedListName[widget.itemIndex].brandId.toString(),
          customerTel: widget.selectedCustomerTel,
          date: today.toString().split(" ")[0],
          itemOption: '',
          productType: widget.selectedListName[widget.itemIndex].type));
    });

    TailorDialog.hide(context);
  }
}
