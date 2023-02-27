import 'package:wowsports/utils/base_equatable.dart';

class BuyScreenState extends BaseEquatable {}

class BuyScreenInitialState extends BuyScreenState {}

class BuyScreenLoadingState extends BuyScreenState {}

class BuyScreenMintRequestedState extends BuyScreenState {}

class BuyScreenMintedState extends BuyScreenState {}

class BuyScreenRefreshState extends BuyScreenState {
  @override
  bool operator ==(Object other) => false;
}

class BuyScreenErrorState extends BuyScreenState {
  final String error;

  BuyScreenErrorState(this.error);

  @override
  bool operator ==(Object other) => false;
}
