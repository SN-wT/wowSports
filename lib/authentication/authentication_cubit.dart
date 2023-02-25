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
import 'package:wowsports/screens/wallet_screen/model/getnfts/get_bft_response_model.dart';
import 'package:wowsports/screens/wallet_screen/model/getnfts/get_nft_model_request.dart';
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
  var addressvalue;
  var responseaddressis;
  NFTDataResponse nftDataResponse;
  UserAddressResponse userAddressResponse;
  ValueNotifier valueNotifier = ValueNotifier(null);
  ValueNotifier<double> balanceNotifier = ValueNotifier(0.0);
  NFTDataRequest nftDataRequest;
  UrlsModel urlsModel;
  List<NFTS> nftData = [];
  NFTResponse naftresponse;
  NFTClaimModel nftClaimModel;

  void listenerreset(AuthenticationState state) {
    emit(state);
  }

  Future<void> init() async {
    emit(AuthenticationLoadingState());
    debugPrint('auth cubit before delayed ');
    await Future.delayed(const Duration(seconds: 3));
    debugPrint('auth cubit before geturls ');
    await getMasterUrlsandtokens();
    debugPrint('auth cubit before if ');
    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint('auth cubit user is ${FirebaseAuth.instance.currentUser}');
      await loggedIn();
      // emit(AuthenticationAuthenticatedState());
      // await AddressRequest();
    } else {
      debugPrint('auth cubit else loop ');
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
      debugPrint('address null');
      if (urlsModel == null) {
        await getMasterUrlsandtokens();
      }

      var uid = FirebaseAuth.instance.currentUser.uid;
      var email = FirebaseAuth.instance.currentUser?.email;
      UserIDRequest userIDRequest = UserIDRequest(userId: uid);
      debugPrint('the response uid ${urlsModel.apikey}');
      debugPrint('the response uid ${urlsModel.addressRequestUrl}');

      debugPrint('the response uid $uid');
      final responseaddress = (await Dio().post(urlsModel.addressRequestUrl,
          data: userIDRequest.toJson(),
          options: Options(
              headers: {"x-api-key": urlsModel.apikey},
              followRedirects: false,
              validateStatus: (status) {
                return status < 1000;
              })));
      debugPrint('the response is $responseaddress');

      userAddressResponse = UserAddressResponse.fromJson(
          responseaddress.data as Map<String, dynamic>);

      debugPrint(
          'the apple response is  ${userAddressResponse?.body.toString()}');

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
              'the vaqlue notifier address is ${valueNotifier.value.toString()}');
          await PreferenceHelper.saveAddress(responseaddressis.toString());
          addressvalue = await PreferenceHelper.getToken();
          debugPrint('pref address ${addressvalue}');
          await balanceQuery(addressvalue);
        } else {
          UserAddressResponse userAddressResponse;
          var an = ValueNotifier(userAddressResponse =
              UserAddressResponse.fromJson(
                  responseaddress.data as Map<String, dynamic>));
          valueNotifier = ValueNotifier(responseaddressis = an.value.body);
          debugPrint(
              'the vaqlue notifier address is78 ${valueNotifier.value.toString()}');
          await balanceQuery(valueNotifier.value.toString());

          await PreferenceHelper.saveAddress(valueNotifier.value.toString());
        }
      });
      addressvalue = await PreferenceHelper.getToken();
      debugPrint('pref address 567 ${addressvalue}');
    } else {
      responseaddressis = await PreferenceHelper.getToken();

      await balanceQuery(responseaddressis);
    }

    emit(AuthenticationAddreessReceivedState());

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

  balanceQuery(address) async {
    FlowClient flowClient = FlowClient('access.devnet.nodes.onflow.org', 9000);

    try {
      balance =
          await flowClient.getAccountBalance(address.toString().substring(2));
      double balanceInt = double.parse(balance);
      balanceInt = balanceInt * 100;
      debugPrint('balance123 ${(balanceInt)} ');
      balanceNotifier = ValueNotifier<double>(balanceInt);
      balanceNotifier.value = balanceInt;
      balanceNotifier.notifyListeners();
      //    balanceNotifier.value(balanceInt);
      //  balanceNotifier.notifyListeners();
      debugPrint('balance123 ${(balance)} ');
    } catch (ex) {
      debugPrint('address was $ex');
    }
  }

  Future<void> loggedOut() async {
    await FirebaseAuth.instance.signOut();
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

  Future<NFTResponse> getYourNFTs({bool forceRefresh}) async {
    debugPrint('nftdata inside');
    var address = await PreferenceHelper.getToken();
    GetNFTSRequest getNFTSRequest = GetNFTSRequest(address: address);
    debugPrint('nftdata inside1');
    if (urlsModel == null) {
      await getMasterUrlsandtokens();
    }
    var response = (await Dio().post(urlsModel.getnfts,
        options: Options(
            headers: {"x-api-key": urlsModel.apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: getNFTSRequest.toJson()));
    debugPrint('nftdata inside2');

    naftresponse =
        NFTResponse.fromJson(((response.data)) as Map<String, dynamic>);
    List<Body> userNMFT = [];
    userNMFT.addAll(naftresponse.body.toList());
    debugPrint('nftdata inside3');

    //  debugPrint('nftdata nfts are ${userNMFT[2].utility.toString()}');
    return naftresponse;
  }

  Future<NFTDataResponse> getMarketPlaceNFTs({bool forceRefresh}) async {
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
