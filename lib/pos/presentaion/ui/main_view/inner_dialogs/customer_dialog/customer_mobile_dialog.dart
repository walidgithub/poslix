import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_cubit.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
import '../../../../../domain/requests/customer_model.dart';
import '../../../../../domain/response/customer_model.dart';
import '../../../../../domain/response/pricing_group_model.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../di/di.dart';
import '../../../components/close_button.dart';
import '../../../components/container_component.dart';
import '../../../popup_dialogs/custom_dialog.dart';
import '../../main_view_cubit/main_view_state.dart';
import 'widgets/custom_text_form_field.dart';

class CustomerMobileDialog extends StatefulWidget {
  String editType;
  var customerData;
  int locationId;
  int customerId;
  Function done;
  List<PricingGroupResponse> listOfPricingGroups = [];

  static void show(BuildContext context, String editType, var customerData,
      int customerId, int locationId, Function done, List<PricingGroupResponse> listOfPricingGroups) =>
      isApple() ? showCupertinoDialog<void>(context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (_) => CustomerMobileDialog(
              editType: editType,
              customerData: customerData,
              customerId: customerId,
              locationId: locationId,
              done: done,
              listOfPricingGroups: listOfPricingGroups
          )).then((_) => FocusScope.of(context).requestFocus(FocusNode())) :
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => CustomerMobileDialog(
            editType: editType,
            customerData: customerData,
            customerId: customerId,
            locationId: locationId,
            done: done,
          listOfPricingGroups: listOfPricingGroups,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  CustomerMobileDialog(
      {required this.editType,
        required this.customerData,
        required this.customerId,
        required this.locationId,
        required this.done,
        required this.listOfPricingGroups,
        super.key});

  @override
  State<CustomerMobileDialog> createState() => _CustomerMobileDialogState();
}

class _CustomerMobileDialogState extends State<CustomerMobileDialog> {

  final TextEditingController _firstNameEditingController =
  TextEditingController();
  final TextEditingController _lastNameEditingController =
  TextEditingController();
  final TextEditingController _mobileEditingController =
  TextEditingController();
  final TextEditingController _addressOneEditingController =
  TextEditingController();
  final TextEditingController _addressTwoEditingController =
  TextEditingController();
  final TextEditingController _cityEditingController = TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _countryEditingController =
  TextEditingController();
  final TextEditingController _zipCodeEditingController =
  TextEditingController();
  final TextEditingController _shippingAddressEditingController =
  TextEditingController();

  final FocusNode _fNameFN = FocusNode();
  final FocusNode _lNameFN = FocusNode();
  final FocusNode _mobileFN = FocusNode();
  final FocusNode _addressOneFN = FocusNode();
  final FocusNode _addressTwoFN = FocusNode();
  final FocusNode _cityFN = FocusNode();
  final FocusNode _stateFN = FocusNode();
  final FocusNode _countryFN = FocusNode();
  final FocusNode _zipCodeFN = FocusNode();
  final FocusNode _shippingFN = FocusNode();

  final _fbKey = GlobalKey<FormState>();
  List<PricingGroupResponse> pricingGroupList = [];
  int? pricingGroupId;
  var _selectedPricingGroup;

  bool? moreInfo;

