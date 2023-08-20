class GlobalValues{
  static bool? globalEditOrder = false;

  static bool get getEditOrder {
    return globalEditOrder!;
  }

  static set setEditOrder(bool editOrder) {
    globalEditOrder = editOrder;
  }
}