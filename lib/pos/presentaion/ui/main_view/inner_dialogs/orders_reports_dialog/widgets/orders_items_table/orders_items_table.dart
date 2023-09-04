import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createOrderItemsDataTable(
    int currentSortColumn,
    bool isSortAsc,
    List<DataColumn> createOrderItemsColumns,
    List<DataRow> createOrderItemsRows,
    double deviceWidth
    ) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: deviceWidth <= 600 ? 15 : 50,
        dividerThickness: 2.sp,
        columns: createOrderItemsColumns,
        rows: createOrderItemsRows,
        sortColumnIndex: currentSortColumn,
        sortAscending: isSortAsc,
      )
    ],
  );
}