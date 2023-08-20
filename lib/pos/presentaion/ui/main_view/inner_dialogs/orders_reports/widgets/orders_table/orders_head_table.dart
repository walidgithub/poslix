import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createOrdersDataTable(
    int _currentSortColumn,
    bool _isSortAsc,
    bool searching,
    List<DataColumn> _createOrdersColumns,
    List<DataRow> _createOrdersRows,
    List<DataRow> _createOrdersRowsForSearch) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: 130,
        dividerThickness: 2.sp,
        columns: _createOrdersColumns,
        rows:
        searching ? _createOrdersRowsForSearch : _createOrdersRows,
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc,
      )
    ],
  );
}