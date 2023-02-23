import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flow_dart_sdk/fcl/fcl.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:wowsports/authentication/authentication_state.dart';
import 'package:wowsports/model/urls_model.dart';
import 'package:wowsports/screens/settings_screen/model/marketplace_model/nftrequest.dart';
import 'package:wowsports/screens/settings_screen/model/marketplace_model/nftresponse.dart';
import 'package:wowsports/screens/settings_screen/model/nftclaim_model/nftclaim_model.dart';
import 'package:wowsports/screens/wallet_screen/model/user_address_model/request.dart';
import 'package:wowsports/screens/wallet_screen/model/user_address_model/response_model.dart';
import 'package:wowsports/utils/base_cubit.dart';
import 'package:wowsports/utils/shared_preference.dart';
import 'package:wowsports/utils/theme.dart';

class AuthenticationCubitBloc extends BaseCubit<AuthenticationState> {
  // var currentUserToken = '';
  ThemeData appTheme = AppTheme.darkTheme;

  AuthenticationCubitBloc() : super(AuthenticationInitialState()) {}
  var auth = FirebaseAuth.instance;
  var ap;
  var apikey;
  var balance;
  var responseaddressis;
  NFTDataResponse nftDataResponse;
  UserAddressResponse userAddressResponse;
  ValueNotifier valueNotifier = ValueNotifier(null);
  ValueNotifier balanceNotifier = ValueNotifier(null);
  NFTDataRequest nftDataRequest;
  UrlsModel urlsModel;
  List<NFTS> nftData = [];
  NFTClaimModel nftClaimModel;

  void listenerreset(AuthenticationState state) {
    emit(state);
  }

