import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/login/cubit/login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  AuthenticationCubitBloc authenticationCubit;
  var email;

  LoginScreenCubit(this.authenticationCubit) : super(LoginScreenInitialState());

  Future<void> init() async {
    emit(LoginScreenLoadingState());
    //    await Future.delayed(const Duration(seconds: 3));
    debugPrint('its comming inside the logincubit');
    email = FirebaseAuth.instance.currentUser?.email ?? '';
    if (FirebaseAuth.instance.currentUser != null) {
      // await authenticationCubit.loggedIn();

      email = FirebaseAuth.instance.currentUser?.email;

      //emit(LoginScreenAuthenticatedState());
    }
    emit(LoginScreenLoadedState());
  }

  Future<void> login() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    var uid = FirebaseAuth.instance.currentUser.uid;
    debugPrint('uid in lsc$uid');

    final res = FirebaseDatabase.instance.ref('Master/Address/$uid');
    var emailid = FirebaseAuth.instance.currentUser.email;

    await res.update({"email": emailid});
    await Future.delayed(const Duration(seconds: 2));

    await authenticationCubit.loggedIn();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
