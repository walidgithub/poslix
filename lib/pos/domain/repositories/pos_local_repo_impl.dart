import 'package:poslix_app/pos/data/data_sources/local/pos_local_repo.dart';
import 'package:poslix_app/pos/domain/entities/hold_order_items_model.dart';
import 'package:poslix_app/pos/domain/entities/hold_order_names_model.dart';
import 'package:poslix_app/pos/domain/entities/printing_settings_model.dart';

import '../../shared/core/local_db/dbHelper.dart';

class POSLocalRepositoryImp extends POSLocalRepository {
  final DbHelper _dbHelper;

  POSLocalRepositoryImp(this._dbHelper) {
    _dbHelper.database;
  }

  @override
  Future<void> insertHoldCard(HoldOrderNamesModel holdOrderNamesModel) async {
    try {
      await _dbHelper.createHoldCard(holdOrderNamesModel);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> insertHoldCardItems(
      HoldOrderItemsModel holdOrderItemsModel) async {
    try {
      await _dbHelper.createHoldCardItems(holdOrderItemsModel);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteHoldCard(int holdCardId) async {
    try {
      await _dbHelper.deleteHoldOrder(holdCardId);
      await _dbHelper.deleteHoldOrderItems(holdCardId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<HoldOrderNamesModel>> getHoldCards() async {
    try {
      final res = await _dbHelper.getAllHoldOrders();
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<HoldOrderItemsModel>> getHoldCardsItems(int holdCardId) async {
    try {
      final res = await _dbHelper.getAllHoldOrdersItemsById(holdCardId);
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  // Printer Settings -----------------------------------------------------------
  @override
  Future<void> addPrintingSetting(PrintSettingModel printSettingModel) async {
    await _dbHelper.createPrinterSetting(printSettingModel);
  }

  @override
  Future<void> deletePrintingSetting(int printerId) async {
    await _dbHelper.deletePrinterSetting(printerId);
  }

  @override
  Future<void> updatePrintingSetting(PrintSettingModel printSettingModel, int printerId) async {
    await _dbHelper.updatePrinterSetting(printSettingModel, printerId);
  }

  @override
  Future<List<PrintSettingModel>> getPrintingSettings() async {
    final res = await _dbHelper.getAllPrinters();
    return res;
  }

  @override
  Future<PrintSettingModel> getPrinterById(int printerId) async {
    final res = await _dbHelper.getPrinterById(printerId);
    return res;
  }
}