  Future<void> init() async {
    emit(AuthenticationLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    await getMasterUrlsandtokens();
    if (FirebaseAuth.instance.currentUser != null) {
      await loggedIn();
      // emit(AuthenticationAuthenticatedState());
      // await AddressRequest();
    } else {
      emit(AuthenticationUnAuthenticatedState());
    }
  }

  Future<void> loggedIn() async {
    emit(AuthenticationAuthenticatedState());
    debugPrint('address request called');
    // if (state is AuthenticationAuthenticatedState) {
    emit(AuthenticationAddreessRequestedState());
    var address = await PreferenceHelper.getToken();
    if (address == null) {
      if (urlsModel == null) {
        await getMasterUrlsandtokens();
      }

      var uid = FirebaseAuth.instance.currentUser?.uid;
      var email = FirebaseAuth.instance.currentUser?.email;
      UserIDRequest userIDRequest = UserIDRequest(userId: uid);
      debugPrint('the response uid $uid');
      final responseaddress = (await Dio().post(urlsModel.addressRequestUrl,
          data: userIDRequest.toJson(),
          options: Options(
              headers: {"x-api-key": urlsModel.apikey},
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })));
      debugPrint('the response is $responseaddress');

      userAddressResponse = UserAddressResponse.fromJson(
          responseaddress.data as Map<String, dynamic>);

      debugPrint(
          'the apple response is  ${userAddressResponse?.body.toString()}');
      //var addressfromservice = userAddressResponse?.body.toString();

      // if (addressfromservice == "Address already created") {
      var snapshotaddress = FirebaseDatabase.instance
          .ref('Master')
          .child('Address')
          .child(uid)
          .child("address");
      // .ref('$dbHost/Address/${_auth.currentUser!.uid}')
      //.get();
      FirebaseDatabase.instance
          .ref('Master')
          .child('Address')
          .child(uid)
          .child("address")
          .onValue
          .listen((event) async {
        if (event.snapshot.value != null) {
          valueNotifier = ValueNotifier(
              responseaddressis = event.snapshot.value.toString());
          debugPrint(
              'the vaqlue notifier address is ${valueNotifier.value
                  .toString()}');
          await PreferenceHelper.saveAddress(responseaddressis.toString());
        } else {
          UserAddressResponse userAddressResponse;
          valueNotifier = ValueNotifier(userAddressResponse =
              UserAddressResponse.fromJson(
                  responseaddress.data as Map<String, dynamic>));
          debugPrint(
              'the vaqlue notifier address is78 ${valueNotifier.value
                  .toString()}');
          await PreferenceHelper.saveAddress(valueNotifier.value.toString());
        }
      });

      DataSnapshot snapshotaddressvalue = await snapshotaddress.get();
      if (snapshotaddressvalue.value != null) {
        debugPrint('get: ${snapshotaddressvalue.value}');
      }
      DatabaseEvent addressevent = await snapshotaddress.once();
      var address = addressevent.snapshot.value.toString();
      debugPrint('the address from db${address.toString()}');
      FlowClient flowClient =
      FlowClient('access.devnet.nodes.onflow.org', 9000);

      // var address = ('0x877931736ee77cff').toString();
      try {
        debugPrint('address');
        //var abcd = flowClient.accessClient.sendTransaction()
        // var height = await flowClient.getBlockHeight();
        balanceNotifier = ValueNotifier(balance = await flowClient
            .getAccountBalance(responseaddressis.toString().substring(2)));
        // var app = await flowClient.getAccount("547f177b243b4d80");
        var apps = flowClient.channel.createConnection();
        //  debugPrint('address ${(app)} ');
        debugPrint('balance ${(balance)} ');
      } catch (ex) {
        debugPrint('address was $ex');
      }
      // responseaddressis = ValueNotifier(addressevent.snapshot.value);
      //address.toString();
      // } else {
      //responseaddressis = addressfromservice.toString();
      // }

      final res = FirebaseDatabase.instance.ref('Master/Address/$uid');
      await res.update({"email": email});
    } else {
      FlowClient flowClient =
      FlowClient('access.devnet.nodes.onflow.org', 9000);
      // var address = ('0x877931736ee77cff').toString();
      try {
        valueNotifier = ValueNotifier(
            responseaddressis = await PreferenceHelper.getToken());
        debugPrint('address');
        //var abcd = flowClient.accessClient.sendTransaction()
        // var height = await flowClient.getBlockHeight();
        balanceNotifier = ValueNotifier(balance = await flowClient
            .getAccountBalance(responseaddressis.toString().substring(2)));

        // var app = await flowClient.getAccount("547f177b243b4d80");
        var apps = flowClient.channel.createConnection();
        //  debugPrint('address ${(app)} ');
        debugPrint('balance ${(balance)} ');
      } catch (ex) {
        debugPrint('address was $ex');
      }
    }

    emit(AuthenticationAddreessReceivedState());
    //  }
    /*
      else {
        valueNotifier = ValueNotifier(
            responseaddressis = preferencehelperaddress.toString());

        FlowClient flowClient =
            FlowClient('access.devnet.nodes.onflow.org', 9000);
        // var address = ('0x877931736ee77cff').toString();
        try {
          debugPrint(
              'address is was ${responseaddressis.toString().substring(1)}');
//var abcd = flowClient.accessClient.sendTransaction()
          // var height = await flowClient.getBlockHeight();
          balance = await flowClient.getAccountBalance("$responseaddressis");
          balanceNotifier = ValueNotifier(balance = await flowClient
              .getAccountBalance(responseaddressis.toString().substring(2)));

          // var app = await flowClient.getAccount("547f177b243b4d80");
          var apps = flowClient.channel.createConnection();
          //  debugPrint('address ${(app)} ');
          debugPrint('balance ${(balance)} ');
        } catch (ex) {
          debugPrint('address was $ex');
        }
        balanceNotifier = ValueNotifier(balance = await flowClient
            .getAccountBalance(responseaddressis.toString().substring(2)));
      }

       */

    // await AddressRequest();
    if (responseaddressis != null) {
      emit(AuthenticationAddreessReceivedState());
    }
  }

  Future<void> getMasterUrlsandtokens() async {
    await FirebaseDatabase.instance
        .ref('Master')
        .child('Urls')
        .get()
        .then((value) async {
      urlsModel = UrlsModel.fromJson(
          jsonDecode(jsonEncode(value.value)) as Map<String, dynamic>);
      debugPrint(' urlsandtokens values ${urlsModel.toString()}');
    });
  }

