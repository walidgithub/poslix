import 'dart:convert';

import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:poslix_app/pos/domain/requests/open_register_model.dart';
import 'package:poslix_app/pos/domain/response/taxes_model.dart';
import 'package:poslix_app/pos/presentaion/ui/login_view/login_cubit/login_cubit.dart';
import 'package:poslix_app/pos/presentaion/ui/register_pos_view/register_pos_cubit/register_pos_cubit.dart';
import 'package:poslix_app/pos/presentaion/ui/register_pos_view/register_pos_cubit/register_pos_state.dart';
import 'package:poslix_app/pos/presentaion/ui/register_pos_view/widgets/initial_value.dart';
import 'package:poslix_app/pos/shared/constant/strings_manager.dart';
import 'package:poslix_app/pos/shared/preferences/app_pref.dart';
import '../../../domain/requests/close_register_report_model.dart';
import '../../../domain/response/business_model.dart';
import '../../../domain/response/locations_model.dart';
import '../../../domain/response/user_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/constant_values_manager.dart';
import '../../../shared/constant/language_manager.dart';
import '../../../shared/constant/padding_margin_values_manager.dart';
import '../../../shared/style/colors_manager.dart';
import '../../../shared/utils/utils.dart';
import '../../di/di.dart';
import '../../router/app_router.dart';
import '../components/container_component.dart';
import '../login_view/login_cubit/login_state.dart';
import '../login_view/widgets/left_part.dart';
import '../popup_dialogs/custom_dialog.dart';
import '../popup_dialogs/loading_dialog.dart';

class RegisterPosView extends StatefulWidget {
  const RegisterPosView({Key? key}) : super(key: key);

  @override
  State<RegisterPosView> createState() => _RegisterPosViewState();
}

