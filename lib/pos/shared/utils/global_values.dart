class GlobalValues{
  static bool? globalEditOrder = false;
  static int? globalRelatedInvoiceId;

  static bool get getEditOrder {
    return globalEditOrder!;
  }

  static set setEditOrder(bool editOrder) {
    globalEditOrder = editOrder;
  }

  static int get getRelatedInvoiceId {
    return globalRelatedInvoiceId!;
  }

  static set setRelatedInvoiceId(int relatedInvoiceId) {
    globalRelatedInvoiceId = relatedInvoiceId;
  }
}