import 'package:wowsports/utils/base_equatable.dart';

class PolingScreenState extends BaseEquatable {}
//class HelpScreenState {}

class PolingScreenInitialState extends PolingScreenState {}

class PolingScreenLoadingState extends PolingScreenState {}

class PolingScreenLoadedState extends PolingScreenState {
  //final List<Faqs?> faqs;
  // HelpScreenLoadedState(this.faqs);
}

class PollingScreenPoleRequestedState extends PolingScreenState {}

class AllreadyPolledState extends PolingScreenState {}

class PolledState extends PolingScreenState {}

class PolingScreenErrorState extends PolingScreenState {
  final String error;

  PolingScreenErrorState(this.error);

  @override
  bool operator ==(Object other) => false;
}
