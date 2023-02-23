import 'package:wowsports/utils/base_equatable.dart';

class LoginScreenState extends BaseEquatable {}
//class HelpScreenState {}

class LoginScreenInitialState extends LoginScreenState {}

class LoginScreenLoadingState extends LoginScreenState {}

class LoginScreenLoadedState extends LoginScreenState {
  //final List<Faqs?> faqs;
  // HelpScreenLoadedState(this.faqs);
}

class LoginScreenAuthenticatedState extends LoginScreenState {}

class LoginScreenErrorState extends LoginScreenState {
  final String error;
  LoginScreenErrorState(this.error);
  @override
  bool operator ==(Object other) => false;
}
