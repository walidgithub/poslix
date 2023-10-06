import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/hold_table/hold_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/hold_table/hold_head_table.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_items_table/items_rows.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_items_table/items_total.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_items_table/orders_items_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_items_table/orders_items_table.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_table/orders_columns.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/orders_table/orders_head_table.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/others/auto_complete.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/others/back_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/others/hold_button.dart';
import 'package:poslix_app/pos/presentaion/ui/main_view/inner_dialogs/orders_reports_dialog/widgets/others/search_section.dart';
import 'package:poslix_app/pos/shared/utils/utils.dart';

import '../../../../../domain/entities/hold_order_items_model.dart';
import '../../../../../domain/entities/hold_order_names_model.dart';
import '../../../../../domain/entities/tmp_order_model.dart';
import '../../../../../domain/response/sales_report_data_model.dart';
import '../../../../../domain/response/sales_report_items_model.dart';
import '../../../../../shared/constant/assets_manager.dart';
import '../../../../../shared/constant/constant_values_manager.dart';
import '../../../../../shared/constant/language_manager.dart';
import '../../../../../shared/constant/padding_margin_values_manager.dart';
import '../../../../../shared/constant/strings_manager.dart';
import '../../../../../shared/preferences/app_pref.dart';
import '../../../../../shared/style/colors_manager.dart';
import '../../../../../shared/utils/global_values.dart';
import '../../../../di/di.dart';
import '../../../components/close_button.dart';
import '../../../components/container_component.dart';
import '../../../popup_dialogs/loading_dialog.dart';
import '../hold_dialog/local_main_view_cubit/local_main_view_cubit.dart';
import '../hold_dialog/local_main_view_cubit/local_main_view_state.dart';
import 'orders_cubit/orders_cubit.dart';
import 'orders_cubit/orders_state.dart';

class OrdersDialog extends StatefulWidget {
  Function customerName;
  Function orderDiscount;
  Function orderTotalAmount;
  int locationId;
  double deviceWidth;
  static void show(BuildContext context, int locationId, Function customerName,
      Function orderTotalAmount, Function orderDiscount, double deviceWidth) =>
      isApple() ? showCupertinoDialog<void>(context: context,useRootNavigator: false,
          barrierDismissible: false, builder: (_) => OrdersDialog(
            locationId: locationId,
            customerName: customerName,
            orderTotalAmount: orderTotalAmount,
            orderDiscount: orderDiscount,
            deviceWidth: deviceWidth,
          )).then((_) => FocusScope.of(context).requestFocus(FocusNode())) : showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => OrdersDialog(
          locationId: locationId,
          customerName: customerName,
          orderTotalAmount: orderTotalAmount,
          orderDiscount: orderDiscount,
          deviceWidth: deviceWidth,
        ),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  OrdersDialog(
      {required this.locationId,
        required this.customerName,
        required this.orderTotalAmount,
        required this.orderDiscount,
        required this.deviceWidth,
        super.key});

  @override
  State<OrdersDialog> createState() => _OrdersDialogState();
}

class _OrdersDialogState extends State<OrdersDialog> {
  TextEditingController _searchEditingController = TextEditingController();
  final AppPreferences _appPreferences = sl<AppPreferences>();

  @override
  void dispose() {
    // _searchEditingController.dispose();
    super.dispose();
  }

  int currentPage = 0;
  int totalPages = 0;
  List<int> middlePages = [];

  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;

  var selectedSearchType = AppStrings.customer.tr();

  bool? orderFilter;
  bool? orderItems;
  double totalAmount = 0;

  bool searching = false;

  List<String> searchList = [];

  List<SalesReportDataModel> listOfOrderHeadForSearch = [];

  List<SalesReportDataModel> listOfOrderHead = [];
  List<SalesReportDataModel> listOfAllOrderHead = [];
  List<SalesReportItemsResponse> listOfOrderItems = [];

  int? orderId;

  List<HoldOrderNamesModel> listOfHoldOrderNamesForSearch = [];

  List<HoldOrderNamesModel> listOfHoldOrderNames = [];
  List<HoldOrderItemsModel> listOfHoldOrderItems = [];

  int decimalPlaces = 2;

  double mobileDialogHeight = 320.h;

  void getDecimalPlaces() async {
    decimalPlaces = _appPreferences.getLocationId(PREFS_KEY_DECIMAL_PLACES)!;
  }

  double roundDouble(double value, int places) {
    String roundedNumber = value.toStringAsFixed(places);
    return double.parse(roundedNumber);
  }

  @override
  void initState() {
    getDecimalPlaces();
    orderFilter = false;
    orderItems = false;
    for (var element in listOfHoldOrderNames) {
      if (selectedSearchType == AppStrings.holdName.tr()) {
        searchList.add(element.holdText!);
      } else if (selectedSearchType == AppStrings.customer.tr()) {
        searchList.add(element.customer!);
      } else if (selectedSearchType == AppStrings.tel.tr()) {
        searchList.add(element.customerTel!);
      }
    }
    super.initState();
  }

