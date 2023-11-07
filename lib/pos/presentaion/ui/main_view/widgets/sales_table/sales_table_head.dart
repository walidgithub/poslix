import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

DataTable createDataTable(BuildContext context, int currentSortColumn, bool isSortAsc, List<DataColumn> createColumns, List<DataRow> createRows) {
  return DataTable(
    horizontalMargin: 5,
    columnSpacing: 10,
    dividerThickness: 2.sp,
    columns: createColumns,
    rows: createRows,
    sortColumnIndex: currentSortColumn,
    sortAscending: isSortAsc,
  );
}