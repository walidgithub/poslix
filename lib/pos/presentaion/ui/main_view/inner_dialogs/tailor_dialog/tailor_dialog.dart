import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/tailor_dialog/size_name_Section.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/tailor_dialog/total_section.dart';

import '../../../../../domain/response/customer_model.dart';
import '../../../../../shared/constant/assets_manager.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/preferences/app_pref.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../di/di.dart';
import '../../../components/close_button.dart';
import '../../../components/container_component.dart';
import 'main_note.dart';

class TailorDialog extends StatefulWidget {
  int itemIndex;
  String currencyCode;
  String selectedCustomerTel;
  var selectedListName;
  String selectedCustomer;
  // List<CustomerResponse> listOfCustomers;
  List listOfChoices;
  List listOfFabrics;
  double? discount;

  static void show(
          BuildContext context,
          String currencyCode,
          int itemIndex,
          var selectedListName,
          String selectedCustomerTel,
          // List<CustomerResponse> listOfCustomers,
          List listOfChoices,
          List listOfFabrics,
          String selectedCustomer,
          double discount) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => TailorDialog(
            currencyCode: currencyCode,
            itemIndex: itemIndex,
            selectedCustomerTel: selectedCustomerTel,
            selectedListName: selectedListName,
            listOfChoices: listOfChoices,
            listOfFabrics: listOfFabrics,
            // listOfCustomers: listOfCustomers,
            selectedCustomer: selectedCustomer,
            discount: discount),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  TailorDialog(
      {required this.currencyCode,
      required this.itemIndex,
      required this.selectedListName,
      // required this.listOfCustomers,
      required this.selectedCustomerTel,
      required this.selectedCustomer,
      required this.listOfChoices,
      required this.listOfFabrics,
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

  final List<TextEditingController> _choicesControllers = [];

  DateTime today = DateTime.now();

  int decimalPlaces = 2;

  CustomerResponse? _selectedCustomer;
  String? _selectedCustomerName;

  int? _selectedCustomerId;
  String? _selectedCustomerTel;

  double dialogWidth = 200.w;

  @override
  void initState() {
    for (int i = 0; i < widget.listOfChoices.length; i++) {
      _choicesControllers.add(TextEditingController());
    }

    getDecimalPlaces();
    super.initState();
  }

  @override
  void dispose() {
    _notesEditingController.dispose();
    _sizeNameEditingController.dispose();

    for (var controller in _choicesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getLocationId(PREFS_KEY_DECIMAL_PLACES)!;
  }

  double roundDouble(double value, int places) {
    String roundedNumber = value.toStringAsFixed(places);
    return double.parse(roundedNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    height: 550.h,
                    width: dialogWidth,
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
                          // customerDropDown(context),
                          // -----------------------------------------------------------

                          // Choices Fields
                          containerComponent(
                              context,
                              Column(
                                children: [
                                  choicesFields(context),
                                ],
                              ),
                              height: 120.h,
                              color: ColorManager.white,
                              borderColor: ColorManager.white,
                              borderWidth: 0.w,
                              borderRadius: AppSize.s5),

                          SizedBox(
                            height: AppConstants.smallDistance,
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

  Widget choicesFields(BuildContext context) {
    return Expanded(
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 2,
            childAspectRatio: 4 / 1,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(widget.listOfChoices.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: AppPadding.p5),
                child: TextField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    controller: _choicesControllers[index],
                    decoration: InputDecoration(
                        hintText: widget.listOfChoices[index].toString(),
                        hintStyle: TextStyle(fontSize: AppSize.s12.sp),
                        labelText: widget.listOfChoices[index].toString(),
                        labelStyle: TextStyle(
                            fontSize: AppSize.s15.sp,
                            color: ColorManager.primary),
                        border: InputBorder.none)),
              );
            })));
  }

  // Widget customerDropDown(BuildContext context) {
  //   return Expanded(
  //       flex: 3,
  //       child: containerComponent(
  //           context,
  //           DropdownButton(
  //             borderRadius: BorderRadius.circular(AppSize.s5),
  //             itemHeight: 50.h,
  //             underline: Container(),
  //             value: _selectedCustomer,
  //             items: widget.listOfCustomers.map((item) {
  //               return DropdownMenuItem(
  //                   value: item,
  //                   child: Row(
  //                     children: [
  //                       Text(item.firstName,
  //                           style: TextStyle(
  //                               color: ColorManager.primary,
  //                               fontSize: AppSize.s14.sp)),
  //                       SizedBox(width: AppConstants.smallerDistance),
  //                       Text(item.lastName,
  //                           style: TextStyle(
  //                               color: ColorManager.primary,
  //                               fontSize: AppSize.s14.sp)),
  //                       Row(
  //                         children: [
  //                           SizedBox(width: AppConstants.smallerDistance),
  //                           Text('|',
  //                               style: TextStyle(
  //                                   color: ColorManager.primary,
  //                                   fontSize: AppSize.s14.sp)),
  //                           SizedBox(width: AppConstants.smallerDistance),
  //                           Text(item.mobile,
  //                               style: TextStyle(
  //                                   color: ColorManager.primary,
  //                                   fontSize: AppSize.s14.sp))
  //                         ],
  //                       ),
  //                     ],
  //                   ));
  //             }).toList(),
  //             onChanged: (selectedCustomer) {
  //               setState(() {
  //                 _selectedCustomer = selectedCustomer;
  //                 _selectedCustomerName =
  //                     '${selectedCustomer?.firstName} ${selectedCustomer?.lastName}';
  //                 _selectedCustomerId = selectedCustomer?.id;
  //                 _selectedCustomerTel = selectedCustomer?.mobile;
  //               });
  //             },
  //             isExpanded: true,
  //             hint: Row(
  //               children: [
  //                 Text(
  //                   AppStrings.selectFromPrev.tr(),
  //                   style: TextStyle(
  //                       color: ColorManager.primary, fontSize: AppSize.s14.sp),
  //                 ),
  //                 SizedBox(
  //                   width: AppConstants.smallDistance,
  //                 )
  //               ],
  //             ),
  //             icon: Icon(
  //               Icons.arrow_drop_down,
  //               color: ColorManager.primary,
  //               size: AppSize.s20.sp,
  //             ),
  //             style: TextStyle(
  //                 color: ColorManager.primary, fontSize: AppSize.s14.sp),
  //           ),
  //           padding: const EdgeInsets.fromLTRB(
  //               AppPadding.p15, AppPadding.p2, AppPadding.p5, AppPadding.p2),
  //           height: 47.h,
  //           borderColor: ColorManager.primary,
  //           borderWidth: 0.5.w,
  //           borderRadius: AppSize.s5));
  // }

  Widget fabrics(BuildContext context) {
    return Expanded(
      flex: 1,
      child: containerComponent(
          context,
          padding: const EdgeInsets.all(AppPadding.p2),
          Column(
            children: [
              SizedBox(
                height: 103.h,
                width: 190.w,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.listOfFabrics.length,
                  itemBuilder:
                      (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(AppPadding.p5),
                      child: Bounceable(
                        duration: Duration(
                            milliseconds: AppConstants
                                .durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds: AppConstants
                                  .durationOfBounceable));
                        },
                        child: containerComponent(context,
                            Column(
                              children: [
                                Container(
                                  height: 70.h,
                                  width: ((200.w - 25.w) /widget.listOfFabrics.length).ceilToDouble(),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(AppSize.s5),
                                          topRight: Radius.circular(AppSize.s5)),
                                      image: widget.listOfFabrics[index]['image'].toString() == 'n'
                                          ? const DecorationImage(
                                          image: AssetImage(ImageAssets.noItem), fit: BoxFit.fill)
                                          : DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              widget.listOfFabrics[index]['image'].toString()),
                                          fit: BoxFit.fill)),
                                ),
                                Container(
                                  height: 23.h,
                                  width: ((200.w - 25.w)/widget.listOfFabrics.length).ceilToDouble(),
                                  decoration: BoxDecoration(
                                      color: ColorManager.badge,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(AppSize.s5),
                                          bottomRight: Radius.circular(AppSize.s5))),
                                  child: Center(
                                    child: Text(
                                      widget.listOfFabrics[index]['name'].toString(),
                                      style: TextStyle(
                                          color: ColorManager.white, fontSize: AppSize.s10.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height: 50.h,
                            color: ColorManager.white,
                            borderColor:
                            ColorManager.primary,
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
                  await Future.delayed(
                      Duration(milliseconds: AppConstants.durationOfBounceable));
                },
                child: containerComponent(
                    context,
                    Center(
                        child: Text(
                          AppStrings.save.tr(),
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: AppSize.s14.sp),
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
