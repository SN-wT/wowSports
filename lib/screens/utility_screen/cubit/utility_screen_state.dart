
import 'package:wowsports/utils/base_equatable.dart';

class UtilityScreenState extends BaseEquatable {}

class UtilityScreenInitialState extends UtilityScreenState {}

class UtilityScreenLoadingState extends UtilityScreenState {}

class UtilityScreenRefreshState extends UtilityScreenState {
  @override
  bool operator ==(Object other) => false;
}

class UtilityScreenErrorState extends UtilityScreenState {
  final String error;
  UtilityScreenErrorState(this.error);
  @override
  bool operator ==(Object other) => false;
}
