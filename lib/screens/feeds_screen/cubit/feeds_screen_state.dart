
import 'package:wowsports/utils/base_equatable.dart';

class FeedsScreenState extends BaseEquatable {}

class FeedsScreenInitialState extends FeedsScreenState {}

class FeedsScreenLoadingState extends FeedsScreenState {}

class FeedsScreenRefreshState extends FeedsScreenState {
  @override
  bool operator ==(Object other) => false;
}

class FeedsScreenErrorState extends FeedsScreenState {
  final String error;
  FeedsScreenErrorState(this.error);
  @override
  bool operator ==(Object other) => false;
}
