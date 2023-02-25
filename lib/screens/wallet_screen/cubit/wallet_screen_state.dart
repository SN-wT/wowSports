import 'package:wowsports/utils/base_equatable.dart';

class WalletScreenState extends BaseEquatable {}

class WalletScreenInitialState extends WalletScreenState {}

class WalletScreenLoadingState extends WalletScreenState {}

class WalletScreenLinkRequestState extends WalletScreenState {}

class WalletScreenLinkedState extends WalletScreenState {}

class WalletScreenLinkrefreshState extends WalletScreenState {
  final String status;

  WalletScreenLinkrefreshState(this.status);

  @override
  bool operator ==(Object other) => false;

}

class WalletScreenRefreshState extends WalletScreenState {
  @override
  bool operator ==(Object other) => false;
}

class WalletScreenErrorState extends WalletScreenState {
  final String error;

  WalletScreenErrorState(this.error);

  @override
  bool operator ==(Object other) => false;
}
