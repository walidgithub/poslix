import '../../../domain/entities/hold_order_items_model.dart';
import '../../../domain/entities/hold_order_names_model.dart';
import '../../../domain/entities/printing_settings_model.dart';

abstract class POSLocalRepository {
  // Hold Orders
  Future<void> insertHoldCard(HoldOrderNamesModel holdOrderNamesModel);
  Future<void> insertHoldCardItems(HoldOrderItemsModel holdOrderItemsModel);

  Future<void> deleteHoldCard(int holdCardId);

  Future<List<HoldOrderNamesModel>> getHoldCards();

  Future<List<HoldOrderItemsModel>> getHoldCardsItems(int holdCardId);

  // Printer Settings
  Future<void> addPrintingSetting(PrintSettingModel printSettingModel);
  Future<void> deletePrintingSetting(int printerId);
  Future<void> updatePrintingSetting(PrintSettingModel printSettingModel, int printerId);
  Future<void> updateAllPrintingSetting();
  Future<List<PrintSettingModel>> getPrintingSettings();
  Future<PrintSettingModel> getPrinterById(int printerId);
}