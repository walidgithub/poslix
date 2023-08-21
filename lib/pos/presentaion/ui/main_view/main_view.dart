﻿import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poslix_app/pos/domain/requests/cart_model.dart';
import 'package:poslix_app/pos/domain/response/customer_model.dart';
import 'package:poslix_app/pos/domain/response/products_model.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/main_view_cubit/main_view_cubit.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/add_edit_customer_buttons.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/brand_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/brand_items.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/customer_dialog/customer_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/discount_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/hold_dialog/hold_card_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/item_options_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports/orders_and_hold_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/payment_dialog/payment_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/shipping_dialog.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/buttons.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/category_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/category_items.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/sales_table/sales_table_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/sales_table/sales_table_head.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/search_text.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/widgets/totals.dart';
import 'package:poslix_app/pos/shared/constant/constant_values_manager.dart';
import 'package:poslix_app/pos/shared/constant/padding_margin_values_manager.dart';
import 'package:poslix_app/pos/shared/style/colors_manager.dart';
import '../../../domain/entities/order_model.dart';
import '../../../domain/entities/tmp_order_model.dart';
import '../../../domain/response/brands_model.dart';
import '../../../domain/response/categories_model.dart';
import '../../../domain/response/stocks_model.dart';
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
import 'inner_dialogs/close_register_dialog/close_register_dialog.dart';
import 'main_view_cubit/main_view_state.dart';

class MainView extends StatefulWidget {
  MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final AppPreferences _appPreferences = sl<AppPreferences>();

  final GlobalKey<AnimatedFloatingActionButtonState> floatingKey =
      GlobalKey<AnimatedFloatingActionButtonState>();

  DateTime today = DateTime.now();

  List<CategoriesResponse> listOfCategories = [];
  List<BrandsResponse> listOfBrands = [];

  List<ProductsResponse> listOfAllProducts = [];
  List<ProductsResponse> listOfBothProducts = [];
  List<String> searchList = [];

  List<ProductsResponse> listOfProducts = [];
  List<VariationsResponse> listOfVariations = [];
  List<StocksResponse> listOfStocks = [];

  List<CustomerResponse> listOfCustomers = [];

  String selectedDiscountType = '';

  int decimalPlaces = 2;
  int locationId = 0;
  int tax = 0;

  int getIndex(int index) {
    int finalIndex = index + 1;
    return finalIndex;
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;

  CustomerResponse? _selectedCustomer;
  String? _selectedCustomerName;

  int? _selectedCustomerId;
  String? _selectedCustomerTel;
  String? _selectedCategory;

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

  double roundDouble(double value, int places) {
    String roundedNumber = value.toStringAsFixed(places);
    return double.parse(roundedNumber);
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
          listOfVariations =
              listOfCategories[currentId].products[currentId].variations;
          listOfStocks = listOfCategories[currentId].products[currentId].stocks;
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
          listOfVariations =
              listOfBrands[currentId].products[currentId].variations;

          listOfStocks = listOfBrands[currentId].products[currentId].stocks;
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

    getToken();
    getDecimalPlaces();
    getLocationId();
    getTax();

    super.initState();
  }

  void getToken() async {
    _appPreferences.getToken(LOGGED_IN_TOKEN)!;
  }

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getLocationId(PREFS_KEY_DECIMAL_PLACES)!;
  }

  void getLocationId() async {
    locationId = _appPreferences.getLocationId(PREFS_KEY_LOCATION_ID)!;
  }

  void getTax() async {
    tax = _appPreferences.getTaxValue(PREFS_KEY_TAX_VALUE)!;
  }

