import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget createHoldOrdersDataTable(
    int _currentSortColumn,
    bool _isSortAsc,
    bool searching,
    List<DataColumn> _createHoldOrdersColumns,
    List<DataRow> _createHoldOrdersRows,
    List<DataRow> _createHoldOrdersForSearchRows) {
  return Column(
    children: [
      DataTable(
        horizontalMargin: 10,
        columnSpacing: 130,
        dividerThickness: 2.sp,
        columns: _createHoldOrdersColumns,
        rows:
            searching ? _createHoldOrdersForSearchRows : _createHoldOrdersRows,
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isSortAsc,
      )
    ],
  );
}
