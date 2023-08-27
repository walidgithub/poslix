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

import '../../../../../domain/response/customer_model.dart';
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
import 'widgets/main_note.dart';

class TailorDialog extends StatefulWidget {
  int itemIndex;
  String currencyCode;
  var selectedListName;
  List<CustomerResponse> listOfCustomers;
  List<TailoringTypesModel> listOfTailoringTypes;
  List listOfFabrics;
  double? discount;

  static void show(
          BuildContext context,
          String currencyCode,
          int itemIndex,
          var selectedListName,
          List<TailoringTypesModel> listOfTailoringTypes,
          List listOfFabrics,
          List<CustomerResponse> listOfCustomers,
          double discount) =>
      isApple()
          ? showCupertinoDialog<void>(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (_) => TailorDialog(
                  currencyCode: currencyCode,
                  itemIndex: itemIndex,
                  selectedListName: selectedListName,
                  listOfTailoringTypes: listOfTailoringTypes,
                  listOfFabrics: listOfFabrics,
                  listOfCustomers: listOfCustomers,
                  discount: discount))
          : showDialog<void>(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (_) => TailorDialog(
                  currencyCode: currencyCode,
                  itemIndex: itemIndex,
                  selectedListName: selectedListName,
                  listOfTailoringTypes: listOfTailoringTypes,
                  listOfFabrics: listOfFabrics,
                  listOfCustomers: listOfCustomers,
                  discount: discount),
            ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  TailorDialog(
      {required this.currencyCode,
      required this.itemIndex,
      required this.selectedListName,
      required this.listOfTailoringTypes,
      required this.listOfFabrics,
      required this.listOfCustomers,
      required this.discount,
      super.key});

  @override
  State<TailorDialog> createState() => _TailorDialogState();
}

class _TailorDialogState extends State<TailorDialog> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  final TextEditingController _notesEditingController = TextEditingController();
  final TextEditingController _sizeNameEditingController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<TextEditingController> _tailoringTypesControllers = [];

  CustomerResponse? _selectedCustomer;

  List<FabricsModel> fabricDetails = [];

  String? _selectedCustomerName;

  int? _selectedCustomerId;

  DateTime today = DateTime.now();

  int decimalPlaces = 2;

  double dialogWidth = 200.w;

  @override
  void initState() {
    for (int i = 0; i < widget.listOfTailoringTypes.length; i++) {
      _tailoringTypesControllers.add(TextEditingController());
    }

    for (var nToId in widget.listOfFabrics) {
      if (nToId != '') {
        for (var nToImage in widget.selectedListName) {
          if (nToId.toString() == nToImage.id.toString()) {
            fabricDetails.add(FabricsModel(
                id: nToId, itemImage: nToImage.image, itemName: nToImage.name));
          }
        }
      }
    }

    print('hereeeee');
    print(widget.listOfTailoringTypes.length);

    getDecimalPlaces();
    super.initState();
  }

  @override
  void dispose() {
    _notesEditingController.dispose();
    _sizeNameEditingController.dispose();

    for (var controller in _tailoringTypesControllers) {
      controller.dispose();
    }
    super.dispose();
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
                    height: 580.h,
                    width: dialogWidth,
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(AppSize.s5),
                        boxShadow: [BoxShadow(color: ColorManager.badge)]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppPadding.p20,
                          AppPadding.p20, AppPadding.p20, AppPadding.p10),
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
                            height: AppConstants.smallDistance,
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
                              height: 120.h,
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
                            height: AppConstants.smallerDistance,
                          ),

                          total(context),

                          SizedBox(
                            height: AppConstants.smallerDistance,
                          ),

                          const Divider(
                            thickness: AppSize.s1,
                          ),

                          buttons(context)
                        ],
                      ),
                    )))));
  }

  Widget tailoringTypesFields(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: GridView.count(
          controller: _scrollController,
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
          childAspectRatio: 6 / 2,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(widget.listOfTailoringTypes.length, (index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppPadding.p0, AppPadding.p5, AppPadding.p5, AppPadding.p5),
              child: TextField(
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  controller: _tailoringTypesControllers[index],
                  decoration: InputDecoration(
                      hintText: widget.listOfTailoringTypes[index].name.toString(),
                      hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                      labelText: widget.listOfTailoringTypes[index].name.toString(),
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
        height: 47.h,
        borderColor: ColorManager.primary,
        borderWidth: 0.5.w,
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
                height: 90.h,
                width: 190.w,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
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
                        },
                        child: containerComponent(
                            context,
                            Column(
                              children: [
                                Container(
                                  height: 60.h,
                                  width: ((200.w - 25.w) / fabricDetails.length)
                                      .ceilToDouble(),
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
                                              fit: BoxFit.contain)),
                                ),
                                Container(
                                  height: 20.h,
                                  width: ((200.w - 25.w) / fabricDetails.length)
                                      .ceilToDouble(),
                                  decoration: BoxDecoration(
                                      color: ColorManager.badge,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft:
                                              Radius.circular(AppSize.s5),
                                          bottomRight:
                                              Radius.circular(AppSize.s5))),
                                  child: Center(
                                    child: Text(
                                      fabricDetails[index].itemName.toString(),
                                      style: TextStyle(
                                          color: ColorManager.white,
                                          fontSize: AppSize.s10.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height: 50.h,
                            color: ColorManager.white,
                            borderColor: ColorManager.primary,
                            borderWidth: 0.0.w,
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
                },
                child: containerComponent(
                    context,
                    Center(
                        child: Text(
                      AppStrings.save.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                    height: 30.h,
                    width: 50.w,
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
}