  void reload() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  TextEditingController _searchEditingController = TextEditingController();

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
        CloseRegisterDialog.show(context, locationId);
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
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.secondary,
          body: SingleChildScrollView(child: bodyContent(context)),
          floatingActionButton: AnimatedFloatingActionButton(
              fabButtons: <Widget>[language(), logout(), register(), refresh()],
              key: floatingKey,
              colorStartAnimation: ColorManager.primary,
              colorEndAnimation: ColorManager.delete,
              animatedIconData: AnimatedIcons.menu_close //To principal button
              ),
        ),
      ),
    );
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
        ..getCategories(locationId)
        ..getCustomers(locationId)
        ..getCurrency(locationId),
      child: BlocConsumer<MainViewCubit, MainViewState>(
        listener: (context, state) async {
          if (state is MainNoInternetState) {
            CustomDialog.show(
                context,
                AppStrings.noInternet.tr(),
                const Icon(Icons.wifi),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }

          if (state is LoadingCategories) {
            LoadingDialog.show(context);
          } else if (state is LoadedCategories) {
            LoadingDialog.hide(context);
            listOfCategories = MainViewCubit.get(context).listOfCategories;

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
          } else if (state is LoadingErrorCategories) {
            listOfProducts = [];
            LoadingDialog.hide(context);
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          } else if (state is LoadingBrands) {
            LoadingDialog.show(context);
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
            // LoadingDialog.hide(context);
            listOfProducts = [];
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }
          if (state is LoadingCustomers) {
            LoadingDialog.show(context);
          } else if (state is LoadedCustomers) {
            LoadingDialog.hide(context);
            listOfCustomers = MainViewCubit.get(context).listOfCustomers;
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
                    updatedAt: ''));

            _selectedCustomerName =
                '${listOfCustomers[0].firstName} ${listOfCustomers[0].lastName}';
            _selectedCustomerId = listOfCustomers[0].id;
            _selectedCustomerTel = listOfCustomers[0].mobile;
          } else if (state is LoadingErrorCustomers) {
            LoadingDialog.hide(context);
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          } else if (state is LoadingCustomer) {
            LoadingDialog.show(context);
          } else if (state is LoadedCustomer) {
            LoadingDialog.hide(context);
            int index = listOfCustomers.indexWhere((element) =>
                '${element.firstName} ${element.lastName} | ${element.mobile}' ==
                '${_selectedCustomer?.firstName} ${_selectedCustomer?.lastName} | ${_selectedCustomer?.mobile}');
            CustomerDialog.show(context, 'Edit', listOfCustomers[index],
                _selectedCustomerId!, locationId, (done) {
              if (done == 'done') {
                setState(() {
                  listOfCustomers = [];
                  CustomerResponse? _selectedCustomer2;
                  _selectedCustomer = _selectedCustomer2;
                  MainViewCubit.get(context).getCustomers(locationId);
                });
              }
            });
          } else if (state is LoadingErrorCustomer) {
            LoadingDialog.hide(context);
            CustomDialog.show(
                context,
                AppStrings.errorTryAgain.tr(),
                const Icon(Icons.close),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.delete);
          }

          if (state is LoadedCurrency) {
            currencyCode = state.currencyCode;
          } else if (state is LoadingErrorCurrency) {
            LoadingDialog.hide(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppPadding.p10),
            child: Center(
              child: Row(
                children: [
                  leftPart(context),
                  SizedBox(
                    width: AppConstants.smallDistance,
                  ),
                  rightPart(context),
                ],
              ),
            ),
          );
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
                    Row(
                      children: [
                        customerDropDown(context),
                        SizedBox(
                          width: AppConstants.smallerDistance,
                        ),
                        addAndEditCustomer(context, getCustomer, addCustomer)
                      ],
                    ),

                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),

                    searchText(context, _searchEditingController, addToTmp,
                        listOfAllProducts, searchList),

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
                                  createColumns(),
                                  createRows(context)))),
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
      ),
    );
  }

  Widget customerDropDown(BuildContext context) {
    return Expanded(
        flex: 3,
        child: containerComponent(
            context,
            DropdownButton(
              borderRadius: BorderRadius.circular(AppSize.s5),
              itemHeight: 50.h,
              underline: Container(),
              value: _selectedCustomer,
              items: listOfCustomers.map((item) {
                return DropdownMenuItem(
                    value: item,
                    child: Row(
                      children: [
                        textS14PrimaryComponent(context, item.firstName),
                        SizedBox(width: AppConstants.smallerDistance),
                        textS14PrimaryComponent(context, item.lastName),
                        item.firstName == AppStrings.firstName
                            ? Container()
                            : Row(
                                children: [
                                  SizedBox(width: AppConstants.smallerDistance),
                                  textS14PrimaryComponent(context, '|'),
                                  SizedBox(width: AppConstants.smallerDistance),
                                  textS14PrimaryComponent(context, item.mobile)
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
                  _selectedCustomerTel = selectedCustomer?.mobile;
                });
              },
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
              icon: Icon(
                Icons.arrow_drop_down,
                color: ColorManager.primary,
                size: AppSize.s20.sp,
              ),
              style: TextStyle(
                  color: ColorManager.primary, fontSize: AppSize.s14.sp),
            ),
            padding: const EdgeInsets.fromLTRB(
                AppPadding.p15, AppPadding.p2, AppPadding.p5, AppPadding.p2),
            height: 47.h,
            borderColor: ColorManager.primary,
            borderWidth: 0.5.w,
            borderRadius: AppSize.s5));
  }

  void getCustomer(BuildContext context) {
    if (_selectedCustomerId != 1) {
      setState(() {
        MainViewCubit.get(context).getCustomer(_selectedCustomerId!);
      });
    }
  }

  void addCustomer(BuildContext context) {
    CustomerDialog.show(context, 'Add', [], 0, locationId, (done) {
      if (done == 'done') {
        setState(() {
          MainViewCubit.get(context).getCustomers(locationId);
        });
      }
    });
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
      });
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

      holdOrdersDialog(context, listOfTmpOrder, discount, _selectedCustomerTel!,
          _selectedCustomerName!, (done) {
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

        discount = 0;
        differenceValue = 0;
        originalTotalValue = 0;
        estimatedTax = 0;
        shippingCharge = 0;
        GlobalValues.setEditOrder = false;
      });
    }
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
      }
    }, (orderTotal) {
      originalTotalValue = orderTotal;
    }, (orderDiscount) {
      setState(() {
        discount = double.parse(orderDiscount.toString());
      });
    });
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
          setState(() {
            categoryFilter = true;
            listOfBothProducts = [];
            listOfAllProducts = [];
            searchList = [];
            MainViewCubit.get(context).getCategories(locationId);
          });
        }
      });

      discount = 0;
      estimatedTax = 0;
      shippingCharge = 0;
      totalAmount = 0;
      differenceValue = 0;

      listOfTmpOrder.clear();
    }
  }

  List<DataRow> createRows(BuildContext context) {
    return listOfTmpOrder
        .map((tmpOrder) => DataRow(cells: [
              DataCell(Text(
                getIndex(listOfTmpOrder.indexOf(tmpOrder)).toString(),
                style: TextStyle(color: ColorManager.edit),
              )),
              DataCell(SizedBox(
                width: 40.w,
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
                width: 42.w,
                child: Center(
                  child: Row(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Bounceable(
                                duration: Duration(
                                    milliseconds:
                                        AppConstants.durationOfBounceable),
                                onTap: () async {
                                  await Future.delayed(Duration(
                                      milliseconds:
                                          AppConstants.durationOfBounceable));
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
                                    padding:
                                        const EdgeInsets.all(AppPadding.p08),
                                    color: ColorManager.primary,
                                    borderColor: ColorManager.primary,
                                    borderWidth: 0.1.w,
                                    borderRadius: AppSize.s5))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: AppConstants.smallerDistance,
                      ),
                      containerComponent(
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
                                      width: 10.w,
                                      color: ColorManager.secondary,
                                      borderColor: ColorManager.secondary,
                                      borderWidth: 1.w,
                                      borderRadius: AppSize.s5),
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
                                    await increaseCount(tmpOrder);
                                  },
                                  child: containerComponent(
                                      context,
                                      Icon(
                                        Icons.add,
                                        size: AppSize.s10.sp,
                                      ),
                                      height: 20.h,
                                      width: 10.w,
                                      color: ColorManager.secondary,
                                      borderColor: ColorManager.secondary,
                                      borderWidth: 1.w,
                                      borderRadius: AppSize.s5),
                                ),
                              ],
                            ),
                          ),
                          height: 30.h,
                          width: 30.w,
                          color: ColorManager.white,
                          borderColor: ColorManager.badge,
                          borderWidth: 0.5.w,
                          borderRadius: AppSize.s5)
                    ],
                  ),
                ),
              ))),
              DataCell(SizedBox(
                width: 20.w,
                child: Center(
                    child: Text(
                        listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
                            .itemAmount
                            .toString(),
                        style: TextStyle(fontSize: AppSize.s12.sp),
                        textAlign: TextAlign.center)),
              ))
            ]))
        .toList();
  }

  Future<void> decreaseCount(TmpOrderModel tmpOrder) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));
    setState(() {
      int? itemCount =
          listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;
      itemCount = itemCount! - 1;
      listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity = itemCount;

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

  Future<void> increaseCount(TmpOrderModel tmpOrder) async {
    await Future.delayed(
        Duration(milliseconds: AppConstants.durationOfBounceable));
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

    if (int.parse(listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)]
            .itemQuantity
            .toString()) >=
        qty) {
      CustomDialog.show(
          context,
          AppStrings.noCredit.tr(),
          const Icon(Icons.warning_amber_rounded),
          ColorManager.white,
          AppConstants.durationOfSnackBar,
          ColorManager.hold);
      return;
    }

    setState(() {
      int? itemCount =
          listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity;

      itemCount = itemCount! + 1;

      listOfTmpOrder[listOfTmpOrder.indexOf(tmpOrder)].itemQuantity = itemCount;

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

  void addToTmp(int index, BuildContext context, bool searching) {
    List<ProductsResponse> listToWork =
        searching ? listOfAllProducts : listOfProducts;

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
            discount);
      });
    } else {
      ///////////////////////
      if (listOfTmpOrder.isNotEmpty) {
        int listOfTmpOrderIndex = listOfTmpOrder
            .indexWhere((element) => element.productId == listToWork[index].id);

        if (listOfTmpOrderIndex >= 0) {
          if (int.parse(listOfTmpOrder[listOfTmpOrderIndex]
                  .itemQuantity
                  .toString()) >=
              listToWork[index].stock) {
            CustomDialog.show(
                context,
                AppStrings.noCredit.tr(),
                const Icon(Icons.warning_amber_rounded),
                ColorManager.white,
                AppConstants.durationOfSnackBar,
                ColorManager.hold);
            return;
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

        if (listToWork[index].stock == 0) {
          CustomDialog.show(
              context,
              AppStrings.noCredit.tr(),
              const Icon(Icons.warning_amber_rounded),
              ColorManager.white,
              AppConstants.durationOfSnackBar,
              ColorManager.hold);
          return;
        }

        String sellPrice = listToWork[index].sellPrice;

        listOfTmpOrder.add(TmpOrderModel(
          id: listToWork[index].id,
          itemName: listToWork[index].name,
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
          variationId: listToWork[index].variations.isNotEmpty
              ? listToWork[index].variations[index].id
              : 0,
        ));
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
                        ? categoryButtons(context, listOfCategories, isSelected)
                        // Brand buttons -------------
                        : brandButtons(context, listOfBrands, isSelected),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    categoryFilter!
                        // Category items -------------
                        ? categoryItems(context, addToTmp, listOfProducts)
                        // Brand items -------------
                        : brandItems(context, addToTmp, listOfProducts)
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

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppStrings.warning.tr()),
            content: Text(AppStrings.closeApp.tr()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppStrings.no.tr())),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppStrings.yes.tr())),
            ],
          );
        });
    return exitApp ?? false;
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}