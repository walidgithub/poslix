import '../../../domain/entities/hold_order_items_model.dart';
import '../../../domain/entities/hold_order_names_model.dart';

abstract class POSLocalRepository {
  Future<void> insertHoldCard(HoldOrderNamesModel holdOrderNamesModel);
  Future<void> insertHoldCardItems(HoldOrderItemsModel holdOrderItemsModel);

  Future<void> deleteHoldCard(int holdCardId);

  Future<List<HoldOrderNamesModel>> getHoldCards();

  Future<List<HoldOrderItemsModel>> getHoldCardsItems(int holdCardId);
}