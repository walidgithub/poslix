import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createOrderItemsDataTable(
    int _currentSortColumn,
    bool _isSortAsc,
    List<DataColumn> _createOrderItemsColumns,
    List<DataRow> _createOrderItemsRows) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: 50,
        dividerThickness: 2.sp,
        columns: _createOrderItemsColumns,
        rows: _createOrderItemsRows,
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc,
      )
    ],
  );
}