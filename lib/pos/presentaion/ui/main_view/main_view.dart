import 'dart:async';

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
import 'package:poslix_app/pos/domain/requests/cart_model.dart';
import 'package:poslix_app/pos/domain/response/customer_model.dart';
import 'package:poslix_app/pos/domain/response/prices_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/edit_quantity_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_cubit.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/add_edit_customer_buttons.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/brand_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/brand_items.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/customer_dialog/customer_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/discount_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/hold_dialog/hold_card_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/item_options_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/orders_and_hold_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/payment_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/shipping_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/buttons.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/category_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/category_items.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/orders_report_btn_mobile.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/sales_table/sales_table_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/sales_table/sales_table_head.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/search_text.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/totals.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/padding_margin_values_manager.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';
import '../../../domain/entities/order_model.dart';
import '../../../domain/entities/tmp_order_model.dart';
import '../../../domain/response/brands_model.dart';
import '../../../domain/response/categories_model.dart';
import '../../../domain/response/payment_method_model.dart';
import '../../../domain/response/pricing_group_model.dart';
import '../../../domain/response/stocks_model.dart';
import '../../../domain/response/tailoring_types_model.dart';
import '../../../domain/response/variations_model.dart';
import '../../../shared/constant/assets_manager.dart';
import '../../../shared/constant/language_manager.dart';
import '../../../shared/constant/strings_manager.dart';
import '../../../shared/preferences/app_pref.dart';
import '../../../shared/utils/global_values.dart';
import '../../di/di.dart';
import '../../router/app_router.dart';
import '../components/container_component.dart';
import '../components/text_component.dart';
import '../login_view/login_cubit/login_cubit.dart';
import '../login_view/login_cubit/login_state.dart';
import '../popup_dialogs/custom_dialog.dart';
import '../popup_dialogs/loading_dialog.dart';
import 'inner_dialogs/printer_settings/printer_settings_view.dart';
import 'widgets/bottom_bar.dart';
import 'inner_dialogs/close_register_dialog/close_register_dialog.dart';
import 'inner_dialogs/customer_dialog/customer_mobile_dialog.dart';
import 'inner_dialogs/tailor_dialog/tailor_dialog.dart';
import 'main_view_cubit/main_view_state.dart';

class MainView extends StatefulWidget {
  MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  late PersistentBottomSheetController _controllerLeftPart;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<AnimatedFloatingActionButtonState> floatingKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  DateTime today = DateTime.now();

  bool showFab = true;

  bool isMultiLang = false;

  List<CategoriesResponse> listOfCategories = [];
  List<BrandsResponse> listOfBrands = [];

  List<PaymentMethodModel> listOfPaymentMethods = [];

  List<ProductsResponse> listOfAllProducts = [];
  List<ProductsResponse> listOfBothProducts = [];
  List<String> searchList = [];

  List<ProductsResponse> listOfProducts = [];
  List<VariationsResponse> listOfVariations = [];
  List<StocksResponse> listOfStocks = [];

  List listOfFabrics = [];
  List<PricesResponse> listOfPackagePrices = [];
  TailoringTypesModel? tailoringType;

  List<CustomerResponse> listOfCustomers = [];
  List<PricingGroupResponse> listOfPricingGroups = [];

  String selectedDiscountType = '';

  int decimalPlaces = 2;
  int locationId = 140;
  String businessType = '';
  // String businessType = 'Tailor';
  int tax = 0;

  bool tailor = false;

  int getIndex(int index) {
    int finalIndex = index + 1;
    return finalIndex;
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    _customerEditingController.dispose();
    // for (var controller in _quantityControllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }

  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;

  CustomerResponse? _selectedCustomer;
  String? _selectedCustomerName;
  int? _selectedPriceGroupId;

  int? _selectedCustomerId;
  String? _selectedCustomerTel;
  String _selectedCategory = '';

  double shippingCharge = 0;
  double discount = 0;
  double totalAmount = 0;
  double differenceValue = 0;
  double originalTotalValue = 0;

  bool? categoryFilter;

  double? sumItems() {
    double total = 0;
    for (var itemOfOrder in listOfTmpOrder) {
      total = total +
          (double.parse(itemOfOrder.itemPrice.toString()) *
              itemOfOrder.itemQuantity!);
    }
    return total;
  }

  double getTotalAmount() {
    getEstimatedTax();
    totalAmount = roundDouble(
        sumItems()! + ((tax / 100) * sumItems()!) + shippingCharge - discount,
        decimalPlaces);
    return totalAmount;
  }

  double estimatedTax = 0.00;
  double getEstimatedTax() {
    estimatedTax = roundDouble((tax / 100) * sumItems()!, decimalPlaces);
    return estimatedTax;
  }

  void isSelected(int itemId) {
    setState(() {
      if (categoryFilter!) {
        for (var n in listOfCategories) {
          n.selected = false;
        }
        final currentId =
            listOfCategories.indexWhere((element) => element.id == itemId);

        listOfCategories[currentId].selected =
            !listOfCategories[currentId].selected!;
        _selectedCategory = listOfCategories[currentId].name;
        listOfProducts = listOfCategories[currentId].products;
        if (listOfCategories[currentId].products.isNotEmpty) {
          listOfVariations = listOfCategories[currentId].products[0].variations;
          listOfStocks = listOfCategories[currentId].products[0].stocks;
        } else {
          listOfVariations = [];
          listOfStocks = [];
        }
      } else {
        for (var n in listOfBrands) {
          n.selected = false;
        }
        final currentId =
            listOfBrands.indexWhere((element) => element.id == itemId);

        listOfBrands[currentId].selected = !listOfBrands[currentId].selected!;
        _selectedCategory = listOfBrands[currentId].name;
        listOfProducts = listOfBrands[currentId].products;
        if (listOfBrands[currentId].products.isNotEmpty) {
          listOfVariations = listOfBrands[currentId].products[0].variations;
          listOfStocks = listOfBrands[currentId].products[0].stocks;
        } else {
          listOfVariations = [];
          listOfStocks = [];
        }
      }
    });
  }

  void getDiscount(double discountValue, bool fixed) {
    setState(() {
      if (fixed) {
        discount = roundDouble(discountValue, decimalPlaces);
      } else {
        discount = roundDouble((discountValue / 100) * 100, decimalPlaces);
      }
    });
  }

  void getShippingValue(double shippingValue) {
    setState(() {
      shippingCharge = roundDouble(shippingValue, decimalPlaces);
    });
  }

  String currencyCode = '';

  @override
  void initState() {
    categoryFilter = true;

    listOfTmpOrder = [];
    getDecimalPlaces();
    getLocationId();
    getBusinessType();
    getTax();

    super.initState();
  }

  bool _addToTmp = false;
  bool _showArrow = false;

  Timer? _timer;

  Future startAnimation() async {
    _showArrow = true;
    await Future.delayed(const Duration(milliseconds: 15));
    _timer = Timer(Duration(milliseconds: AppConstants.durationOfAdd), hide);
    setState(() {
      _addToTmp = true;
    });
  }

  void hide() {
    setState(() {
      _addToTmp = false;
      _showArrow = false;
    });
    _timer?.cancel();
  }

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getDecimalPlaces(PREFS_KEY_DECIMAL_PLACES)!;
  }

  void getLocationId() async {
    locationId = _appPreferences.getLocationId(PREFS_KEY_LOCATION_ID)!;
  }

  void getBusinessType() async {
    businessType = _appPreferences.getBusinessType(PREFS_KEY_BUSINESS_TYPE)!;
  }

