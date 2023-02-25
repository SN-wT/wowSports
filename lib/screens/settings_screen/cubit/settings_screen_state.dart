import 'package:wowsports/utils/base_equatable.dart';

class SettingsScreenState extends BaseEquatable {}

class SettingsScreenInitialState extends SettingsScreenState {}

class SettingsScreenLoadingState extends SettingsScreenState {}

class SettingsScreenMintRequestedState extends SettingsScreenState {
  final int indexForMint;

  SettingsScreenMintRequestedState(this.indexForMint);
}

class SettingsScreenMintedState extends SettingsScreenState {}

class SettingsScreenRefreshState extends SettingsScreenState {
  @override
  bool operator ==(Object other) => false;
}

class SettingsScreenErrorState extends SettingsScreenState {
  final String error;

  SettingsScreenErrorState(this.error);

  @override
  bool operator ==(Object other) => false;
}