  Future<void> loggedOut() async {
    FirebaseAuth.instance.signOut();
    AuthAction.signIn;
    var token = await PreferenceHelper.getToken();
    debugPrint('debug112$token');
    await PreferenceHelper.clearStorage();
    var tokens = await PreferenceHelper.getToken();
    debugPrint('debug1112$tokens');
    emit(AuthenticationUnAuthenticatedState());
  }

  Future<void> getMasterNFTClaim() async {
    await FirebaseDatabase.instance
        .ref('Master')
        .child('NFTClaim')
        .get()
        .then((value) async {
      nftClaimModel = NFTClaimModel.fromJson(
          jsonDecode(jsonEncode(value.value)) as Map<String, dynamic>);
      debugPrint(
          ' urlsandtokenssss values ${nftClaimModel.packname.toString()}');
    });
  }

  Future<NFTDataResponse> getUserNFTs({bool forceRefresh}) async {
    // emit(AuthenticationNFTrequestedState());
/*
    var snapshotUrl = FirebaseDatabase.instance
        .ref('Master')
        .child('NFTClaim')
        .child('packname');
    var snapshotPackName = FirebaseDatabase.instance
        .ref('Master')
        .child('NFTClaim')
        .child('requesturl');
    var snapshotapikey = FirebaseDatabase.instance
        .ref('Master')
        .child('NFTClaim')
        .child('apikey');
    // .ref('$dbHost/Address/${_auth.currentUser!.uid}')
    //.get();

    DataSnapshot snapshotvalue = await snapshotUrl.get();
    if (snapshotvalue.value != null) {
      debugPrint('get: ${snapshotvalue.value}');
    }
    DatabaseEvent event = await snapshotUrl.once();
    var packName = event.snapshot.value.toString();
    //above code for getting request url from db
    DataSnapshot snapshotpacknamevalue = await snapshotPackName.get();
    if (snapshotpacknamevalue.value != null) {
      debugPrint('get: ${snapshotpacknamevalue.value}');
    }
    DatabaseEvent packnameevent = await snapshotPackName.once();

    var url = packnameevent.snapshot.value.toString();
    //above code for getting packname from db
    DataSnapshot snapshotapikeyvalue = await snapshotapikey.get();
    if (snapshotapikeyvalue.value != null) {
      debugPrint('get: ${snapshotapikeyvalue.value}');
    }
    DatabaseEvent apikeyevent = await snapshotapikey.once();
    var apikey = apikeyevent.snapshot.value.toString();
    debugPrint('getUserNFTs called $forceRefresh');
    debugPrint('all uri$url');
    debugPrint('all uri2 $packName');

 */
    await getMasterNFTClaim();
    nftDataRequest =
        NFTDataRequest(packName: nftClaimModel.packname.toString());
    var resposedata = (await Dio().post(
      nftClaimModel.requesturl,
      options: Options(
          headers: {"x-api-key": nftClaimModel.apikey},
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
      data: nftDataRequest.toJson(),
    ));

    nftDataResponse =
        NFTDataResponse.fromJson(resposedata.data as Map<String, dynamic>);
    debugPrint('all nfts are ${nftDataResponse.items[0].nFTS[0].name}');

    debugPrint('all nfts are ${nftDataResponse.items[0].nFTS.toList()}');
    // emit(AuthenticationNFTREsponseState());
    nftData.addAll(nftDataResponse.items[0].nFTS.reversed.toList());
    return nftDataResponse;
  }
}
/*
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
        var snapshotapikey = FirebaseDatabase.instance
            .ref('Master')
            .child('Urls')
            .child('apikey');
        // .ref('$dbHost/Address/${_auth.currentUser!.uid}')
        //.get();

        DataSnapshot snapshotapikeyvalue = await snapshotapikey.get();
        if (snapshotapikeyvalue.value != null) {
          debugPrint('get: ${snapshotapikeyvalue.value}');
        }
        DatabaseEvent eventforapikey = await snapshotapikey.once();
        apikey = eventforapikey.snapshot.value.toString();
        debugPrint('the apikey is ${eventforapikey.snapshot.value.toString()}');
 */
