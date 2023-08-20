import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poslix_app/pos/domain/repositories/pos_local_repo_impl.dart';

import '../../../../../../domain/entities/hold_order_items_model.dart';
import '../../../../../../domain/entities/hold_order_names_model.dart';
import 'local_main_view_state.dart';

class MainViewLocalCubit extends Cubit<MainViewLocalState> {
  MainViewLocalCubit(this.posLocalRepositoryImpl)
      : super(MainViewLocalInitial());

  POSLocalRepositoryImp posLocalRepositoryImpl;

  static MainViewLocalCubit get(context) => BlocProvider.of(context);

  List<HoldOrderNamesModel> listOfHoldOrderNames = [];
  List<HoldOrderItemsModel> listOfHoldOrderItems = [];

  Future<void> insertHoldCard(HoldOrderNamesModel holdOrderNamesModel) async {
    try {
      await posLocalRepositoryImpl.insertHoldCard(holdOrderNamesModel);
      emit(InsertHoldCards());
    } catch (e) {
      emit(InsertErrorHoldCards(e.toString()));
    }
  }

  Future<void> insertHoldCardItems(HoldOrderItemsModel holdOrderItemsModel) async {
    try {
      await posLocalRepositoryImpl.insertHoldCardItems(holdOrderItemsModel);
      emit(InsertHoldCardsItems());
    } catch (e) {
      emit(InsertErrorHoldCardsItems(e.toString()));
    }
  }

  Future<void> deleteHoldCard(int holdCardId) async {
    try {
      await posLocalRepositoryImpl.deleteHoldCard(holdCardId);
      emit(DeleteHoldCards());
    } catch (e) {
      emit(DeleteErrorHoldCards(e.toString()));
    }
  }

  Future<List<HoldOrderNamesModel>> getHoldCards() async {
    emit(LoadingHoldCards());
    try {
      final res = await posLocalRepositoryImpl.getHoldCards();
      emit(LoadedHoldCards());
      listOfHoldOrderNames = res;
      return res;
    } catch(e) {
      emit(LoadingErrorHoldCards(e.toString()));
      return Future.error(e);
    }

  }

  Future<List<HoldOrderItemsModel>> getHoldCardsItems(int holdCardId) async {
    emit(LoadingHoldCardsItemsById());
    try {
      final res = await posLocalRepositoryImpl.getHoldCardsItems(holdCardId);
      emit(LoadedHoldCardsItemsById());
      listOfHoldOrderItems = res;
      return res;
    } catch(e) {
      emit(LoadingErrorHoldCardsItemsById(e.toString()));
      return Future.error(e);
    }

  }


}