import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createOrdersDataTable(
    int currentSortColumn,
    bool isSortAsc,
    bool searching,
    List<DataColumn> createOrdersColumns,
    List<DataRow> createOrdersRows,
    List<DataRow> createOrdersRowsForSearch) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: 60,
        dividerThickness: 2.sp,
        columns: createOrdersColumns,
        rows:
        searching ? createOrdersRowsForSearch : createOrdersRows,
        sortColumnIndex: currentSortColumn,
        sortAscending: isSortAsc,
      )
    ],
  );
}