  void searchInList(String query) {
    if (orderFilter!) {
      if (selectedSearchType == AppStrings.customer.tr()) {
        final newList = listOfOrderHead.where((element) {
          final searchRow = element.contactName;
          final searchText = query;

          return searchRow.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfOrderHeadForSearch = newList;
        });
      } else if (selectedSearchType == AppStrings.tel.tr()) {
        final newList = listOfOrderHead.where((element) {
          final searchRow = element.contactMobile;
          final searchText = query;

          return searchRow.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfOrderHeadForSearch = newList;
        });
      } else if (selectedSearchType == AppStrings.orderId.tr()) {
        final newList = listOfOrderHead.where((element) {
          final searchRow = element.id.toString();
          final searchText = query;

          return searchRow.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfOrderHeadForSearch = newList;
        });
      }
    } else if (!orderFilter!) {
      if (selectedSearchType == AppStrings.customer.tr()) {
        final newList = listOfHoldOrderNames.where((element) {
          final searchRow = element.customer;
          final searchText = query;

          return searchRow!.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfHoldOrderNamesForSearch = newList;
        });
      } else if (selectedSearchType == AppStrings.tel.tr()) {
        final newList = listOfHoldOrderNames.where((element) {
          final searchRow = element.customerTel;
          final searchText = query;

          return searchRow!.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfHoldOrderNamesForSearch = newList;
        });
      } else if (selectedSearchType == AppStrings.holdName.tr()) {
        final newList = listOfHoldOrderNames.where((element) {
          final searchRow = element.holdText;
          final searchText = query;

          return searchRow!.contains(searchText);
        }).toList();

        setState(() {
          searching = true;
          listOfHoldOrderNamesForSearch = newList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RotatedBox(
        quarterTurns: widget.deviceWidth <= 600 ? 0 : 0,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: widget.deviceWidth <= 600 ? mobileDialogHeight : 430.h,
              width: widget.deviceWidth <= 600 ? 400.w : 180.w,
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(AppSize.s5),
                  boxShadow: [BoxShadow(color: ColorManager.badge)]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        holdButton(context, holdAction, orderItems!, orderFilter!, widget.deviceWidth, isRtl()),
                        ordersButton(context),
                      ],
                    ),
                    SizedBox(
                      height: AppConstants.smallDistance,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        orderItems! ? itemsTotal(context, searching, orderId!, listOfOrderHead, listOfOrderHeadForSearch, totalAmount) : autoComplete(context, _searchEditingController, searchInList, widget.deviceWidth),
                        orderItems!
                            ? Container()
                            : SizedBox(
                          width: AppConstants.smallDistance,
                        ),
                        orderItems! ? Container() : searchSection(context, searchAction, _searchEditingController,orderFilter!, selectedSearchType, widget.deviceWidth),
                      ],
                    ),
                    tableSection(context),
                    SizedBox(
                      height: AppConstants.heightBetweenElements,
                    ),
                    const Divider(
                      thickness: AppSize.s1,
                    ),
                    SizedBox(
                      height: AppConstants.smallerDistance,
                    ),
                    widget.deviceWidth <= 600 && orderFilter! ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        pagination(context),
                        SizedBox(
                          height: AppConstants.heightBetweenElements,
                        ),
                        closeButton(context),
                      ],
                    ) : Row(
                      mainAxisAlignment: orderFilter! || orderItems!
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        closeButton(context),
                        orderFilter!
                            ? SizedBox(
                          width: AppConstants.smallDistance,
                        )
                            : Container(),
                        orderFilter! ? pagination(context) : Container(),
                        orderItems! ? backButton(context, backAction, widget.deviceWidth) : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void holdAction() {
    setState(() {
      searching = false;
      listOfHoldOrderNamesForSearch = [];
      listOfOrderHeadForSearch = [];

      if (orderFilter!) {
        _searchEditingController.text = '';
        searchList = [];

        if (selectedSearchType == AppStrings.orderId.tr()) {
          selectedSearchType = AppStrings.holdName.tr();
        }

        orderFilter = !orderFilter!;
        orderItems = false;

        if (widget.deviceWidth <= 600) {
          mobileDialogHeight = 320.h;
        }
        for (var element in listOfHoldOrderNames) {
          if (selectedSearchType == AppStrings.holdName.tr()) {
            searchList.add(element.holdText!);
          } else if (selectedSearchType == AppStrings.customer.tr()) {
            searchList.add(element.customer!);
          } else if (selectedSearchType == AppStrings.tel.tr()) {
            searchList.add(element.customerTel!);
          }
        }
      }
    });
  }

  Widget ordersButton(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersCubit>(),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) async {
          if (state is OrdersNoInternetState) {
            showNoInternet(context);

            await Future.delayed(
                Duration(milliseconds: AppConstants.durationOfSnackBar));

            OrdersDialog.hide(context);
          }

          if (state is LoadingAllOrderReport) {
            LoadingDialog.show(context);
          }

          if (state is AllOrderReportSucceed) {
            LoadingDialog.hide(context);

            listOfAllOrderHead = OrdersCubit.get(context).listOfAllOrderHead;

            totalPages = listOfAllOrderHead.length;

            if (totalPages != 0) {
              currentPage = 1;
              middlePages = [];

              if (totalPages >= 5) {
                middlePages = [
                  currentPage + 1,
                  currentPage + 2,
                  currentPage + 3
                ];
              } else {
                for (int i = 1; i < totalPages - 1; i++) {
                  middlePages.add(i + 1);
                }
              }
            } else {
              currentPage = 0;
              middlePages = [];
            }

            _searchEditingController.text = '';
            searchList = [];

            if (selectedSearchType == AppStrings.holdName.tr()) {
              selectedSearchType = AppStrings.orderId.tr();
            }

            for (var element in listOfAllOrderHead) {
              if (selectedSearchType == AppStrings.orderId.tr()) {
                searchList.add(element.id.toString());
              } else if (selectedSearchType == AppStrings.customer.tr()) {
                searchList.add(element.contactName);
              } else if (selectedSearchType == AppStrings.tel.tr()) {
                searchList.add(element.contactMobile);
              }
            }
          } else if (state is AllOrderReportError) {
            LoadingDialog.hide(context);
            tryAgainLater(context);
          }
        },
        builder: (context, state) {
          return Bounceable(
            duration: Duration(milliseconds: AppConstants.durationOfBounceable),
            onTap: () async {
              await Future.delayed(
                  Duration(milliseconds: AppConstants.durationOfBounceable));

              await OrdersCubit.get(context).getOrderReport(widget.locationId);

              setState(() {
                if (!orderFilter!) {
                  searching = false;
                  listOfHoldOrderNamesForSearch = [];
                  listOfOrderHeadForSearch = [];

                  _searchEditingController.text = '';
                  searchList = [];
                  orderFilter = !orderFilter!;
                  orderItems = false;

                  if (widget.deviceWidth <= 600 && orderFilter == true) {
                    mobileDialogHeight = 380.h;
                  }
                  if (selectedSearchType == AppStrings.holdName.tr()) {
                    selectedSearchType = AppStrings.orderId.tr();
                  }
                }
              });
            },
            child: Container(
              height: 40.h,
              width: widget.deviceWidth <= 600 ? 150.w : 60.w,
              padding: const EdgeInsets.fromLTRB(
                  AppPadding.p0, AppPadding.p5, AppPadding.p0, AppPadding.p5),
              decoration: BoxDecoration(
                  color: orderItems!
                      ? ColorManager.primary
                      : orderFilter!
                      ? ColorManager.primary
                      : ColorManager.white,
                  border: Border.all(color: ColorManager.primary, width: 0.5.w),
                  borderRadius: isRtl() ? const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.s5),
                      topLeft: Radius.circular(AppSize.s5)) : const BorderRadius.only(
                      bottomRight: Radius.circular(AppSize.s5),
                      topRight: Radius.circular(AppSize.s5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    ImageAssets.listOrders,
                    width: AppSize.s25,
                    color: orderItems!
                        ? ColorManager.white
                        : orderFilter!
                        ? ColorManager.white
                        : ColorManager.primary,
                  ),
                  Center(
                      child: Text(
                        AppStrings.orders.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: orderItems!
                                ? ColorManager.white
                                : orderFilter!
                                ? ColorManager.white
                                : ColorManager.primary,
                            fontSize: AppSize.s18.sp),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tableSection(BuildContext context) {
    return SizedBox(
      height: widget.deviceWidth <= 600 ? 130.h : 232.h,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: orderItems!
                  ? BlocProvider(
                create: (context) => sl<OrdersCubit>(),
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    return createOrderItemsDataTable(_currentSortColumn, _isSortAsc, createOrderItemsColumns(widget.deviceWidth), createOrderItemsRows(decimalPlaces, listOfOrderItems, widget.deviceWidth), widget.deviceWidth);
                  },
                ),
              )
                  : orderFilter!
                  ? BlocProvider(
                create: (context) => sl<OrdersCubit>()
                  ..getOrderReportByPage(
                      widget.locationId, currentPage),
                child: BlocConsumer<OrdersCubit, OrdersState>(
                  listener: (context, state) async {
                    if (state is OrdersNoInternetState) {
                      showNoInternet(context);

                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfSnackBar));

                      OrdersDialog.hide(context);
                    }

                    if (state is LoadingOrderReport) {
                      LoadingDialog.show(context);
                    }

                    if (state is OrderReportSucceed) {
                      LoadingDialog.hide(context);
                      listOfOrderHead =
                          OrdersCubit.get(context).listOfOrderHead;

                      _searchEditingController.text = '';
                      searchList = [];

                      if (selectedSearchType ==
                          AppStrings.holdName.tr()) {
                        selectedSearchType = AppStrings.orderId.tr();
                      }

                      for (var element in listOfOrderHead) {
                        if (selectedSearchType ==
                            AppStrings.orderId.tr()) {
                          searchList.add(element.id.toString());
                        } else if (selectedSearchType ==
                            AppStrings.customer.tr()) {
                          searchList.add(element.contactName);
                        } else if (selectedSearchType ==
                            AppStrings.tel.tr()) {
                          searchList.add(element.contactMobile);
                        }
                      }
                    } else if (state is OrderReportError) {
                      LoadingDialog.hide(context);
                      tryAgainLater(context);
                    }
                  },
                  builder: (context, state) {
                    return createOrdersDataTable(_currentSortColumn, _isSortAsc, searching, createOrdersColumns(widget.deviceWidth), _createOrdersRows(), _createOrdersRowsForSearch(), widget.deviceWidth);
                  },
                ),
              )
                  : BlocProvider(
                create: (context) =>
                sl<MainViewLocalCubit>()..getHoldCards(),
                child: BlocConsumer<MainViewLocalCubit,
                    MainViewLocalState>(
                  listener: (context, state) {
                    if (state is LoadingHoldCards) {
                    } else if (state is LoadedHoldCards) {
                      listOfHoldOrderNames =
                          MainViewLocalCubit.get(context)
                              .listOfHoldOrderNames;

                      _searchEditingController.text = '';
                      searchList = [];

                      if (selectedSearchType ==
                          AppStrings.orderId.tr()) {
                        selectedSearchType = AppStrings.holdName.tr();
                      }

                      for (var element in listOfHoldOrderNames) {
                        if (selectedSearchType ==
                            AppStrings.holdName.tr()) {
                          searchList.add(element.holdText!);
                        } else if (selectedSearchType ==
                            AppStrings.customer.tr()) {
                          searchList.add(element.customer!);
                        } else if (selectedSearchType ==
                            AppStrings.tel.tr()) {
                          searchList.add(element.customerTel!);
                        }
                      }
                    } else if (state is LoadingErrorHoldCards) {}
                  },
                  builder: (context, state) {
                    return createHoldOrdersDataTable(_currentSortColumn, _isSortAsc, searching, createHoldOrdersColumns(widget.deviceWidth), _createHoldOrdersRows(), _createHoldOrdersForSearchRows(), widget.deviceWidth);
                  },
                ),
              ))),
    );
  }

