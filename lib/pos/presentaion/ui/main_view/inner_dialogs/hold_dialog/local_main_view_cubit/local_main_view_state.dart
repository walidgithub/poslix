abstract class MainViewLocalState{}

class MainViewLocalInitial extends MainViewLocalState{}

class InsertHoldCards  extends MainViewLocalState{}
class InsertErrorHoldCards  extends MainViewLocalState{
  String errorText;

  InsertErrorHoldCards(this.errorText);
}

class InsertHoldCardsItems  extends MainViewLocalState{}
class InsertErrorHoldCardsItems  extends MainViewLocalState{
  String errorText;

  InsertErrorHoldCardsItems(this.errorText);
}

class LoadingHoldCards extends MainViewLocalState{}
class LoadedHoldCards  extends MainViewLocalState{}
class LoadingErrorHoldCards  extends MainViewLocalState{
  String errorText;

  LoadingErrorHoldCards(this.errorText);
}

class LoadingHoldCardsItemsById extends MainViewLocalState{}
class LoadedHoldCardsItemsById  extends MainViewLocalState{}
class LoadingErrorHoldCardsItemsById  extends MainViewLocalState{
  String errorText;

  LoadingErrorHoldCardsItemsById(this.errorText);
}

class DeleteHoldCards  extends MainViewLocalState{}
class DeleteErrorHoldCards  extends MainViewLocalState{
  String errorText;

  DeleteErrorHoldCards(this.errorText);
}