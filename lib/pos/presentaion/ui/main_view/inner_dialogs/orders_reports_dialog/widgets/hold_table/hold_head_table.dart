import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createHoldOrdersDataTable(
    int currentSortColumn,
    bool isSortAsc,
    bool searching,
    List<DataColumn> createHoldOrdersColumns,
    List<DataRow> createHoldOrdersRows,
    List<DataRow> createHoldOrdersForSearchRows, double deviceWidth) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: deviceWidth <= 600 ? 30 : 130,
        dividerThickness: 2.sp,
        columns: createHoldOrdersColumns,
        rows:
            searching ? createHoldOrdersForSearchRows : createHoldOrdersRows,
        sortColumnIndex: currentSortColumn,
        sortAscending: isSortAsc,
      )
    ],
  );
}
