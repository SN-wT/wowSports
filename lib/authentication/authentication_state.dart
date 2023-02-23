import 'package:wowsports/utils/base_equatable.dart';

class AuthenticationState extends BaseEquatable {}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}

class AuthenticationAuthenticatedState extends AuthenticationState {}

class AuthenticationUnAuthenticatedState extends AuthenticationState {}

class AuthenticationNFTrequestedState extends AuthenticationState {}

class AuthenticationNFTREsponseState extends AuthenticationState {}

class AuthenticationAddreessRequestedState extends AuthenticationState {}

class AuthenticationAddreessReceivedState extends AuthenticationState {}

class AuthenticationSplashScreenState extends AuthenticationState {}

class AuthenticationStateReset extends AuthenticationState {}

class AuthenticationChangeThemeState extends AuthenticationState {
  @override
  bool operator ==(Object other) => false;
}

class AuthenticationRefreshState extends AuthenticationState {
  @override
  bool operator ==(Object other) => false;
}
