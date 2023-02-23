import 'package:walletutilityplugin/widgets/allwidgets/base_equatable.dart';

class TabScreenState extends BaseEquatable {}

class TabScreenInitialState extends TabScreenState {}

class TabScreenLoadingState extends TabScreenState {}

class TabScreenRefreshState extends TabScreenState {
  @override
  bool operator ==(Object other) => false;
}

class TabScreenErrorState extends TabScreenState {
  final String error;
  TabScreenErrorState(this.error);
  @override
  bool operator ==(Object other) => false;
}