  @override
  void initState() {
    moreInfo = false;
    if (widget.editType == 'Edit') {
      _firstNameEditingController.text = widget.customerData.firstName;
      _lastNameEditingController.text = widget.customerData.lastName;
      _mobileEditingController.text = widget.customerData.mobile;
      _addressOneEditingController.text = widget.customerData.addressLine_1;
      _addressTwoEditingController.text = widget.customerData.addressLine_2;
      _cityEditingController.text = widget.customerData.city;
      _stateEditingController.text = widget.customerData.state;
      _countryEditingController.text = widget.customerData.country;
      _zipCodeEditingController.text = widget.customerData.zipCode;
      _shippingAddressEditingController.text =
          widget.customerData.shippingAddress;
      pricingGroupId =
          widget.customerData.priceGroupsId;
      if (pricingGroupId != null) {
        _selectedPricingGroup = widget.listOfPricingGroups.firstWhere((element) => element.id == pricingGroupId);
      }
    }
    pricingGroupList = widget.listOfPricingGroups;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _mobileEditingController.dispose();
    _addressOneEditingController.dispose();
    _addressTwoEditingController.dispose();
    _cityEditingController.dispose();
    _stateEditingController.dispose();
    _countryEditingController.dispose();
    _zipCodeEditingController.dispose();
    _shippingAddressEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainViewCubit>(),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is CustomerAddedSucceed) {
            widget.done('done');
          } else if (state is CustomerUpdatedSucceed) {
            CustomDialog.show(
                context,
                AppStrings.customerUpdatedSuccessfully.tr(),
                const Icon(Icons.check),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.success);

            await Future.delayed(
                Duration(milliseconds: AppConstants.durationOfSnackBar));

            widget.done('done');

            CustomerMobileDialog.hide(context);
          } else if (state is CustomerUpdateError) {
            CustomDialog.show(
                context,
                AppStrings.customerUpdatedError.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          } else if (state is CustomerAddError) {
            CustomDialog.show(
                context,
                AppStrings.customerAddError.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 350.w,
                height: moreInfo! ? 600.h : 400.h,
                decoration: BoxDecoration(
                    color: ColorManager.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(AppSize.s5),
                    boxShadow: [BoxShadow(color: ColorManager.badge)]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Form(
                        key: _fbKey,
                        child:
                        Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    widget.editType == 'Add'
                                        ? AppStrings.addCustomer.tr()
                                        : AppStrings.editCustomer.tr(),
                                    style: TextStyle(
                                        color: ColorManager.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSize.s18.sp),
                                  ),
                                ),
                                requiredFields(context),
                                SizedBox(
                                  height: AppConstants.smallWidthBetweenElements,
                                ),
                                choosePricingGroup(context),
                                SizedBox(
                                  height: AppConstants.smallWidthBetweenElements,
                                ),
                                moreAndLessInfo(),
                                SizedBox(
                                  height: AppConstants.smallWidthBetweenElements,
                                ),
                                moreInfo! ? optionalFields(context) : Container()
                              ],
                            ),
                            SizedBox(
                              height: AppConstants.smallWidthBetweenElements,
                            ),
                            buttons(context)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget requiredFields(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppConstants.smallWidthBetweenElements,
        ),
        customTextFormField(context, _fNameFN, _firstNameEditingController,
            AppStrings.first_name.tr(), AppStrings.first_name.tr(), TextInputType.text,
            nextFN: _lNameFN,
            validateText: AppStrings.firstNameFieldIsRequired.tr()),
        SizedBox(
          height: AppConstants.smallWidthBetweenElements,
        ),
        customTextFormField(context, _lNameFN, _lastNameEditingController,
            AppStrings.lastName.tr(), AppStrings.lastName.tr(), TextInputType.text,
            nextFN: _mobileFN,
            validateText: AppStrings.lastNameFieldIsRequired.tr()),
        SizedBox(
          height: AppConstants.smallWidthBetweenElements,
        ),
        customTextFormField(context, _mobileFN, _mobileEditingController,
            AppStrings.mobile.tr(), AppStrings.mobile.tr(), TextInputType.number,
            nextFN: _addressOneFN,
            validateText: AppStrings.mobileFieldIsRequired.tr()),
      ],
    );
  }

  Widget choosePricingGroup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(AppStrings.choosePricingGroup.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s18.sp,
                      color: ColorManager.primary,
                      fontWeight: FontWeight.w500
                          ))),
          SizedBox(
            height: AppConstants.smallDistance,
          ),
          DropdownButton2(
            buttonStyleData: ButtonStyleData(
              height: 47.h,
              width: MediaQuery.of(context).size.width,
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
            items: pricingGroupList.map((item) {
              return DropdownMenuItem(
                  value: item.name,
                  child: Text(item.name,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedGroup) {
              _selectedPricingGroup = selectedGroup;
              pricingGroupId = pricingGroupList.firstWhere((element) => element.name == _selectedPricingGroup).id;
              setState(() {
              });
            },
            value: pricingGroupId != null ? pricingGroupList.firstWhere((element) => element.id == pricingGroupId).name : _selectedPricingGroup,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.choosePricingGroup.tr(),
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

  Widget moreAndLessInfo() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Bounceable(
        duration: Duration(milliseconds: AppConstants.durationOfBounceable),
        onTap: () async {
          await Future.delayed(
              Duration(milliseconds: AppConstants.durationOfBounceable));
          setState(() {
            moreInfo = !moreInfo!;
          });
        },
        child: containerComponent(
            context,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                    child: Text(
                      moreInfo!
                          ? AppStrings.lessInformation.tr()
                          : AppStrings.moreInformation.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                Icon(
                  moreInfo! ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: AppSize.s20.sp,
                  color: ColorManager.white,
                )
              ],
            ),
            height: 40.h,
            width: 150.w,
            padding: const EdgeInsets.all(AppPadding.p5),
            color: ColorManager.primary,
            borderRadius: AppSize.s5,
            borderColor: ColorManager.primary,
            borderWidth: 0.6.w),
      ),
    );
  }

  Widget optionalFields(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            customTextFormField(context,
                _addressOneFN,
                _addressOneEditingController,
                AppStrings.addressLine1.tr(),
                AppStrings.addressLine1.tr(), TextInputType.text,
                nextFN: _addressTwoFN),
            SizedBox(
              height: AppConstants.smallWidthBetweenElements,
            ),
            customTextFormField(context,
                _addressTwoFN,
                _addressTwoEditingController,
                AppStrings.addressLine2.tr(),
                AppStrings.addressLine2.tr(), TextInputType.text,
                nextFN: _cityFN)
          ],
        ),
        SizedBox(
          height: AppConstants.smallWidthBetweenElements,
        ),
        Column(
          children: [
            customTextFormField(context, _cityFN, _cityEditingController,
                AppStrings.city.tr(), AppStrings.city.tr(), TextInputType.text,
                nextFN: _stateFN),
            SizedBox(
              height: AppConstants.smallWidthBetweenElements,
            ),
            customTextFormField(context, _stateFN, _stateEditingController,
                AppStrings.state.tr(), AppStrings.state.tr(), TextInputType.text,
                nextFN: _countryFN),
            SizedBox(
              height: AppConstants.smallWidthBetweenElements,
            ),
            customTextFormField(context,
                _countryFN,
                _countryEditingController,
                AppStrings.country.tr(),
                AppStrings.country.tr(), TextInputType.text,
                nextFN: _zipCodeFN),
            SizedBox(
              height: AppConstants.smallWidthBetweenElements,
            ),
            customTextFormField(context,
                _zipCodeFN,
                _zipCodeEditingController,
                AppStrings.zipCode.tr(),
                AppStrings.zipCode.tr(), TextInputType.number,
                nextFN: _shippingFN),
          ],
        ),
        Divider(
          color: ColorManager.primary,
        ),
        customTextFormField(context, _shippingFN, _shippingAddressEditingController,
          AppStrings.shippingAddress.tr(), AppStrings.shippingAddress.tr(), TextInputType.text,),
      ],
    );
  }

  Widget buttons(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
              _fbKey.currentState!.validate();

              if (widget.editType == 'Add') {
                CustomerRequest customerModel = CustomerRequest(
                    address_line_1: _addressOneEditingController.text,
                    address_line_2: _addressTwoEditingController.text,
                    city: _cityEditingController.text,
                    country: _countryEditingController.text,
                    first_name: _firstNameEditingController.text,
                    last_name: _lastNameEditingController.text,
                    mobile: int.parse(_mobileEditingController.text),
                    shipping_address: _shippingAddressEditingController.text,
                    state: _stateEditingController.text,
                    zip_code: _zipCodeEditingController.text,
                    priceGroupsId: pricingGroupList.last.id == 0 ? pricingGroupId = null : pricingGroupId);
                MainViewCubit.get(context)
                    .addCustomer(customerModel, widget.locationId);

                widget.done('done');
              } else if (widget.editType == 'Edit') {
                CustomerRequest customerModel = CustomerRequest(
                    address_line_1: _addressOneEditingController.text,
                    address_line_2: _addressTwoEditingController.text,
                    city: _cityEditingController.text,
                    country: _countryEditingController.text,
                    first_name: _firstNameEditingController.text,
                    last_name: _lastNameEditingController.text,
                    mobile: int.parse(_mobileEditingController.text),
                    shipping_address: _shippingAddressEditingController.text,
                    state: _stateEditingController.text,
                    zip_code: _zipCodeEditingController.text,
                    priceGroupsId: pricingGroupList.last.id == 0 ? pricingGroupId = null : pricingGroupId);
                MainViewCubit.get(context)
                    .updateCustomer(widget.customerId, customerModel);
              }
            },
            child: containerComponent(
                context,
                Center(
                    child: Text(
                      widget.editType == 'Add'
                          ? AppStrings.addCustomer.tr()
                          : AppStrings.editCustomer.tr(),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: AppSize.s14.sp),
                    )),
                height: 40.h,
                width: 150.w,
                color: ColorManager.primary,
                borderRadius: AppSize.s5,
                borderColor: ColorManager.primary,
                borderWidth: 0.6.w),
          )
        ],
      ),
    );
  }
}
