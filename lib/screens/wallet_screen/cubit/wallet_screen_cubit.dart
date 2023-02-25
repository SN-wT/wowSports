import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flow_dart_sdk/fcl/fcl.dart';
import 'package:flutter/cupertino.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/wallet_screen/cubit/wallet_screen_state.dart';
import 'package:wowsports/screens/wallet_screen/model/link_model/link_request.dart';
import 'package:wowsports/screens/wallet_screen/model/link_model/link_response_model.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/base_cubit.dart';
import 'package:wowsports/utils/shared_preference.dart';

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
  var pkey;
  String address;

  Future<void> init() async {
    emit(WalletScreenLoadingState());
    var snapshot = FirebaseDatabase.instance
        .ref('Master')
        .child('Urls')
        .child('AddressRequestUrl');

    DataSnapshot snapshotvalue = await snapshot.get();
    if (snapshotvalue.value != null) {
      debugPrint('get: ${snapshotvalue.value}');
    }
    DatabaseEvent event = await snapshot.once();
    ap = event.snapshot.value.toString();
    debugPrint('the url is${event.snapshot.value.toString()}');
    var snapshotapikey =
        FirebaseDatabase.instance.ref('Master').child('Urls').child('apikey');

    DataSnapshot snapshotapikeyvalue = await snapshotapikey.get();
    if (snapshotvalue.value != null) {
      debugPrint('get: ${snapshotvalue.value}');
    }
    DatabaseEvent eventforapikey = await snapshotapikey.once();
    apikey = eventforapikey.snapshot.value.toString();
    debugPrint('the apikey is ${eventforapikey.snapshot.value.toString()}');

    address = await PreferenceHelper.getToken();
    if (address == null && authenticationCubit.responseaddressis != null) {
      address = authenticationCubit.responseaddressis;
    }
    debugPrint("address is $address");

    emit(WalletScreenRefreshState());
  }

  Future<String> balanceQuery() async {
    FlowClient flowClient = FlowClient('access.devnet.nodes.onflow.org', 9000);

    try {
      String balance = await flowClient.getAccountBalance(address.toString().substring(2));
      double balanceInt = double.parse(balance);
      balanceInt = balanceInt * 100;
      debugPrint('balance123 ${(balanceInt)} ');
      debugPrint('balance123 ${(balance)} ');
      return balanceInt.toString();
    } catch (ex) {
      debugPrint('address was $ex');
    }
  }

  linkkey(pkey, context) async {
    AppUtils.showSnackBar("Processing...", context);
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    emit(WalletScreenLinkRequestState());
    var uid = FirebaseAuth.instance.currentUser.uid;
    LInkRequest lInkRequest = LInkRequest(
      publicKey: pkey,
      userId: uid,
    );
    var response = await Dio().post(authenticationCubit.urlsModel.linkrequest,
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
    debugPrint("the link response ${lInkResponse.body.toString()}");
    emit(WalletScreenLinkedState());
    if (lInkResponse.body.toString() == "publicKey added successfully") {
      emit(WalletScreenLinkrefreshState("Key added successfully"));

   //   AppUtils.showSnackBar("The key is now added to your account", context);
      AppUtils.showToast("The key is now added to your account");
    } else {
      emit(WalletScreenErrorState("Something went wrong! We couldn't link the key to your account"));
     // AppUtils.showSnackBar("Something went wrong! We couldn't link the key to your account", context);
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
