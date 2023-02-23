import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/wallet_screen/cubit/wallet_screen_state.dart';
import 'package:wowsports/utils/base_cubit.dart';

class WalletScreenCubit extends BaseCubit<WalletScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  WalletScreenCubit(this.authenticationCubit)
      : super(WalletScreenInitialState());
  Dio dio = Dio();
  var ap;
  TextEditingController puplickeytextcontroller = TextEditingController();
  TextEditingController addresstcontroller = TextEditingController();
  var apikey;
  var nftData = [
    "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2FStephenCurry.PNG?alt=media&token=07b34c05-faf6-40c5-bb36-f62597fa7df2",
    "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2FMsDhoni.png?alt=media&token=87fa8ebe-fbd5-44b9-9db8-656ade5a7163",
    "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2Fadilrashidupdated.png?alt=media&token=e8133c26-9a94-416f-8c35-f80b83308e55",
    "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2Flebronjames.png?alt=media&token=29f3f03d-7983-4cc5-aec4-f4207b9dd18c",
    "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2FMsDhoni.png?alt=media&token=87fa8ebe-fbd5-44b9-9db8-656ade5a7163"
  ];
  Future<void> init() async {
    emit(WalletScreenLoadingState());

    var snapshot = FirebaseDatabase.instance
        .ref('Master')
        .child('Urls')
        .child('AddressRequestUrl');
    // .ref('$dbHost/Address/${_auth.currentUser!.uid}')
    //.get();

    DataSnapshot snapshotvalue = await snapshot.get();
    if (snapshotvalue.value != null) {
      debugPrint('get: ${snapshotvalue.value}');
    }
    DatabaseEvent event = await snapshot.once();
    ap = event.snapshot.value.toString();
    debugPrint('the url is${event.snapshot.value.toString()}');
    var snapshotapikey =
        FirebaseDatabase.instance.ref('Master').child('Urls').child('apikey');
    // .ref('$dbHost/Address/${_auth.currentUser!.uid}')
    //.get();

    DataSnapshot snapshotapikeyvalue = await snapshotapikey.get();
    if (snapshotvalue.value != null) {
      debugPrint('get: ${snapshotvalue.value}');
    }
    DatabaseEvent eventforapikey = await snapshotapikey.once();
    apikey = eventforapikey.snapshot.value.toString();
    debugPrint('the apikey is ${eventforapikey.snapshot.value.toString()}');

    emit(WalletScreenRefreshState());
  }
/*
  addressRequest() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var email = FirebaseAuth.instance.currentUser?.email;
    UserIDRequest userIDRequest = UserIDRequest(userId: uid);
    /*
    var response = await dio.post(
      ap,
      data: userIDRequest.toJson(),
    );
    debugPrint('the response is ${response}');

     */
    debugPrint('the response uid $uid');

    var response = await Dio().post(ap,
        data: userIDRequest.toJson(),
        options: Options(
            headers: {"x-api-key": apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }));
    debugPrint('the response is $response');

    final res = FirebaseDatabase.instance.ref('Master/Address/$uid');
    await res.update({"email": '$email'});
  }

 */
}
