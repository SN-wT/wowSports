import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/wallet_screen/cubit/wallet_screen_state.dart';
import 'package:wowsports/screens/wallet_screen/model/link_model/link_request.dart';
import 'package:wowsports/screens/wallet_screen/model/link_model/link_response_model.dart';
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
  LInkResponse lInkResponse;

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

  linkkey() async {
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    emit(WalletScreenLinkRequestState());
    var uid = FirebaseAuth.instance.currentUser.uid;
    LInkRequest lInkRequest = LInkRequest(
      publicKey: puplickeytextcontroller.text.toString(),
      userId: uid,
    );
    var response = await Dio().post(authenticationCubit.urlsModel.getnfts,
        options: Options(
            headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: lInkRequest.toJson());

    lInkResponse = LInkResponse.fromJson(
        jsonDecode(jsonEncode(response.data as Map<String, dynamic>)));
    var linkresponse = lInkResponse.body.toString();
    debugPrint("the link response ${linkresponse.toString()}");
    emit(WalletScreenLinkedState());
    if (linkresponse == "publicKey added successfully") {
      emit(WalletScreenLinkrefreshState());
    }
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