  void searchAction(String selectedSearch) {
    setState(() {
      searchList = [];
      selectedSearchType = selectedSearch;
      if (!orderFilter!) {
        for (var element in listOfHoldOrderNames) {
          if (selectedSearchType == AppStrings.holdName.tr()) {
            searchList.add(element.holdText!);
          } else if (selectedSearchType == AppStrings.customer.tr()) {
            searchList.add(element.customer!);
          } else if (selectedSearchType == AppStrings.tel.tr()) {
            searchList.add(element.customerTel!);
          }
        }
      } else if (orderFilter!) {
        for (var element in listOfOrderHead) {
          if (selectedSearchType == AppStrings.orderId.tr()) {
            searchList.add(element.id.toString());
          } else if (selectedSearchType == AppStrings.customer.tr()) {
            searchList.add(element.contactName);
          } else if (selectedSearchType == AppStrings.tel.tr()) {
            searchList.add(element.contactMobile);
          }
        }
      }
    });
  }

  Widget pagination(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<OrdersCubit>(),
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) async {
            if (state is OrdersNoInternetState) {
              showNoInternet(context);

              await Future.delayed(
                  Duration(milliseconds: AppConstants.durationOfSnackBar));

              OrdersDialog.hide(context);
            }

            if (state is LoadingOrderReport) {
              LoadingDialog.show(context);
            }

            if (state is OrderReportSucceed) {
              LoadingDialog.hide(context);

              listOfOrderHead = OrdersCubit.get(context).listOfOrderHead;

              _searchEditingController.text = '';
              searchList = [];

              if (selectedSearchType == AppStrings.holdName.tr()) {
                selectedSearchType = AppStrings.orderId.tr();
              }

              for (var element in listOfOrderHead) {
                if (selectedSearchType == AppStrings.orderId.tr()) {
                  searchList.add(element.id.toString());
                } else if (selectedSearchType == AppStrings.customer.tr()) {
                  searchList.add(element.contactName);
                } else if (selectedSearchType == AppStrings.tel.tr()) {
                  searchList.add(element.contactMobile);
                }
              }
            } else if (state is OrderReportError) {
              LoadingDialog.hide(context);
              tryAgainLater(context);
            }
          },
          builder: (context, state) {
            return Row(
              mainAxisAlignment: widget.deviceWidth <=600 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
              children: [
                // decrease current page
                Bounceable(
                    duration: Duration(
                        milliseconds: AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds: AppConstants.durationOfBounceable));
                      if (currentPage >= 2) {
                        setState(() {
                          currentPage--;
                          OrdersCubit.get(context).getOrderReportByPage(
                              widget.locationId, currentPage);

                          if (totalPages >= 5) {
                            if (currentPage == middlePages[0] &&
                                (currentPage - 1) != 1 &&
                                totalPages >= 5) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }

                            if (currentPage == middlePages[1] &&
                                (currentPage + 2) != totalPages) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }

                            if (currentPage == middlePages[2] &&
                                (currentPage + 1) != totalPages) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }
                          }
                        });
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: AppSize.s25.sp,
                      color: currentPage > 1
                          ? ColorManager.primary
                          : ColorManager.primary.withOpacity(0.5),
                    )),

                // current page = 1
                Bounceable(
                    duration: Duration(
                        milliseconds: AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds: AppConstants.durationOfBounceable));
                      setState(() {
                        currentPage = 1;
                        OrdersCubit.get(context).getOrderReportByPage(
                            widget.locationId, currentPage);

                        if (totalPages >= 5) {
                          middlePages = [
                            currentPage + 1,
                            currentPage + 2,
                            currentPage + 3
                          ];
                        }
                      });
                    },
                    child: containerComponent(
                        context,
                        Center(
                          child: Text('1',
                              style: TextStyle(
                                  color: currentPage == 1
                                      ? ColorManager.white
                                      : ColorManager.primary,
                                  fontSize: 20.sp)),
                        ),
                        height: 30.h,
                        width: widget.deviceWidth <= 600 ? 30.w : 10.w,
                        color: currentPage == 1
                            ? ColorManager.primary
                            : ColorManager.white,
                        borderColor: ColorManager.white,
                        borderWidth: 0.0.w,
                        borderRadius: AppSize.s5)),

                totalPages >= 5
                    ? middlePages[0] - 1 > 1
                    ? Text(
                  '..',
                  style: TextStyle(
                      color: ColorManager.primary, fontSize: 20.sp),
                )
                    : Container()
                    : Container(),

                totalPages >= 5
                    ? middlePages[0] - 1 > 1
                    ? SizedBox(
                  width: AppConstants.smallerDistance,
                )
                    : Container()
                    : Container(),

                currentPage > 1 ? SizedBox(
                  width: AppConstants.smallerDistance,
                ) : Container(),

                // middle current pages
                Row(
                  children: [
                    SizedBox(
                      height: 30.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: middlePages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Bounceable(
                                  duration: Duration(
                                      milliseconds:
                                      AppConstants.durationOfBounceable),
                                  onTap: () async {
                                    await Future.delayed(Duration(
                                        milliseconds:
                                        AppConstants.durationOfBounceable));
                                    setState(() {
                                      currentPage = middlePages[index];

                                      OrdersCubit.get(context)
                                          .getOrderReportByPage(
                                          widget.locationId, currentPage);

                                      if (totalPages >= 5) {
                                        if (currentPage == middlePages[0] &&
                                            (currentPage - 1) != 1) {
                                          middlePages = [];
                                          middlePages = [
                                            currentPage - 1,
                                            currentPage,
                                            currentPage + 1
                                          ];
                                        }

                                        if (currentPage == middlePages[1] &&
                                            (currentPage + 2) != totalPages) {
                                          middlePages = [];
                                          middlePages = [
                                            currentPage - 1,
                                            currentPage,
                                            currentPage + 1
                                          ];
                                        }

                                        if (currentPage == middlePages[2] &&
                                            (currentPage + 1) != totalPages) {
                                          middlePages = [];
                                          middlePages = [
                                            currentPage - 1,
                                            currentPage,
                                            currentPage + 1
                                          ];
                                        }
                                      }
                                    });
                                  },
                                  child: containerComponent(
                                      context,
                                      margin: const EdgeInsets.only(left: 2),
                                      width: widget.deviceWidth <= 600 ? 30.w : 10.w,
                                      Center(
                                          child: Text(
                                              middlePages[index].toString(),
                                              style: TextStyle(
                                                  color: currentPage ==
                                                      middlePages[index]
                                                      ? ColorManager.white
                                                      : ColorManager.primary,
                                                  fontSize: 20.sp))),
                                      padding: const EdgeInsets.fromLTRB(
                                          AppPadding.p5,
                                          AppPadding.p0,
                                          AppPadding.p5,
                                          AppPadding.p0),
                                      color: currentPage == middlePages[index]
                                          ? ColorManager.primary
                                          : ColorManager.white,
                                      borderColor:
                                      currentPage == middlePages[index]
                                          ? ColorManager.primary
                                          : ColorManager.white,
                                      borderWidth: 0.0.w,
                                      borderRadius: AppSize.s5))
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: AppConstants.smallerDistance,
                ),

                totalPages >= 5
                    ? middlePages[2] < totalPages - 1
                    ? Text(
                  '..',
                  style: TextStyle(
                      color: ColorManager.primary, fontSize: 20.sp),
                )
                    : Container()
                    : Container(),

                totalPages >= 5
                    ? middlePages[2] < totalPages - 1
                    ? SizedBox(
                  width: AppConstants.smallerDistance,
                )
                    : Container()
                    : Container(),

                // last current page
                totalPages > 1
                    ? Row(
                  children: [
                    Bounceable(
                        duration: Duration(
                            milliseconds:
                            AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds:
                              AppConstants.durationOfBounceable));
                          setState(() {
                            currentPage = totalPages;
                            OrdersCubit.get(context).getOrderReportByPage(
                                widget.locationId, currentPage);

                            if (totalPages >= 5) {
                              middlePages = [
                                currentPage - 3,
                                currentPage - 2,
                                currentPage - 1
                              ];
                            }
                          });
                        },
                        child: containerComponent(
                            context,
                            Center(
                              child: Text(totalPages.toString(),
                                  style: TextStyle(
                                      color: currentPage == totalPages
                                          ? ColorManager.white
                                          : ColorManager.primary,
                                      fontSize: 20.sp)),
                            ),
                            height: 30.h,
                            padding: const EdgeInsets.fromLTRB(
                                AppPadding.p5,
                                AppPadding.p0,
                                AppPadding.p5,
                                AppPadding.p0),
                            color: totalPages == currentPage
                                ? ColorManager.primary
                                : ColorManager.badge,
                            borderColor: totalPages == currentPage
                                ? ColorManager.primary
                                : ColorManager.badge,
                            borderWidth: 0.0.w,
                            borderRadius: AppSize.s5))
                  ],
                )
                    : Container(),

                totalPages > 1
                    ? SizedBox(
                  width: AppConstants.smallDistance,
                )
                    : Container(),

                // increase current page
                Bounceable(
                    duration: Duration(
                        milliseconds: AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds: AppConstants.durationOfBounceable));

                      if (currentPage < totalPages) {
                        setState(() {
                          currentPage++;
                          OrdersCubit.get(context).getOrderReportByPage(
                              widget.locationId, currentPage);
                          if (totalPages >= 5) {
                            if (currentPage == middlePages[0] &&
                                (currentPage - 1) != 1) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }

                            if (currentPage == middlePages[1] &&
                                (currentPage + 2) != totalPages) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }

                            if (currentPage == middlePages[2] &&
                                (currentPage + 1) != totalPages) {
                              middlePages = [];
                              middlePages = [
                                currentPage - 1,
                                currentPage,
                                currentPage + 1
                              ];
                            }
                          }
                        });
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios,
                        size: AppSize.s25.sp,
                        color: currentPage == totalPages
                            ? ColorManager.primary.withOpacity(0.5)
                            : ColorManager.primary)),
              ],
            );
          },
        ));
  }

  void backAction() {
    setState(() {
      orderItems = false;
      orderFilter = true;
      if (widget.deviceWidth <= 600) {
        mobileDialogHeight = 380.h;
      }
    });
  }

  //Orders--------------------------------------------------------------------------

  List<DataRow> _createOrdersRows() {
    return listOfOrderHead
        .map((order) => DataRow(cells: [
      DataCell(Text(
          listOfOrderHead[listOfOrderHead.indexOf(order)].id.toString(),
          style: TextStyle(color: ColorManager.edit))),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 120.w : 40.w,
        child: Center(
            child: Text(
                listOfOrderHead[listOfOrderHead.indexOf(order)].contactName.trim() == '' ? '${AppStrings.firstName} ${AppStrings.secondName}' : listOfOrderHead[listOfOrderHead.indexOf(order)].contactName.toString(),
                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 70.w : 25.w,
        child: Center(
            child: Text(
                listOfOrderHead[listOfOrderHead.indexOf(order)]
                    .subTotal
                    .toString(),
                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) async {
                if (state is OrdersNoInternetState) {
                  showNoInternet(context);

                  await Future.delayed(Duration(
                      milliseconds: AppConstants.durationOfSnackBar));

                  OrdersDialog.hide(context);
                }

                if (state is LoadingOrderReportItems) {
                  LoadingDialog.show(context);
                }

                if (state is OrderReportItemsSucceed) {
                  LoadingDialog.hide(context);
                  listOfOrderItems =
                      OrdersCubit.get(context).listOfOrderItems;

                  var getOrdersItems = listOfOrderItems
                      .where((element) => element.orderId == order.id);

                  widget.orderDiscount(order.discount);

                  widget.orderTotalAmount(
                      double.parse(order.subTotal.toString()));

                  listOfTmpOrder.clear();

                  for (var element in getOrdersItems.first.products) {
                    String sellPrice = element.sellPrice;

                    if (element.variations.isNotEmpty) {
                      sellPrice = element
                          .variations[listOfOrderHead.indexOf(order)]
                          .price;
                    }

                    String amount =
                        '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}';

                    String productQty = element.productQty;

                    listOfTmpOrder.add(TmpOrderModel(
                        id: element.id,
                        date: getOrdersItems.first.date,
                        category: element.categoryId.toString(),
                        brand: element.brandId.toString(),
                        customer:
                        '${getOrdersItems.first.contactFirstName} ${getOrdersItems.first.contactFirstName}',
                        itemAmount: (roundDouble(
                            double.parse(amount) *
                                double.parse(productQty),
                            decimalPlaces))
                            .toString(),
                        itemName: element.name,
                        itemPrice: amount,
                        itemQuantity: int.parse(productQty.substring(
                            0, productQty.indexOf('.'))),
                        orderDiscount:
                        0.0,
                        itemOption: element.variations.isNotEmpty
                            ? element
                            .variations[
                        listOfOrderHead.indexOf(order)]
                            .name
                            : '',
                        productId: element.id,
                        variationId: element.variations.isNotEmpty
                            ? element
                            .variations[listOfOrderHead.indexOf(order)]
                            .id
                            : 0,
                        productType: element.type,
                        customerTel: getOrdersItems.first.contactMobile));
                  }
                  GlobalValues.setEditOrder = true;
                  GlobalValues.setRelatedInvoiceId = getOrdersItems.first.orderId;

                  if (order.contactName ==
                      '${AppStrings.firstName} ${AppStrings.secondName}') {
                    widget.customerName(order.contactName);
                  } else {
                    widget.customerName(
                        '${order.contactName} | ${order.contactMobile}');
                  }

                  OrdersDialog.hide(context);
                } else if (state is OrderReportItemsError) {
                  LoadingDialog.hide(context);
                  tryAgainLater(context);
                }
              },
              builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      orderId = listOfOrderHead[
                      listOfOrderHead.indexOf(order)]
                          .id;

                      OrdersCubit.get(context).getOrderReportItems(
                          widget.locationId, orderId!);
                    },
                    child: Icon(
                      Icons.edit,
                      color: ColorManager.edit,
                      size: AppSize.s20.sp,
                    ));
              },
            ),
          ),
          SizedBox(
            width: AppConstants.smallDistance,
          ),
          BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) async {
                if (state is OrdersNoInternetState) {
                  showNoInternet(context);

                  await Future.delayed(Duration(
                      milliseconds: AppConstants.durationOfSnackBar));

                  OrdersDialog.hide(context);
                }

                if (state is LoadingOrderReportItems) {
                  LoadingDialog.show(context);
                }

                if (state is OrderReportItemsSucceed) {
                  LoadingDialog.hide(context);
                  setState(() {
                    listOfOrderItems =
                        OrdersCubit.get(context).listOfOrderItems;
                  });
                } else if (state is OrderReportItemsError) {
                  LoadingDialog.hide(context);
                  tryAgainLater(context);
                }
              },
              builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      orderItems = true;
                      orderFilter = false;
                      orderId = listOfOrderHead[
                      listOfOrderHead.indexOf(order)]
                          .id;
                      OrdersCubit.get(context).getOrderReportItems(
                          widget.locationId, orderId!);
                      if (widget.deviceWidth <= 600) {
                        mobileDialogHeight = 320.h;
                      }
                    },
                    child: Icon(
                      Icons.visibility,
                      color: ColorManager.orders,
                      size: AppSize.s20.sp,
                    ));
              },
            ),
          )
        ],
      ))
    ]))
        .toList();
  }

  List<DataRow> _createOrdersRowsForSearch() {
    return listOfOrderHeadForSearch
        .map((order) => DataRow(cells: [
      DataCell(Text(
          listOfOrderHeadForSearch[
          listOfOrderHeadForSearch.indexOf(order)]
              .id
              .toString(),
          style: TextStyle(color: ColorManager.edit))),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 120.w : 40.w,
        child: Center(
            child: Text(
                listOfOrderHeadForSearch[
                listOfOrderHeadForSearch.indexOf(order)]
                    .contactName.trim() == '' ? '${AppStrings.firstName} ${AppStrings.secondName}' : listOfOrderHeadForSearch[
                listOfOrderHeadForSearch.indexOf(order)]
                    .contactName
                    .toString(),
                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 70.w : 25.w,
        child: Center(
            child:
            Text(
                listOfOrderHeadForSearch[
                listOfOrderHeadForSearch.indexOf(order)]
                    .subTotal
                    .toString(),

                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) async {
                if (state is OrdersNoInternetState) {
                  showNoInternet(context);

                  await Future.delayed(Duration(
                      milliseconds: AppConstants.durationOfSnackBar));

                  OrdersDialog.hide(context);
                }

                if (state is LoadingOrderReportItems) {
                  LoadingDialog.show(context);
                }

                if (state is OrderReportItemsSucceed) {
                  LoadingDialog.hide(context);
                  listOfOrderItems =
                      OrdersCubit.get(context).listOfOrderItems;

                  var getOrdersItems = listOfOrderItems
                      .where((element) => element.orderId == order.id);

                  widget.orderDiscount(order.discount);

                  widget.orderTotalAmount(
                      double.parse(order.subTotal.toString()));

                  listOfTmpOrder.clear();

                  for (var element in getOrdersItems.first.products) {
                    String sellPrice = element.sellPrice;

                    if (element.variations.isNotEmpty) {
                      sellPrice = element
                          .variations[listOfOrderHead.indexOf(order)]
                          .price;
                    }

                    String amount =
                        '${sellPrice.substring(0, sellPrice.indexOf('.'))}${sellPrice.substring(sellPrice.indexOf('.'), sellPrice.indexOf('.') + 1 + decimalPlaces)}';

                    String productQty = element.productQty;
                    listOfTmpOrder.add(TmpOrderModel(
                        id: element.id,
                        date: getOrdersItems.first.date,
                        category: element.categoryId.toString(),
                        brand: element.brandId.toString(),
                        customer:
                        '${getOrdersItems.first.contactFirstName} ${getOrdersItems.first.contactFirstName}',
                        itemAmount:
                        (int.parse(amount) * int.parse(productQty))
                            .toString(),
                        itemName: element.name,
                        itemPrice: amount,
                        itemQuantity: int.parse(productQty.substring(
                            0, productQty.indexOf('.'))),
                        orderDiscount:
                        0.0,
                        itemOption: element.variations.isNotEmpty
                            ? element
                            .variations[
                        listOfOrderHead.indexOf(order)]
                            .name
                            : '',
                        productId: element.id,
                        variationId: element.variations.isNotEmpty
                            ? element
                            .variations[
                        listOfOrderHead.indexOf(order)]
                            .id
                            : 0,
                        productType: element.type,
                        customerTel: getOrdersItems.first.contactMobile));
                  }
                  GlobalValues.setEditOrder = true;
                  GlobalValues.setRelatedInvoiceId = getOrdersItems.first.orderId;

                  if (order.contactName ==
                      '${AppStrings.firstName} ${AppStrings.secondName}') {
                    widget.customerName(order.contactName);
                  } else {
                    widget.customerName(
                        '${order.contactName} | ${order.contactMobile}');
                  }

                  OrdersDialog.hide(context);
                } else if (state is OrderReportItemsError) {
                  LoadingDialog.hide(context);
                  tryAgainLater(context);
                }
              },
              builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      orderId = listOfOrderHeadForSearch[
                      listOfOrderHeadForSearch.indexOf(order)]
                          .id;

                      OrdersCubit.get(context).getOrderReportItems(
                          widget.locationId, orderId!);
                    },
                    child: Icon(
                      Icons.edit,
                      color: ColorManager.edit,
                      size: AppSize.s20.sp,
                    ));
              },
            ),
          ),
          SizedBox(
            width: AppConstants.smallDistance,
          ),
          BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) async {
                if (state is OrdersNoInternetState) {
                  showNoInternet(context);

                  await Future.delayed(Duration(
                      milliseconds: AppConstants.durationOfSnackBar));

                  OrdersDialog.hide(context);
                }

                if (state is LoadingOrderReportItems) {
                  LoadingDialog.show(context);
                }

                if (state is OrderReportItemsSucceed) {
                  LoadingDialog.hide(context);

                  setState(() {
                    listOfOrderItems =
                        OrdersCubit.get(context).listOfOrderItems;
                  });
                } else if (state is OrderReportItemsError) {
                  LoadingDialog.hide(context);
                  tryAgainLater(context);
                }
              },
              builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      orderItems = true;
                      orderFilter = false;
                      orderId = listOfOrderHeadForSearch[
                      listOfOrderHeadForSearch.indexOf(order)]
                          .id;

                      OrdersCubit.get(context).getOrderReportItems(
                          widget.locationId, orderId!);
                    },
                    child: Icon(
                      Icons.visibility,
                      color: ColorManager.orders,
                      size: AppSize.s20.sp,
                    ));
              },
            ),
          )
        ],
      ))
    ]))
        .toList();
  }

  //Hold Orders---------------------------------------------------------------------

  List<DataRow> _createHoldOrdersRows() {
    return listOfHoldOrderNames
        .map((holdOrder) => DataRow(cells: [
      DataCell(Text(
          listOfHoldOrderNames[listOfHoldOrderNames.indexOf(holdOrder)]
              .id
              .toString(),
          style: TextStyle(color: ColorManager.edit))),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 150.w : 40.w,
        child: Center(
            child: Text(
                listOfHoldOrderNames[
                listOfHoldOrderNames.indexOf(holdOrder)]
                    .holdText
                    .toString(),
                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocProvider(
              create: (context) => sl<MainViewLocalCubit>(),
              child: BlocConsumer<MainViewLocalCubit,
                  MainViewLocalState>(listener: (context, state) {
                if (state is LoadingHoldCardsItemsById) {
                } else if (state is LoadedHoldCardsItemsById) {
                  listOfTmpOrder = [];

                  listOfHoldOrderItems =
                      MainViewLocalCubit.get(context)
                          .listOfHoldOrderItems;

                  for (var element in listOfHoldOrderItems) {
                    listOfTmpOrder.add(TmpOrderModel(
                        id: element.id,
                        date: element.date,
                        category: element.category,
                        brand: element.brand,
                        customer: element.customer,
                        itemAmount: element.itemAmount,
                        itemName: element.itemName,
                        itemPrice: element.itemPrice,
                        itemQuantity: element.itemQuantity,
                        orderDiscount:
                        double.parse(element.discount.toString()),
                        itemOption: element.itemOption,
                        productId: element.productId,
                        variationId: element.variationId,
                        productType: element.productType,
                        customerTel: element.customerTel));
                  }

                  GlobalValues.setEditOrder = false;

                  if (holdOrder.customer ==
                      '${AppStrings.firstName} ${AppStrings.secondName}') {
                    widget.customerName('${holdOrder.customer}');
                  } else {
                    widget.customerName(
                        '${holdOrder.customer} | ${holdOrder.customerTel}');
                  }

                  widget.orderDiscount(holdOrder.discount!);

                  OrdersDialog.hide(context);
                } else if (state is LoadingErrorHoldCardsItemsById) {}
              }, builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      listOfHoldOrderItems = [];

                      await MainViewLocalCubit.get(context)
                          .getHoldCardsItems(listOfHoldOrderNames[
                      listOfHoldOrderNames
                          .indexOf(holdOrder)]
                          .id!);
                    },
                    child: Icon(
                      Icons.downloading,
                      color: ColorManager.edit,
                      size: AppSize.s20.sp,
                    ));
              })),
          SizedBox(
            width: AppConstants.smallDistance,
          ),
          BlocProvider(
            create: (context) => sl<MainViewLocalCubit>(),
            child:
            BlocConsumer<MainViewLocalCubit, MainViewLocalState>(
              listener: (context, state) {
                if (state is DeleteHoldCards) {
                } else if (state is DeleteErrorHoldCards) {}
              },
              builder: (context, state) {
                return Bounceable(
                    duration: Duration(
                        milliseconds:
                        AppConstants.durationOfBounceable),
                    onTap: () async {
                      await Future.delayed(Duration(
                          milliseconds:
                          AppConstants.durationOfBounceable));
                      await MainViewLocalCubit.get(context)
                          .deleteHoldCard(holdOrder.id!);
                      setState(() {
                        listOfHoldOrderNames.removeWhere((element) =>
                        element.holdText == holdOrder.holdText);
                        listOfHoldOrderItems.removeWhere((element) =>
                        element.holdText == holdOrder.holdText);
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: ColorManager.delete,
                      size: AppSize.s20.sp,
                    ));
              },
            ),
          ),
        ],
      ))
    ]))
        .toList();
  }

  List<DataRow> _createHoldOrdersForSearchRows() {
    return listOfHoldOrderNamesForSearch
        .map((holdOrder) => DataRow(cells: [
      DataCell(Text(
          listOfHoldOrderNamesForSearch[
          listOfHoldOrderNamesForSearch.indexOf(holdOrder)]
              .id
              .toString(),
          style: TextStyle(color: ColorManager.edit))),
      DataCell(SizedBox(
        width: widget.deviceWidth <= 600 ? 150.w : 40.w,
        child: Center(
            child: Text(
                listOfHoldOrderNamesForSearch[
                listOfHoldOrderNamesForSearch
                    .indexOf(holdOrder)]
                    .holdText
                    .toString(),
                style: TextStyle(fontSize: AppSize.s14.sp),
                textAlign: TextAlign.center)),
      )),
      DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocProvider(
                  create: (context) => sl<MainViewLocalCubit>(),
                  child: BlocConsumer<MainViewLocalCubit,
                      MainViewLocalState>(listener: (context, state) {
                    if (state is LoadingHoldCardsItemsById) {
                    } else if (state is LoadedHoldCardsItemsById) {
                      listOfTmpOrder = [];

                      listOfHoldOrderItems =
                          MainViewLocalCubit.get(context)
                              .listOfHoldOrderItems;

                      for (var element in listOfHoldOrderItems) {
                        listOfTmpOrder.add(TmpOrderModel(
                            id: element.id,
                            date: element.date,
                            category: element.category,
                            brand: element.brand,
                            customer: element.customer,
                            itemAmount: element.itemAmount,
                            itemName: element.itemName,
                            itemPrice: element.itemPrice,
                            itemQuantity: element.itemQuantity,
                            orderDiscount:
                            double.parse(element.discount.toString()),
                            itemOption: element.itemOption,
                            productId: element.productId,
                            variationId: element.variationId,
                            productType: element.productType,
                            customerTel: element.customerTel));
                      }

                      GlobalValues.setEditOrder = false;

                      if (holdOrder.customer ==
                          '${AppStrings.firstName} ${AppStrings.secondName}') {
                        widget.customerName('${holdOrder.customer}');
                      } else {
                        widget.customerName(
                            '${holdOrder.customer} | ${holdOrder.customerTel}');
                      }

                      widget.orderDiscount(holdOrder.discount!);

                      OrdersDialog.hide(context);
                    } else if (state is LoadingErrorHoldCardsItemsById) {}
                  }, builder: (context, state) {
                    return Bounceable(
                        duration: Duration(
                            milliseconds:
                            AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds:
                              AppConstants.durationOfBounceable));
                          listOfHoldOrderItems = [];

                          await MainViewLocalCubit.get(context)
                              .getHoldCardsItems(
                              listOfHoldOrderNamesForSearch[
                              listOfHoldOrderNamesForSearch
                                  .indexOf(holdOrder)]
                                  .id!);
                        },
                        child: Icon(
                          Icons.downloading,
                          color: ColorManager.edit,
                          size: AppSize.s20.sp,
                        ));
                  })),
              SizedBox(
                width: AppConstants.smallDistance,
              ),
              BlocProvider(
                create: (context) => sl<MainViewLocalCubit>(),
                child:
                BlocConsumer<MainViewLocalCubit, MainViewLocalState>(
                  listener: (context, state) {
                    if (state is DeleteHoldCards) {
                    } else if (state is DeleteErrorHoldCards) {}
                  },
                  builder: (context, state) {
                    return Bounceable(
                        duration: Duration(
                            milliseconds:
                            AppConstants.durationOfBounceable),
                        onTap: () async {
                          await Future.delayed(Duration(
                              milliseconds:
                              AppConstants.durationOfBounceable));
                          await MainViewLocalCubit.get(context)
                              .deleteHoldCard(holdOrder.id!);
                          setState(() {
                            listOfHoldOrderNamesForSearch.removeWhere(
                                    (element) =>
                                element.holdText ==
                                    holdOrder.holdText);
                            listOfHoldOrderItems.removeWhere((element) =>
                            element.holdText == holdOrder.holdText);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: ColorManager.delete,
                          size: AppSize.s20.sp,
                        ));
                  },
                ),
              ),
            ],
          ))
    ]))
        .toList();
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}