class _RegisterPosViewState extends State<RegisterPosView> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  final GlobalKey<AnimatedFloatingActionButtonState> floatingKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  TextEditingController posInitialEditingController = TextEditingController();

  List<BusinessResponse> listOfBusinesses = [];
  List<LocationsResponse> listOfLocations = [];
  List<TaxesResponse> listOfTaxes = [];

  var _selectedBusiness;
  var _selectedLocation;
  int? locationId;
  int? oldLocationId;
  String? businessType;
  String? userInfo;
  int? decimalPlaces;
  int? tax;

  int? cashInHand;
  bool? registeredBefore;

  bool keyPadOn = false;

  UserResponse? userResponse;

  @override
  void initState() {
    cashInHand = 0;

    getLocationId();
    getUserInfo();

    super.initState();
  }

  void getLocationId() async {
    oldLocationId = _appPreferences.getLocationId(PREFS_KEY_LOCATION_ID)!;
  }

  void getUserInfo() async {
    userInfo = _appPreferences.getUserInfo(PREFS_KEY_USER_INFO)!;
    userResponse = UserResponse.fromJson(jsonDecode(userInfo!));
  }

  void reload() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  @override
  void dispose() {
    posInitialEditingController.dispose();
    super.dispose();
  }

  double? deviceWidth;

  Widget language() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _changeLanguage();
        });
      },
      tooltip: AppStrings.language.tr(),
      backgroundColor: ColorManager.primary,
      child: SvgPicture.asset(
        ImageAssets.language,
        width: AppSize.s25,
        color: ColorManager.white,
      ),
    );
  }

  Widget logout() {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LogoutSucceed) {
          } else if (state is LogoutFailed) {}
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              LoginCubit.get(context).logout();
              _appPreferences.logout();
              Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
            },
            tooltip: AppStrings.logout.tr(),
            backgroundColor: ColorManager.primary,
            child: SvgPicture.asset(
              ImageAssets.logout,
              width: AppSize.s25,
              color: ColorManager.white,
            ),
          );
        },
      ),
    );
  }

  Widget refresh() {
    return FloatingActionButton(
      onPressed: () {
        reload();
      },
      tooltip: AppStrings.reload.tr(),
      backgroundColor: ColorManager.primary,
      child: SvgPicture.asset(
        ImageAssets.reload,
        width: AppSize.s25,
        color: ColorManager.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = getDeviceWidth(context);
    return WillPopScope(
      onWillPop: () => isApple()
          ? onBackButtonPressedInIOS(context)
          : onBackButtonPressed(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
            child: Scaffold(
          backgroundColor: ColorManager.secondary,
          body: KeyboardVisibility(
              onChanged: (bool visible) {
                setState(() {
                  keyPadOn = visible;
                });
              },
              child: bodyContent()),
          floatingActionButton: AnimatedFloatingActionButton(
              fabButtons: <Widget>[language(), logout(), refresh()],
              key: floatingKey,
              colorStartAnimation: ColorManager.primary,
              colorEndAnimation: ColorManager.delete,
              animatedIconData: AnimatedIcons.menu_close //To principal button
              ),
        )),
      ),
    );
  }

  Widget bodyContent() {
    return BlocProvider(
      create: (context) => sl<RegisterPOSCubit>()..getBusiness(),
      child: BlocConsumer<RegisterPOSCubit, RegisterPOSState>(
        listener: (context, state) async {
          if (state is RegisterNoInternetState) {
            showNoInternet(context);
          }

          if (state is RegisterPOSLoading) {
            LoadingDialog.show(context);
          } else if (state is RegisterPOSLoaded) {
            LoadingDialog.hide(context);
            listOfBusinesses = RegisterPOSCubit.get(context).listOfBusinesses;
            listOfLocations = RegisterPOSCubit.get(context).listOfLocations;
            _selectedBusiness = listOfBusinesses[0].name;
            _selectedLocation = listOfLocations[0].locationName;
            locationId = listOfLocations[0].locationId;
            businessType = listOfBusinesses[0].type;
            decimalPlaces = listOfLocations[0].locationDecimalPlaces;

            _appPreferences.setLocationId(PREFS_KEY_LOCATION_ID, locationId!);

            _appPreferences.setDecimalPlaces(
                PREFS_KEY_DECIMAL_PLACES, decimalPlaces!);

            _appPreferences.setBusinessType(
                PREFS_KEY_BUSINESS_TYPE, businessType!);

            RegisterPOSCubit.get(context).openCloseRegister(
                CloseRegisterReportRequest(today: true), locationId!);

            RegisterPOSCubit.get(context).getTaxes(locationId!);
          } else if (state is RegisterPOSLoadingFailed) {
            LoadingDialog.hide(context);

            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }

          if (state is OpenCloseRegisterSucceed) {
            cashInHand = RegisterPOSCubit.get(context).cashInHand;
            posInitialEditingController.text = cashInHand.toString();
            registeredBefore = RegisterPOSCubit.get(context).registeredBefore;
          } else if (state is OpenCloseRegisterError) {
            posInitialEditingController.text = '0';
            registeredBefore = false;
          }

          if (state is TaxesLoaded) {
            listOfTaxes = RegisterPOSCubit.get(context).listOfTaxes;
            for (var n in listOfTaxes) {
              if (n.isTaxGroup == 1) {
                if (n.taxGroup.isNotEmpty) {
                  if (n.isPrimary == 1) {
                    tax = n.taxGroup[0].amount;
                    _appPreferences.setTaxValue(PREFS_KEY_TAX_VALUE, tax!);
                  }
                } else {
                  tax = 0;
                  _appPreferences.setTaxValue(PREFS_KEY_TAX_VALUE, tax!);
                }
              } else {
                tax = 0;
                _appPreferences.setTaxValue(PREFS_KEY_TAX_VALUE, tax!);
              }
            }
          } else if (state is TaxesLoadingFailed) {}

          if (state is OpenRegisterSucceed) {
            _appPreferences.setUserOpenedRegister();
          } else if (state is OpenRegisterError) {
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }
        },
        builder: (context, state) {
          return OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              if (deviceWidth! < 600) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }
            } else if (orientation == Orientation.landscape) {
              if (deviceWidth! < 800) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              }
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          deviceWidth! <= 600 ? Container() : leftPart(context),
                          deviceWidth! <= 600
                              ? Container()
                              : SizedBox(
                                  width: AppConstants.smallDistance,
                                ),
                          rightPart(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // right part --------------------------------------------------------------
  Widget rightPart(BuildContext context) {
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
                    chooseBusiness(context),
                    chooseLocation(context),
                    putInitialValue(
                        context, posInitialEditingController, deviceWidth!),
                    const Divider(
                      thickness: AppSize.s1,
                    ),
                    buttons(context),
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

  Widget chooseBusiness(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(AppStrings.chooseBusiness.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s20.sp,
                      color: ColorManager.primary,
                      fontWeight: deviceWidth! <= 600
                          ? FontWeight.w500
                          : FontWeight.bold))),
          SizedBox(
            height: AppConstants.smallDistance,
          ),
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
            items: listOfBusinesses.map((item) {
              return DropdownMenuItem(
                  value: item.name,
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: AppSize.s15.sp),
                  ));
            }).toList(),
            onChanged: (selectedBusiness) {
              _selectedBusiness = selectedBusiness;
              setState(() {
                int index = 0;
                for (var i in listOfBusinesses) {
                  if (i.name == _selectedBusiness) {
                    listOfBusinesses
                        .indexWhere((element) => element.name == _selectedBusiness);

                    listOfLocations = listOfBusinesses[index].locations;

                    _selectedLocation = listOfLocations[0].locationName;
                    locationId = listOfLocations[0].locationId;

                    decimalPlaces = listOfLocations[0].locationDecimalPlaces;

                    _appPreferences.setLocationId(PREFS_KEY_LOCATION_ID, locationId!);

                    _appPreferences.setBusinessType(
                        PREFS_KEY_BUSINESS_TYPE, businessType!);

                    RegisterPOSCubit.get(context).openCloseRegister(
                        CloseRegisterReportRequest(today: true), locationId!);

                    RegisterPOSCubit.get(context).getTaxes(locationId!);
                    break;
                  }
                  index++;
                }

                index = 0;
                for (var i in listOfLocations) {
                  if (i.locationName == _selectedLocation) {
                    index = listOfLocations.indexWhere(
                        (element) => element.locationName == _selectedLocation);

                    locationId = listOfLocations[index].locationId;

                    decimalPlaces = listOfLocations[index].locationDecimalPlaces;

                    _appPreferences.setLocationId(PREFS_KEY_LOCATION_ID, locationId!);

                    _appPreferences.setBusinessType(
                        PREFS_KEY_BUSINESS_TYPE, businessType!);

                    RegisterPOSCubit.get(context).openCloseRegister(
                        CloseRegisterReportRequest(today: true), locationId!);

                    RegisterPOSCubit.get(context).getTaxes(locationId!);
                    break;
                  }
                }
              });
            },
            value: _selectedBusiness,
            isExpanded: true,
            hint: Row(
              children: [
                Text(
                  AppStrings.chooseBusiness.tr(),
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

  Widget chooseLocation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(AppStrings.chooseLocation.tr(),
                  style: TextStyle(
                      fontSize: AppSize.s20.sp,
                      color: ColorManager.primary,
                      fontWeight: deviceWidth! <= 600
                          ? FontWeight.w500
                          : FontWeight.bold))),
          SizedBox(
            height: AppConstants.smallDistance,
          ),
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
        items: listOfLocations.map((item) {
          return DropdownMenuItem(
              value: item.locationName,
              child: Text(
                item.locationName,
                style: TextStyle(fontSize: AppSize.s15.sp),
              ));
        }).toList(),
        onChanged: (selectedLocation) {
          setState(() {
            _selectedLocation = selectedLocation;
            int index = 0;
            for (var i in listOfLocations) {
              if (i.locationName == _selectedLocation) {
                index = listOfLocations.indexWhere(
                    (element) => element.locationName == _selectedLocation);

                locationId = listOfLocations[index].locationId;

                decimalPlaces = listOfLocations[index].locationDecimalPlaces;

                _appPreferences.setLocationId(PREFS_KEY_LOCATION_ID, locationId!);

                RegisterPOSCubit.get(context).openCloseRegister(
                    CloseRegisterReportRequest(today: true), locationId!);

                RegisterPOSCubit.get(context).getTaxes(locationId!);
                break;
              }
            }
          });
        },
        value: _selectedLocation,
        isExpanded: true,
        hint: Row(
          children: [
            Text(
              AppStrings.chooseLocation.tr(),
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
        Bounceable(
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            onTap: () async {
              await startBusiness(context);
            },
            child: containerComponent(
                context,
                Center(
                    child: Text(
                  AppStrings.start.tr(),
                  style: TextStyle(
                      color: ColorManager.white, fontSize: AppSize.s14.sp),
                )),
                height: 40.h,
                width: deviceWidth! <= 600 ? 170.h : 50.w,
                color: ColorManager.primary,
                borderRadius: AppSize.s5,
                borderColor: ColorManager.primary,
                borderWidth: 0.6.w)),
      ],
    );
  }

  Future<void> startBusiness(BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    for (var nOfLocation in userResponse!.locations) {
      if (nOfLocation.id == locationId) {
        for (var nOfPermissions in nOfLocation.permissions) {
          if (nOfPermissions.name == 'pos/checkout') {
            if (listOfBusinesses.isNotEmpty && listOfLocations.isNotEmpty) {
              if (registeredBefore!) {
                CustomDialog.show(
                    context,
                    AppStrings.registeredBefore.tr(),
                    const Icon(Icons.warning_amber_rounded),
                    ColorManager.white,
                    AppConstants.durationOfSnackBar,
                    ColorManager.hold);

                await Future.delayed(
                    Duration(milliseconds: AppConstants.durationOfSnackBar + 1000));
              } else {
                OpenRegisterRequest openRegisterRequest = OpenRegisterRequest(
                    handCash: double.parse(posInitialEditingController.text));
                await RegisterPOSCubit.get(context)
                    .openRegister(openRegisterRequest, locationId!);
              }

              Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
            }
            return;
          }
        }
        CustomDialog.show(
            context,
            AppStrings.youHaveNoPermission.tr(),
            const Icon(Icons.close),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.delete);
      } else {
        CustomDialog.show(
            context,
            AppStrings.youHaveNoPermission.tr(),
            const Icon(Icons.close),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.delete);
        return;
      }
    }
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