  void getTax() async {
    tax = _appPreferences.getTaxValue(PREFS_KEY_TAX_VALUE)!;
  }

  void reload() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  final TextEditingController _searchEditingController =
      TextEditingController();

  // final List<TextEditingController> _quantityControllers = [];

  final TextEditingController _customerEditingController =
      TextEditingController();

  double? deviceWidth;

  Widget language() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _changeLanguage();
        });
      },
      heroTag: AppStrings.language.tr(),
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
        listener: (context, state) {
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
            heroTag: AppStrings.logout.tr(),
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

  Widget register() {
    return FloatingActionButton(
      onPressed: () {
        CloseRegisterDialog.show(context, locationId, deviceWidth!);
      },
      heroTag: AppStrings.registerPos.tr(),
      tooltip: AppStrings.registerPos.tr(),
      backgroundColor: ColorManager.primary,
      child: SvgPicture.asset(
        ImageAssets.close,
        width: AppSize.s25,
        color: ColorManager.white,
      ),
    );
  }

  Widget printerSettings() {
    return FloatingActionButton(
      onPressed: () {
        PrinterSettingsDialog.show(context, deviceWidth!);
      },
      heroTag: AppStrings.printerSettings.tr(),
      tooltip: AppStrings.printerSettings.tr(),
      backgroundColor: ColorManager.primary,
      child: SvgPicture.asset(
        ImageAssets.printing,
        width: AppSize.s40,
        color: ColorManager.white,
      ),
    );
  }

  Widget refresh() {
    return FloatingActionButton(
      onPressed: () {
        reload();
      },
      heroTag: AppStrings.reload.tr(),
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
            key: _scaffoldKey,
            backgroundColor: ColorManager.secondary,
            body: bodyContent(context),
            floatingActionButton: showFab
                ? AnimatedFloatingActionButton(
                    fabButtons: [
                        printerSettings(),
                        language(),
                        logout(),
                        register(),
                        refresh()
                      ],
                    key: floatingKey,
                    colorStartAnimation: ColorManager.primary,
                    colorEndAnimation: ColorManager.delete,
                    animatedIconData:
                        AnimatedIcons.menu_close //To principal button
                    )
                : Container(),
          ),
        ),
      ),
    );
  }

  showLoadingDialog(BuildContext context) {
    LoadingDialog.show(context);
  }

  void loadCategories() {
    for (var element in listOfCategories) {
      listOfAllProducts.addAll(Set.of(element.products));
      listOfBothProducts.addAll(Set.of(element.products));
    }

    for (var element in listOfAllProducts) {
      searchList.add(element.name);
    }

    listOfCategories.insert(
        0,
        CategoriesResponse(
            id: 0,
            selected: false,
            name: AppStrings.all.tr(),
            description: '',
            locationId: locationId,
            createdBy: 1,
            neverTax: 0,
            parentId: 0,
            products: listOfAllProducts,
            productsCount: listOfAllProducts.length,
            deletedAt: '',
            createdAt: '',
            updatedAt: '',
            taxId: 0,
            slug: '',
            woocommerceCatId: 0,
            showInList: 'on',
            categoryType: 'single',
            shortCode: ''));

    listOfProducts = listOfAllProducts;
    listOfVariations = listOfCategories[0].products[0].variations;
    listOfStocks = listOfCategories[0].products[0].stocks;

    for (var element in listOfCategories) {
      element.selected = false;
    }

    listOfCategories[0].selected = true;

    _selectedCategory = listOfCategories[0].name;
  }

  void loadCustomers() {
    listOfCustomers.insert(
        0,
        CustomerResponse(
            firstName: AppStrings.firstName,
            lastName: AppStrings.secondName,
            locationId: locationId,
            addressLine_1: '',
            addressLine_2: '',
            city: '',
            contactStatus: '',
            country: '',
            createdAt: '',
            createdBy: 0,
            id: 1,
            mobile: '',
            shippingAddress: '',
            state: '',
            type: '',
            zipCode: '',
            contactId: '',
            deletedAt: '',
            email: '',
            name: '',
            updatedAt: '',
        priceGroupsId: 0,
        ));

    _selectedCustomerName =
        '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}';
    _selectedCustomerId = listOfCustomers[0].id;
    _selectedCustomerTel = listOfCustomers[0].mobile;
    _selectedPriceGroupId = listOfCustomers[0].priceGroupsId ?? 0;
  }

  Widget bodyContent(BuildContext context) {
    totalAmount = getTotalAmount();

    GlobalValues.getEditOrder
        ? differenceValue = roundDouble(
            double.parse((totalAmount - originalTotalValue).toStringAsFixed(2)),
            decimalPlaces)
        : differenceValue = 0;

    return BlocProvider(
      create: (context) => sl<MainViewCubit>()
        ..getHomeData(locationId)
        ..getPaymentMethods(locationId)
        ..getLocationSettings(locationId),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is MainNoInternetState) {
            showNoInternet(context);
          }
          // get Home Data
          if (state is LoadingHomeData) {
            showLoadingDialog(context);
            return;
          } else if (state is LoadedHomeData) {
            LoadingDialog.hide(context);
            listOfCategories = MainViewCubit.get(context).listOfCategories;
            loadCategories();

            listOfCustomers = MainViewCubit.get(context).listOfCustomers;
            listOfPricingGroups =
                MainViewCubit.get(context).listOfPricingGroups;
            loadCustomers();

            currencyCode = MainViewCubit.get(context).currencyCode;
            return;
          } else if (state is LoadingErrorHomeData) {
            LoadingDialog.hide(context);
            listOfProducts = [];
            tryAgainLater(context);
            return;
          }

          // get Categories -----------------------------------------------------------------------------------------------------------------
          if (state is LoadingCategories) {
            showLoadingDialog(context);
          } else if (state is LoadedCategories) {
            LoadingDialog.hide(context);
            listOfCategories = MainViewCubit.get(context).listOfCategories;
            loadCategories();
          } else if (state is LoadingErrorCategories) {
            listOfProducts = [];
            LoadingDialog.hide(context);
            tryAgainLater(context);
          }
          // get Brands -----------------------------------------------------------------------------------------------------------------
          if (state is LoadingBrands) {
            showLoadingDialog(context);
          } else if (state is LoadedBrands) {
            LoadingDialog.hide(context);
            listOfBrands = MainViewCubit.get(context).listOfBrands;

            for (var element in listOfBrands) {
              listOfAllProducts.addAll(Set.of(element.products));
              listOfBothProducts.addAll(Set.of(element.products));
            }

            for (var element in listOfAllProducts) {
              searchList.add(element.name);
            }

            listOfBrands.insert(
                0,
                BrandsResponse(
                    id: 0,
                    selected: false,
                    name: AppStrings.all.tr(),
                    description: '',
                    locationId: locationId,
                    createdBy: 1,
                    neverTax: 0,
                    products: listOfAllProducts,
                    productsCount: listOfAllProducts.length,
                    deletedAt: '',
                    createdAt: '',
                    updatedAt: ''));

            listOfProducts = listOfAllProducts;
            listOfVariations = listOfBrands[0].products[0].variations;
            listOfStocks = listOfBrands[0].products[0].stocks;

            for (var element in listOfBrands) {
              element.selected = false;
            }

            listOfBrands[0].selected = true;

            _selectedCategory = listOfBrands[0].name;
          } else if (state is LoadingErrorBrands) {
            LoadingDialog.hide(context);
            listOfProducts = [];
            tryAgainLater(context);
          }
          // get Customers -----------------------------------------------------------------------------------------------------------------
          if (state is LoadingCustomers) {
            showLoadingDialog(context);
          } else if (state is LoadedCustomers) {
            LoadingDialog.hide(context);
            listOfCustomers = MainViewCubit.get(context).listOfCustomers;
            loadCustomers();
          } else if (state is LoadingErrorCustomers) {
            LoadingDialog.hide(context);
            tryAgainLater(context);
          }
          // get Pricing Groups -----------------------------------------------------------------------------------------------------------------
          if (state is LoadedPricingGroups) {
            listOfPricingGroups =
                MainViewCubit.get(context).listOfPricingGroups;
          } else if (state is LoadingErrorPricingGroups) {
            tryAgainLater(context);
          }

          // get Customer data -----------------------------------------------------------------------------------------------------------------
          if (state is LoadingCustomer) {
            showLoadingDialog(context);
          } else if (state is LoadedCustomer) {
            LoadingDialog.hide(context);

            var contain = listOfPricingGroups
                .where((element) => element.name == AppStrings.noThing.tr());
            if (contain.isEmpty) {
              listOfPricingGroups.add(PricingGroupResponse(
                  id: 0,
                  updatedAt: '',
                  createdAt: '',
                  locationId: locationId,
                  name: AppStrings.noThing.tr(),
                  businessId: 0,
                  isActive: 0, products: [],customers: []));
            }

            int index = listOfCustomers.indexWhere((element) =>
                '${element.firstName} ${element.lastName} | ${element.mobile}' ==
                '${_selectedCustomer?.firstName} ${_selectedCustomer?.lastName} | ${_selectedCustomer?.mobile}');
            deviceWidth! <= 600
                ? CustomerMobileDialog.show(
                    context,
                    'Edit',
                    listOfCustomers[index],
                    _selectedCustomerId!,
                    locationId, (done) {
                    if (done == 'done') {
                      setState(() {
                        listOfCustomers = [];
                        CustomerResponse? selectedCustomer2;
                        _selectedCustomer = selectedCustomer2;
                        MainViewCubit.get(context).getCustomers(locationId);
                      });
                    }
                  }, listOfPricingGroups)
                : CustomerDialog.show(context, 'Edit', listOfCustomers[index],
                    _selectedCustomerId!, locationId, (done) {
                    if (done == 'done') {
                      setState(() {
                        listOfCustomers = [];
                        CustomerResponse? selectedCustomer2;
                        _selectedCustomer = selectedCustomer2;
                        MainViewCubit.get(context).getCustomers(locationId);
                      });
                    }
                  }, listOfPricingGroups);
          } else if (state is LoadingErrorCustomer) {
            LoadingDialog.hide(context);
            tryAgainLater(context);
          }
          if (state is LoadedPaymentMethods) {
            listOfPaymentMethods =
                MainViewCubit.get(context).listOfPaymentMethods;
          }
          // location settings

          if (state is LoadedLocationSettings) {
            isMultiLang = state.locationSettingResponse.isMultiLanguage == 1
                ? true
                : false;
          } else if (state is LoadingErrorLocationSettings) {}
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
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p10),
                  child: Center(
                    child: Row(
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
                  ),
                ),
                deviceWidth! <= 600
                    ? listOfTmpOrder.isNotEmpty
                        ? Positioned(
                            bottom: 0,
                            child: Bounceable(
                                duration: Duration(
                                    milliseconds:
                                        AppConstants.durationOfBounceable),
                                onTap: () async {
                                  await Future.delayed(Duration(
                                      milliseconds:
                                          AppConstants.durationOfBounceable));
                                  showFloatingActionButton(false);
                                  _controllerLeftPart = _scaffoldKey
                                      .currentState!
                                      .showBottomSheet(
                                    clipBehavior: Clip.hardEdge,
                                    backgroundColor:
                                        Theme.of(context).dialogBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(22),
                                        topRight: Radius.circular(22),
                                      ),
                                    ),
                                    (context) {
                                      return Column(
                                        children: [
                                          leftPart(context),
                                        ],
                                      );
                                    },
                                  );

                                  _controllerLeftPart.closed.then((value) {
                                    showFloatingActionButton(true);
                                  });
                                },
                                child: BottomSheetBar(
                                  itemsCount: listOfTmpOrder.length,
                                  currencyCode: currencyCode,
                                  totalAmount: totalAmount,
                                )))
                        : isRtl()
                            ? Positioned(
                                bottom: 15.h,
                                right: 20.w,
                                child: Bounceable(
                                    onTap: () {
                                      btnGetOrders(context);
                                    },
                                    child: ordersBtnMobile()))
                            : Positioned(
                                bottom: 15.h,
                                left: 20.w,
                                child: Bounceable(
                                    onTap: () {
                                      btnGetOrders(context);
                                    },
                                    child: ordersBtnMobile()))
                    : Container(),
                deviceWidth! <= 600
                    ? listOfTmpOrder.isNotEmpty
                        ? isRtl()
                            ? Positioned(
                                left: 11.w,
                                bottom: 13.h,
                                child: Container(
                                    width: 60.h,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      shape: BoxShape.circle,
                                    )))
                            : Positioned(
                                right: 11.w,
                                bottom: 13.h,
                                child: Container(
                                    width: 60.h,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      color: ColorManager.white,
                                      shape: BoxShape.circle,
                                    )))
                        : Container()
                    : Container(),
                deviceWidth! <= 600 && _showArrow
                    ? isRtl()
                        ? AnimatedPositioned(
                            duration: Duration(
                                milliseconds: AppConstants.durationOfAdd),
                            curve: Curves.linear,
                            right: 30.w,
                            bottom: _addToTmp ? 50.h : 150.h,
                            child: SvgPicture.asset(
                              ImageAssets.addToTmp,
                              width: AppSize.s50,
                              height: AppSize.s50,
                              color: ColorManager.primary,
                            ))
                        : AnimatedPositioned(
                            duration: Duration(
                                milliseconds: AppConstants.durationOfAdd),
                            curve: Curves.linear,
                            left: 30.w,
                            bottom: _addToTmp ? 50.h : 150.h,
                            child: SvgPicture.asset(
                              ImageAssets.addToTmp,
                              width: AppSize.s50,
                              height: AppSize.s50,
                              color: ColorManager.primary,
                            ))
                    : Container(),
              ],
            );
          });
        },
      ),
    );
  }

  // left part ------------------------------------------------------
  Widget leftPart(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Column(
          children: [
            containerComponent(
                context,
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p10),
                  child: Column(
                    children: [
                      // drop down
                      deviceWidth! <= 600
                          ? Container()
                          : Row(
                              children: [
                                customerDropDown(context),
                                SizedBox(
                                  width: AppConstants.smallerDistance,
                                ),
                                addAndEditCustomer(
                                    context, getCustomer, addCustomer)
                              ],
                            ),

                      deviceWidth! <= 600
                          ? Container()
                          : SizedBox(
                              height: AppConstants.smallDistance,
                            ),

                      deviceWidth! <= 600
                          ? searchText(
                              context,
                              _searchEditingController,
                              addToTmpInBottomSheet,
                              listOfAllProducts,
                              searchList)
                          : searchText(context, _searchEditingController,
                              addToTmp, listOfAllProducts, searchList),

                      // tmp table of items
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: createDataTable(
                                    context,
                                    _currentSortColumn,
                                    _isSortAsc,
                                    createColumns(deviceWidth!),
                                    createRows(context, deviceWidth!)))),
                      ),

                      constantsAndTotal(
                          context,
                          estimatedTax,
                          tax,
                          editShipping,
                          editDiscount,
                          shippingCharge,
                          discount,
                          currencyCode,
                          totalAmount,
                          differenceValue),

                      buttons(context, hold, delete, getOrders, checkOut)
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height - 20.h,
                color: ColorManager.white,
                borderColor: ColorManager.white,
                borderWidth: 1.5.w,
                borderRadius: AppSize.s5),
          ],
        ));
  }

  Widget customerDropDown(BuildContext context) {
    return Expanded(
        flex: 3,
        child: DropdownButton2(
          underline: Container(),
          value: _selectedCustomer,
          items: listOfCustomers.map((item) {
            return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    Container(
                        constraints: BoxConstraints(maxWidth: 60.w),
                        child:
                            textS14PrimaryComponent(context, item.firstName)),
                    SizedBox(width: AppConstants.smallerDistance),
                    Container(
                        constraints: BoxConstraints(maxWidth: 60.w),
                        child: textS14PrimaryComponent(context, item.lastName)),
                    item.firstName == AppStrings.firstName
                        ? Container()
                        : Row(
                            children: [
                              SizedBox(width: AppConstants.smallerDistance),
                              textS14PrimaryComponent(context, '|'),
                              SizedBox(width: AppConstants.smallerDistance),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 50.w),
                                  child: textS14PrimaryComponent(
                                      context, item.mobile))
                            ],
                          ),
                  ],
                ));
          }).toList(),
          onChanged: (selectedCustomer) {
            setState(() {
              _selectedCustomer = selectedCustomer as CustomerResponse?;
              _selectedCustomerName =
                  '${selectedCustomer?.firstName} ${selectedCustomer?.lastName}';
              _selectedCustomerId = selectedCustomer?.id;
              _selectedCustomerTel = selectedCustomer?.mobile;
              _selectedPriceGroupId = selectedCustomer?.priceGroupsId ?? 0;
            });
          },
          // // search text for customer
          dropdownSearchData: DropdownSearchData(
            searchController: _customerEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: _customerEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: AppStrings.searchForCustomer.tr(),
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              _selectedCustomer = item.value as CustomerResponse?;
              var choose =
                  '${_selectedCustomer!.firstName} ${_selectedCustomer!.lastName} | ${_selectedCustomer!.mobile}';
              return choose.contains(searchValue);
            },
          ),
          // // This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _customerEditingController.clear();
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 47.h,
            width: 250.w,
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
            width: 240.w,
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
          isExpanded: true,
          hint: Row(
            children: [
              textS14PrimaryComponent(
                context,
                '${AppStrings.firstName} ${AppStrings.secondName}',
              ),
              SizedBox(
                width: AppConstants.smallDistance,
              )
            ],
          ),
          style:
              TextStyle(color: ColorManager.primary, fontSize: AppSize.s14.sp),
        ));
  }

  void getCustomer(BuildContext context) {
    if (_selectedCustomerId != 1) {
      setState(() {
        MainViewCubit.get(context).getCustomer(_selectedCustomerId!);
      });
    }
  }

  void addCustomer(BuildContext context) {
    var contain = listOfPricingGroups
        .where((element) => element.name == AppStrings.noThing.tr());
    if (contain.isEmpty) {
      listOfPricingGroups.add(PricingGroupResponse(
          id: 0,
          updatedAt: '',
          createdAt: '',
          locationId: locationId,
          name: AppStrings.noThing.tr(),
          businessId: 0,
          isActive: 0, products: [],customers: []));
    }
    deviceWidth! <= 600
        ? CustomerMobileDialog.show(context, 'Add', [], 0, locationId,
            (done) async {
            if (done == 'done') {
              CustomerMobileDialog.hide(context);
              setState(() {
                listOfCustomers = [];
                CustomerResponse? selectedCustomer2;
                _selectedCustomer = selectedCustomer2;
                MainViewCubit.get(context).getCustomers(locationId);
              });

              CustomDialog.show(
                  context,
                  AppStrings.customerAddedSuccessfully.tr(),
                  const Icon(Icons.check),
                  ColorManager.white,
                  AppConstants.durationOfSnackBar,
                  ColorManager.success);
            }
          }, listOfPricingGroups)
        : CustomerDialog.show(context, 'Add', [], 0, locationId, (done) {
            if (done == 'done') {
              CustomerDialog.hide(context);
              setState(() {
                listOfCustomers = [];
                CustomerResponse? selectedCustomer2;
                _selectedCustomer = selectedCustomer2;
                MainViewCubit.get(context).getCustomers(locationId);
              });

              CustomDialog.show(
                  context,
                  AppStrings.customerAddedSuccessfully.tr(),
                  const Icon(Icons.check),
                  ColorManager.white,
                  AppConstants.durationOfSnackBar,
                  ColorManager.success);
            }
          }, listOfPricingGroups);
  }

  void editDiscount(BuildContext context) {
    setState(() {
      DiscountDialog.show(context, (discountValue, fixed) {
        getDiscount(discountValue, fixed);
      }, (discountType) {
        selectedDiscountType == discountType;
      });
    });
  }

  void editShipping(BuildContext context) {
    setState(() {
      ShippingDialog.show(context, (shippingValue) {
        getShippingValue(shippingValue);
      }, deviceWidth!);
    });
  }

  void hold(BuildContext context) {
    if (listOfTmpOrder.isEmpty) {
      CustomDialog.show(
          context,
          AppStrings.noDataToHold.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
    } else {
      listOfTmpOrder[0].orderDiscount = discount;
      holdOrdersDialog(context, deviceWidth!, listOfTmpOrder, discount,
          _selectedCustomerTel!, _selectedCustomerName!, _selectedPriceGroupId!, (done) {
        if (done == 'done') {
          setState(() {
            listOfTmpOrder.clear();
          });
        }
      });

      discount = 0;
    }
  }

  void delete(BuildContext context) {
    if (listOfTmpOrder.isEmpty) {
      CustomDialog.show(
          context,
          AppStrings.noDataToDelete.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);

      setState(() {
        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName}" ==
                '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}')
            .first;

        _selectedCustomerId = listOfCustomers[0].id;

        _selectedCustomerName =
            '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}';

        _selectedCustomerTel = listOfCustomers[0].mobile;
        _selectedPriceGroupId = listOfCustomers[0].priceGroupsId ?? 0;

        discount = 0;
        differenceValue = 0;
        originalTotalValue = 0;
        estimatedTax = 0;
        shippingCharge = 0;
        GlobalValues.setEditOrder = false;
      });
    } else {
      setState(() {
        CustomDialog.show(
            context,
            AppStrings.orderDeletedSuccessfully.tr(),
            const Icon(Icons.check),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.success);

        listOfTmpOrder.clear();

        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName}" ==
                '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}')
            .first;

        _selectedCustomerId = listOfCustomers[0].id;

        _selectedCustomerName =
            '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}';

        _selectedCustomerTel = listOfCustomers[0].mobile;
        _selectedPriceGroupId= listOfCustomers[0].priceGroupsId ?? 0;

        discount = 0;
        differenceValue = 0;
        originalTotalValue = 0;
        estimatedTax = 0;
        shippingCharge = 0;
        GlobalValues.setEditOrder = false;
      });
    }

    // for (var controller in _quantityControllers) {
    //     _quantityControllers.removeAt(_quantityControllers.indexOf(controller));
    // }
  }

  void getOrders(BuildContext context) {
    OrdersDialog.show(context, locationId, (customerName) {
      if (customerName == '${AppStrings.firstName} ${AppStrings.secondName}') {
        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName}" == customerName)
            .first;
        int indexOfCustomer = listOfCustomers.indexWhere((element) =>
            "${element.firstName} ${element.lastName}" == customerName);

        _selectedCustomerId = listOfCustomers[indexOfCustomer].id;
        _selectedCustomerName =
            '${listOfCustomers[indexOfCustomer].firstName} ${listOfCustomers[indexOfCustomer].lastName}';
        _selectedCustomerTel = listOfCustomers[indexOfCustomer].mobile;
        _selectedPriceGroupId = listOfCustomers[indexOfCustomer].priceGroupsId ?? 0;
        for (var n in listOfTmpOrder) {
          n.pricingGroupId = _selectedPriceGroupId;
        }
      } else {
        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName} | ${element.mobile}" ==
                customerName)
            .first;
        int indexOfCustomer = listOfCustomers.indexWhere((element) =>
            "${element.firstName} ${element.lastName} | ${element.mobile}" ==
            customerName);

        _selectedCustomerId = listOfCustomers[indexOfCustomer].id;
        _selectedCustomerName =
            '${listOfCustomers[indexOfCustomer].firstName} ${listOfCustomers[indexOfCustomer].lastName}';
        _selectedCustomerTel = listOfCustomers[indexOfCustomer].mobile;
        _selectedPriceGroupId = listOfCustomers[indexOfCustomer].priceGroupsId ?? 0;
        for (var n in listOfTmpOrder) {
          n.pricingGroupId = _selectedPriceGroupId;
        }
      }
    }, (orderTotal) {
      originalTotalValue = orderTotal;
    }, (orderDiscount) {
      if (deviceWidth! <= 600) {
        _controllerLeftPart.setState!(() {
          discount = double.parse(orderDiscount.toString());
        });
      } else {
        setState(() {
          discount = double.parse(orderDiscount.toString());
        });
      }
    }, deviceWidth!);
  }

  void btnGetOrders(BuildContext context) {
    OrdersDialog.show(context, locationId, (customerName) {
      if (customerName == '${AppStrings.firstName} ${AppStrings.secondName}') {
        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName}" == customerName)
            .first;
        int indexOfCustomer = listOfCustomers.indexWhere((element) =>
            "${element.firstName} ${element.lastName}" == customerName);

        _selectedCustomerId = listOfCustomers[indexOfCustomer].id;
        _selectedCustomerName =
            '${listOfCustomers[indexOfCustomer].firstName} ${listOfCustomers[indexOfCustomer].lastName}';
        _selectedCustomerTel = listOfCustomers[indexOfCustomer].mobile;
        _selectedPriceGroupId = listOfCustomers[indexOfCustomer].priceGroupsId ?? 0;
        for (var n in listOfTmpOrder) {
          n.pricingGroupId = _selectedPriceGroupId;
        }
      } else {
        _selectedCustomer = listOfCustomers
            .where((element) =>
                "${element.firstName} ${element.lastName} | ${element.mobile}" ==
                customerName)
            .first;
        int indexOfCustomer = listOfCustomers.indexWhere((element) =>
            "${element.firstName} ${element.lastName} | ${element.mobile}" ==
            customerName);

        _selectedCustomerId = listOfCustomers[indexOfCustomer].id;
        _selectedCustomerName =
            '${listOfCustomers[indexOfCustomer].firstName} ${listOfCustomers[indexOfCustomer].lastName}';
        _selectedCustomerTel = listOfCustomers[indexOfCustomer].mobile;
        _selectedPriceGroupId = listOfCustomers[indexOfCustomer].priceGroupsId ?? 0;
        for (var n in listOfTmpOrder) {
          n.pricingGroupId = _selectedPriceGroupId;
        }
      }
    }, (orderTotal) {
      originalTotalValue = orderTotal;
    }, (orderDiscount) {
      totalAmount = getTotalAmount();
      setState(() {
        discount = double.parse(orderDiscount.toString());
      });
    }, deviceWidth!);
  }

  void checkOut(BuildContext context) {
    if (listOfTmpOrder.isEmpty) {
      CustomDialog.show(
          context,
          AppStrings.noDataToCheckOut.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
    } else {
      if (businessType != 'Tailor') {
        if (categoryFilter!) {
          for (var element in listOfCategories) {
            listOfBothProducts.addAll(Set.of(element.products));
          }
        } else {
          for (var element in listOfBrands) {
            listOfBothProducts.addAll(Set.of(element.products));
          }
        }
        for (var n in listOfTmpOrder) {
          var itemStock = listOfBothProducts
              .where((element) => element.id == n.productId)
              .first;

          int qty = itemStock.stock;
          int indexOfList = listOfBothProducts
              .indexWhere((element) => element.id == n.productId);

          if (listOfBothProducts[indexOfList].variations.isNotEmpty) {
            int indexOfVariationList = itemStock.variations
                .indexWhere((element) => element.id == n.variationId);
            qty = listOfBothProducts[indexOfList]
                .variations[indexOfVariationList]
                .stock;
          }

          if (itemStock.sellOverStock == 0 && itemStock.isService == 0) {
            if (int.parse(n.itemQuantity.toString()) > qty) {
              CustomDialog.show(
                  context,
                  AppStrings.noCreditWhenCheck.tr(),
                  const Icon(Icons.warning_amber_rounded),
                  ColorManager.white,
                  AppConstants.durationOfSnackBar,
                  ColorManager.hold);
              return;
            }
          }
        }
      }

      listOfTmpOrder[0].orderDiscount = discount;

      listOfOrders.clear();

      for (var element in listOfTmpOrder) {
        listOfOrders.add(OrderModel(
            id: element.id,
            date: element.date,
            category: element.category,
            brand: element.brand,
            customer: element.customer,
            itemAmount: element.itemAmount,
            itemName: element.itemName,
            itemPrice: element.itemPrice,
            itemQuantity: element.itemQuantity,
            orderDiscount: element.orderDiscount,
            customerTel: element.customerTel,
            itemOption: element.itemOption,
            variationId: element.variationId,
            productId: element.productId));
      }

      totalAmount = getTotalAmount();

      originalTotalValue = 0;
      differenceValue = 0;
      GlobalValues.setEditOrder = false;

      List<CartRequest> cartRequest = [];
      for (var element in listOfTmpOrder) {
        cartRequest.add(CartRequest(
            productId: element.productId!,
            variationId: element.variationId!,
            qty: element.itemQuantity!,
            note: ''));
      }

      PaymentDialog.show(
          context,
          listOfPaymentMethods,
          currencyCode,
          totalAmount,
          cartRequest,
          locationId,
          _selectedCustomerId!,
          selectedDiscountType,
          discount,
          'fixed',
          estimatedTax, (done) {
        if (done == 'done') {
          // MainViewCubit.get(context).getCategories(locationId);
          setState(() {
            // categoryFilter = true;
            // listOfTmpOrder = [];
            // listOfBothProducts = [];
            // listOfAllProducts = [];
            // searchList = [];
            reload();
          });
        }
      },
          deviceWidth!,
          GlobalValues.getEditOrder ? GlobalValues.getRelatedInvoiceId : 0,
          isMultiLang);

      discount = 0;
      estimatedTax = 0;
      shippingCharge = 0;
      totalAmount = 0;
      differenceValue = 0;

      listOfTmpOrder.clear();
    }
  }

  List<DataRow> createRows(BuildContext context, double deviceWidth) {
    return listOfTmpOrder
        .map((tmpOrder) => DataRow(cells: [
              DataCell(Text(
                getIndex(listOfTmpOrder.indexOf(tmpOrder)).toString(),
                style: TextStyle(color: ColorManager.edit),
              )),
              DataCell(SizedBox(
                width: deviceWidth <= 600 ? 70.w : 40.w,
                child: Center(
                    child: Text(
                        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                            .itemName
                            .toString(),
                        style: TextStyle(fontSize: AppSize.s12.sp),
                        textAlign: TextAlign.center)),
              )),
              DataCell(Center(
                  child: SizedBox(
                width: deviceWidth <= 600 ? 110.w : 42.w,
                child: Center(
                  child: Row(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                                        .productType ==
                                    'tailoring_package'
                                ? Bounceable(
                                    duration: Duration(
                                        milliseconds:
                                            AppConstants.durationOfBounceable),
                                    onTap: () async {
                                      await Future.delayed(Duration(
                                          milliseconds: AppConstants
                                              .durationOfBounceable));
                                    },
                                    child: containerComponent(
                                        context,
                                        Center(
                                            child: Icon(
                                          Icons.edit,
                                          size: AppSize.s15.sp,
                                          color: ColorManager.white,
                                        )),
                                        height: 28.h,
                                        width: 10.w,
                                        margin: const EdgeInsets.only(
                                            bottom: AppMargin.m8),
                                        padding: const EdgeInsets.all(
                                            AppPadding.p08),
                                        color: ColorManager.primary,
                                        borderColor: ColorManager.primary,
                                        borderWidth: 0.1.w,
                                        borderRadius: AppSize.s5))
                                : Container()
                          ],
                        ),
                      ),
                      listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                                  .productType ==
                              'tailoring_package'
                          ? SizedBox(
                              width: AppConstants.smallerDistance,
                            )
                          : SizedBox(
                              width: AppConstants.widthBetweenElements,
                            ),
                      GestureDetector(
                        onLongPressUp: () {
                          editQuantityDialog(context, deviceWidth,
                                  (value) {
                                editCount(tmpOrder, context, value);
                              });
                        },
                        child: containerComponent(
                            context,
                            Padding(
                              padding: const EdgeInsets.all(AppPadding.p2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Bounceable(
                                    duration: Duration(
                                        milliseconds:
                                            AppConstants.durationOfBounceable),
                                    onTap: () async {
                                      await decreaseCount(tmpOrder);
                                    },
                                    child: GestureDetector(
                                      onLongPressUp: () {
                                        editQuantityDialog(context, deviceWidth,
                                            (value) {
                                          editCount(tmpOrder, context, value);
                                        });
                                      },
                                      child: containerComponent(
                                          context,
                                          Icon(
                                            listOfTmpOrder[listOfTmpOrder
                                                            .indexOf(tmpOrder)]
                                                        .itemQuantity ==
                                                    1
                                                ? Icons.close
                                                : Icons.remove,
                                            size: AppSize.s10.sp,
                                          ),
                                          height: 20.h,
                                          width: deviceWidth <= 600 ? 20.w : 10.w,
                                          color: ColorManager.secondary,
                                          borderColor: ColorManager.secondary,
                                          borderWidth: 1.w,
                                          borderRadius: AppSize.s5),
                                    ),
                                  ),
                                  Text(
                                    listOfTmpOrder[
                                            listOfTmpOrder.indexOf(tmpOrder)]
                                        .itemQuantity
                                        .toString(),
                                    style: TextStyle(fontSize: AppSize.s12.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  Bounceable(
                                    duration: Duration(
                                        milliseconds:
                                            AppConstants.durationOfBounceable),
                                    onTap: () async {
                                      await increaseCount(tmpOrder, context);
                                    },
                                    child: GestureDetector(
                                      onLongPressUp: () {
                                        editQuantityDialog(context, deviceWidth,
                                            (value) {
                                          editCount(tmpOrder, context, value);
                                        });
                                      },
                                      child: containerComponent(
                                          context,
                                          Icon(
                                            Icons.add,
                                            size: AppSize.s10.sp,
                                          ),
                                          height: 20.h,
                                          width: deviceWidth <= 600 ? 20.w : 10.w,
                                          color: ColorManager.secondary,
                                          borderColor: ColorManager.secondary,
                                          borderWidth: 1.w,
                                          borderRadius: AppSize.s5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height: 30.h,
                            width: deviceWidth <= 600 ? 75.w : 30.w,
                            color: ColorManager.white,
                            borderColor: ColorManager.badge,
                            borderWidth: 0.5.w,
                            borderRadius: AppSize.s5),
                      )
                    ],
                  ),
                ),
              ))),
              DataCell(SizedBox(
                width: deviceWidth <= 600 ? 70.w : 20.w,
                child: Center(
                    child: Text(
                        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                            .itemAmount
                            .toString(),
                        style: TextStyle(fontSize: AppSize.s12.sp),
                        textAlign: TextAlign.center)),
              )),
              DataCell(SizedBox(
                width: 20.w,
                child: Center(
                    child: Bounceable(
                        duration: Duration(
                            milliseconds: AppConstants.durationOfBounceable),
                        onTap: () async {
                          if (deviceWidth <= 600) {
                            _controllerLeftPart.setState!(() {
                              listOfTmpOrder.removeAt(getIndex(
                                  listOfTmpOrder.indexOf(tmpOrder) - 1));
                            });
                          } else {
                            setState(() {
                              listOfTmpOrder.removeAt(getIndex(
                                  listOfTmpOrder.indexOf(tmpOrder) - 1));
                            });
                          }
                          // _quantityControllers.removeAt(getIndex(
                          //     listOfTmpOrder.indexOf(tmpOrder)));
                          // for (var controller in _quantityControllers) {
                          //   print('testttttttt');
                          //   print(controller.text);
                          // }
                          getTotalAmount();
                        },
                        child: Icon(
                          Icons.delete,
                          size: AppSize.s20.sp,
                          color: ColorManager.delete,
                        ))),
              ))
            ]))
        .toList();
  }

  Future<void> decreaseCount(TmpOrderModel tmpOrder) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    if (deviceWidth! <= 600) {
      _controllerLeftPart.setState!(() {
        int? itemCount =
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;
        itemCount = itemCount! - 1;
        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
        if (itemCount == 0) {
          listOfTmpOrder.removeAt(listOfTmpOrder.indexOf(tmpOrder));
        }
      });
    } else {
      setState(() {
        int? itemCount =
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;
        itemCount = itemCount! - 1;
        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
        if (itemCount == 0) {
          listOfTmpOrder.removeAt(listOfTmpOrder.indexOf(tmpOrder));
        }
      });
    }
    getTotalAmount();
  }

  Future<void> increaseCount(
      TmpOrderModel tmpOrder, BuildContext context) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    if (businessType != 'Tailor') {
      if (categoryFilter!) {
        for (var element in listOfCategories) {
          listOfBothProducts.addAll(Set.of(element.products));
        }
      } else {
        for (var element in listOfBrands) {
          listOfBothProducts.addAll(Set.of(element.products));
        }
      }
      var itemStock = listOfBothProducts
          .where((element) =>
              element.id ==
              listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].productId)
          .first;

      int qty = itemStock.stock;

      int indexOfList = listOfBothProducts.indexWhere((element) =>
          element.id ==
          listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].productId);

      if (listOfBothProducts[indexOfList].variations.isNotEmpty) {
        int indexOfVariationList = itemStock.variations.indexWhere((element) =>
            element.id ==
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].variationId);
        qty = listOfBothProducts[indexOfList]
            .variations[indexOfVariationList]
            .stock;
      }

      if (itemStock.sellOverStock == 0 && itemStock.isService == 0) {
        if (int.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity.toString()) >= qty) {
          noCredit(context);
          return;
        }
      }
    }

    if (deviceWidth! <= 600) {
      _controllerLeftPart.setState!(() {
        int? itemCount =
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;

        itemCount = itemCount! + 1;

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
      });
    } else {
      setState(() {
        int? itemCount =
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;

        itemCount = itemCount! + 1;

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
      });
    }

    getTotalAmount();
  }

  Future<void> editCount(
      TmpOrderModel tmpOrder, BuildContext context, int newValue) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));

    if (businessType != 'Tailor') {
      if (categoryFilter!) {
        for (var element in listOfCategories) {
          listOfBothProducts.addAll(Set.of(element.products));
        }
      } else {
        for (var element in listOfBrands) {
          listOfBothProducts.addAll(Set.of(element.products));
        }
      }
      var itemStock = listOfBothProducts
          .where((element) =>
              element.id ==
              listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].productId)
          .first;

      int qty = itemStock.stock;

      int indexOfList = listOfBothProducts.indexWhere((element) =>
          element.id ==
          listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].productId);

      if (listOfBothProducts[indexOfList].variations.isNotEmpty) {
        int indexOfVariationList = itemStock.variations.indexWhere((element) =>
            element.id ==
            listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].variationId);
        qty = listOfBothProducts[indexOfList]
            .variations[indexOfVariationList]
            .stock;
      }

      if (itemStock.sellOverStock == 0 && itemStock.isService == 0) {
        if (newValue >= qty) {
          noCredit(context);
          return;
        }
      }
    }

    if (deviceWidth! <= 600) {
      _controllerLeftPart.setState!(() {
        int? itemCount = newValue;

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
      });
    } else {
      setState(() {
        int? itemCount = newValue;

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity =
            itemCount;

        double total = roundDouble(
            (itemCount *
                double.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                    .itemPrice
                    .toString())),
            decimalPlaces);

        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemAmount =
            total.toString();
      });
    }

    getTotalAmount();
  }

  void addToTmp(int index, BuildContext context, bool searching) {
    List<ProductsResponse> listToWork =
        searching ? listOfAllProducts : listOfProducts;

    if (listToWork[index].type == 'tailoring_package') {
      if (listOfProducts[index].packages.isNotEmpty) {
        listOfFabrics =
            listOfProducts[index].packages[0].fabricIds!.split(',').toList();
        listOfPackagePrices = listOfProducts[index].packages[0].pricesJson!;
      } else {
        CustomDialog.show(
            context,
            AppStrings.noFabrics.tr(),
            const Icon(Icons.warning_amber_rounded),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.hold);
        return;
      }
      LoadingDialog.show(context);
      MainViewCubit.get(context)
          .getTailoringTypeById(
              listOfProducts[index].packages[0].tailoringTypeId!)
          .then((value) {
        tailoringType = MainViewCubit.get(context).tailoringType;

        LoadingDialog.hide(context);
        TailorDialog.show(
            context,
            currencyCode,
            index,
            listOfProducts,
            tailoringType!,
            listOfFabrics,
            listOfPackagePrices,
            listOfCustomers,
            discount,
            decimalPlaces,
            _selectedCustomerName!,
            _selectedCustomerTel!,
            _selectedPriceGroupId!,
            deviceWidth!);
      });
      return;
    }

    if (listToWork[index].variations.isNotEmpty) {
      setState(() {
        ItemOptionsDialog.show(
            context,
            currencyCode,
            index,
            listToWork[index].variations,
            listToWork,
            _selectedCustomerTel!,
            _selectedCustomerName!,
            _selectedPriceGroupId!,
            discount,
            deviceWidth!, (done) {
          if (done == 'done') {
            setState(() {
              getTotalAmount();
            });
          }
        },listOfPricingGroups);
      });
    } else {
      ///////////////////////
      if (listOfTmpOrder.isNotEmpty) {
        int listOfTmpOrderIndex = listOfTmpOrder
            .indexWhere((element) => element.productId == listToWork[index].id);


        if (listOfTmpOrderIndex >= 0) {
          if (listToWork[index].sellOverStock == 0 && listToWork[index].isService == 0) {
            if (int.parse(listOfTmpOrder[listOfTmpOrderIndex]
                .itemQuantity
                .toString()) >=
                listToWork[index].stock) {
              noCredit(context);
              return;
            }
          }
        }
      }

      ///////////////////////
      setState(() {
        for (var entry in listOfTmpOrder) {
          if (listToWork[index].name == entry.itemName) {
            int? itemCount = entry.itemQuantity;
            itemCount = itemCount! + 1;
            entry.itemQuantity = itemCount;
            entry.itemAmount =
                (itemCount * double.parse(entry.itemPrice.toString()))
                    .toString();

            if (deviceWidth! <= 600) startAnimation();
            return;
          }
        }

        String customerName, tel = '';
        if (_selectedCustomer != null) {
          customerName =
              '${_selectedCustomer!.firstName} ${_selectedCustomer!.lastName}';
          tel = _selectedCustomer!.mobile;
        } else {
          customerName = '${AppStrings.firstName} ${AppStrings.secondName}';
          tel = '';
        }

        if (listToWork[index].sellOverStock == 0 && listToWork[index].isService == 0) {
          if (listToWork[index].stock == 0) {
            noCredit(context);
            return;
          }
        }



        String sellPrice = listToWork[index].sellPrice;
        // edit with price group
        if (_selectedPriceGroupId != 0) {
          var pricingGroupProductsResponse =
          listOfPricingGroups.firstWhere((element) => element.id == _selectedPriceGroupId).products;
          for (var p in pricingGroupProductsResponse) {
            if (p.id == listToWork[index].id) {
              sellPrice = '${p.price}.000000000000000000000';
            }
          }
        }

        listOfTmpOrder.add(TmpOrderModel(
            id: listToWork[index].id,
            itemName: listToWork[index].type == 'single' ? listToWork[index].name : listToWork[index].name + listToWork[index].variations[index].name,
            itemQuantity: 1,
            itemAmount:
                '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}',
            itemPrice:
                '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}',
            customer: customerName,
            category: listToWork[index].categoryId.toString(),
            orderDiscount: discount,
            brand: listToWork[index].brandId.toString(),
            customerTel: tel,
            date: today.toString().split(" ")[0],
            itemOption: listOfVariations.isNotEmpty
                ? listToWork[index].variations[index].name
                : '',
            productId: listToWork[index].id,
            pricingGroupId: _selectedPriceGroupId,
            variationId: listToWork[index].variations.isNotEmpty
                ? listToWork[index].variations[index].id
                : 0,
            productType: listToWork[index].type));

        if (deviceWidth! <= 600) startAnimation();
      });
      // _quantityControllers.add(TextEditingController());
      // _quantityControllers[index].addListener(getTotalAmount);
    }
  }

  void addToTmpInBottomSheet(int index, BuildContext context, bool searching) {
    List<ProductsResponse> listToWork =
        searching ? listOfAllProducts : listOfProducts;

    if (listToWork[index].type == 'tailoring_package') {
      if (listOfProducts[index].packages.isNotEmpty) {
        listOfFabrics =
            listOfProducts[index].packages[0].fabricIds!.split(',').toList();
        listOfPackagePrices = listOfProducts[index].packages[0].pricesJson!;
      } else {
        CustomDialog.show(
            context,
            AppStrings.noFabrics.tr(),
            const Icon(Icons.warning_amber_rounded),
            ColorManager.white,
            AppConstants.durationOfSnackBar,
            ColorManager.hold);
        return;
      }
      LoadingDialog.show(context);
      MainViewCubit.get(context)
          .getTailoringTypeById(
              listOfProducts[index].packages[0].tailoringTypeId!)
          .then((value) {
        tailoringType = MainViewCubit.get(context).tailoringType;

        LoadingDialog.hide(context);
        TailorDialog.show(
            context,
            currencyCode,
            index,
            listOfProducts,
            tailoringType!,
            listOfFabrics,
            listOfPackagePrices,
            listOfCustomers,
            discount,
            decimalPlaces,
            _selectedCustomerName!,
            _selectedCustomerTel!,
            _selectedPriceGroupId!,
            deviceWidth!);
      });
      return;
    }

    if (listToWork[index].variations.isNotEmpty) {
      _controllerLeftPart.setState!(() {
        ItemOptionsDialog.show(
            context,
            currencyCode,
            index,
            listToWork[index].variations,
            listToWork,
            _selectedCustomerTel!,
            _selectedCustomerName!,
            _selectedPriceGroupId!,
            discount,
            deviceWidth!, (done) {
          if (done == 'done') {
            _controllerLeftPart.setState!(() {
              getTotalAmount();
            });
          }
        },listOfPricingGroups);
      });
    } else {
      ///////////////////////
      if (listOfTmpOrder.isNotEmpty) {
        int listOfTmpOrderIndex = listOfTmpOrder
            .indexWhere((element) => element.productId == listToWork[index].id);

        if (listOfTmpOrderIndex >= 0) {
          if (listToWork[index].sellOverStock == 0 && listToWork[index].isService == 0) {
            if (int.parse(listOfTmpOrder[listOfTmpOrderIndex]
                .itemQuantity
                .toString()) >=
                listToWork[index].stock) {
              noCredit(context);
              return;
            }
          }

        }
      }

      ///////////////////////
      _controllerLeftPart.setState!(() {
        for (var entry in listOfTmpOrder) {
          if (listToWork[index].name == entry.itemName) {
            int? itemCount = entry.itemQuantity;
            itemCount = itemCount! + 1;
            entry.itemQuantity = itemCount;
            entry.itemAmount =
                (itemCount * double.parse(entry.itemPrice.toString()))
                    .toString();
            return;
          }
        }

        String customerName, tel = '';
        if (_selectedCustomer != null) {
          customerName =
              '${_selectedCustomer!.firstName} ${_selectedCustomer!.lastName}';
          tel = _selectedCustomer!.mobile;
        } else {
          customerName = '${AppStrings.firstName} ${AppStrings.secondName}';
          tel = '';
        }

        if (listToWork[index].sellOverStock == 0 && listToWork[index].isService == 0) {
          if (listToWork[index].stock == 0) {
            noCredit(context);
            return;
          }
        }


        String sellPrice = listToWork[index].sellPrice;

        listOfTmpOrder.add(TmpOrderModel(
            id: listToWork[index].id,
            itemName: listToWork[index].type == 'single' ? listToWork[index].name : listToWork[index].name + listToWork[index].variations[index].name,
            itemQuantity: 1,
            itemAmount:
                '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}',
            itemPrice:
                '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}',
            customer: customerName,
            category: listToWork[index].categoryId.toString(),
            orderDiscount: discount,
            brand: listToWork[index].brandId.toString(),
            customerTel: tel,
            date: today.toString().split(" ")[0],
            itemOption: listOfVariations.isNotEmpty
                ? listToWork[index].variations[index].name
                : '',
            productId: listToWork[index].id,
            pricingGroupId: _selectedPriceGroupId,
            variationId: listToWork[index].variations.isNotEmpty
                ? listToWork[index].variations[index].id
                : 0,
            productType: listToWork[index].type));
      });
    }
  }

  // right part --------------------------------------------------------------
  Widget rightPart(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          containerComponent(
              context,
              Padding(
                padding: const EdgeInsets.all(AppPadding.p10),
                child: Column(
                  children: [
                    deviceWidth! <= 600
                        ? Row(
                            children: [
                              customerDropDown(context),
                              SizedBox(
                                width: AppConstants.smallerDistance,
                              ),
                              addAndEditCustomer(
                                  context, getCustomer, addCustomer)
                            ],
                          )
                        : Container(),
                    deviceWidth! <= 600
                        ? SizedBox(
                            height: AppConstants.smallDistance,
                          )
                        : Container(),
                    deviceWidth! <= 600
                        ? searchText(context, _searchEditingController,
                            addToTmp, listOfAllProducts, searchList)
                        : Container(),
                    deviceWidth! <= 600
                        ? SizedBox(
                            height: AppConstants.smallWidthBetweenElements,
                          )
                        : Container(),
                    Row(
                      children: [
                        category(context),
                        SizedBox(
                          width: AppConstants.smallDistance,
                        ),
                        brand(context)
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    categoryFilter!
                        // Category buttons -------------
                        ? categoryButtons(
                            context, listOfCategories, isSelected, deviceWidth!)
                        // Brand buttons -------------
                        : brandButtons(
                            context, listOfBrands, isSelected, deviceWidth!),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    categoryFilter!
                        // Category items -------------
                        ? categoryItems(context, addToTmp, listOfProducts,
                            businessType, deviceWidth!)
                        // Brand items -------------
                        : brandItems(context, addToTmp, listOfProducts,
                            businessType, deviceWidth!)
                  ],
                ),
              ),
              height: MediaQuery.of(context).size.height - 20.h,
              color: ColorManager.white,
              borderColor: ColorManager.white,
              borderWidth: 1.5.w,
              borderRadius: AppSize.s5),
        ],
      ),
    );
  }

  Widget category(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Bounceable(
        duration: Duration(milliseconds: AppConstants.durationOfBounceable),
        onTap: () async {
          await Future.delayed(
              Duration(milliseconds: AppConstants.durationOfBounceable));
          setState(() {
            if (!categoryFilter!) {
              categoryFilter = !categoryFilter!;
              listOfAllProducts = [];
              searchList = [];
              MainViewCubit.get(context).getCategories(locationId);
            }
          });
        },
        child: containerComponent(
            context,
            Center(
                child: Text(
              AppStrings.category.tr(),
              style: TextStyle(
                  color: categoryFilter!
                      ? ColorManager.white
                      : ColorManager.primary,
                  fontSize: AppSize.s20.sp),
            )),
            height: 40.h,
            width: MediaQuery.of(context).size.width,
            color: categoryFilter! ? ColorManager.primary : ColorManager.white,
            borderColor: ColorManager.primary,
            borderWidth: 0.6.w,
            borderRadius: AppSize.s5),
      ),
    );
  }

  Widget brand(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Bounceable(
        duration: Duration(milliseconds: AppConstants.durationOfBounceable),
        onTap: () async {
          await Future.delayed(
              Duration(milliseconds: AppConstants.durationOfBounceable));
          setState(() {
            if (categoryFilter!) {
              categoryFilter = !categoryFilter!;
              listOfAllProducts = [];
              searchList = [];
              MainViewCubit.get(context).getBrands(locationId);
            }
          });
        },
        child: containerComponent(
            context,
            Center(
                child: Text(
              AppStrings.brand.tr(),
              style: TextStyle(
                  color: categoryFilter!
                      ? ColorManager.primary
                      : ColorManager.white,
                  fontSize: AppSize.s20.sp),
            )),
            height: 40.h,
            width: MediaQuery.of(context).size.width,
            color: categoryFilter! ? ColorManager.white : ColorManager.primary,
            borderColor: ColorManager.primary,
            borderWidth: 0.6.w,
            borderRadius: AppSize.s5),
      ),
    );
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
