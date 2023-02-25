import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/settings_screen/cubit/settings_screen_state.dart';
import 'package:wowsports/screens/settings_screen/model/mint_NFT_nodel/mint_request.dart';
import 'package:wowsports/screens/settings_screen/model/mint_NFT_nodel/mint_response_model.dart';
import 'package:wowsports/screens/settings_screen/model/nftclaim_model/nftclaim_model.dart';
import 'package:wowsports/utils/base_cubit.dart';
import 'package:wowsports/utils/shared_preference.dart';

class SettingsScreenCubit extends BaseCubit<SettingsScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  TextEditingController creditcardcontroller = TextEditingController();
  TextEditingController cvvcontroller = TextEditingController();
  var url = '';
  NFTClaimModel nftClaimModel;
  List<String> minted = [];
  int mintingIndex;
  MintResponse mintResponse;
  var packName = '';

  SettingsScreenCubit(this.authenticationCubit)
      : super(SettingsScreenInitialState());

  Future<void> init() async {
    emit(SettingsScreenLoadingState());
    if (authenticationCubit.nftData.isEmpty) {
      await authenticationCubit.getMarketPlaceNFTs();
    }
    for (var i = 0; i < authenticationCubit.nftData.length; i++) {
      minted.add("false");
    }
    var uid = FirebaseAuth.instance.currentUser?.uid;
    for (var j = 0; j < authenticationCubit.nftData.length; j++) {
      var mintCheck = await FirebaseDatabase.instance
          .ref('Master')
          .child('Address')
          .child(uid)
          .child(authenticationCubit.nftClaimModel.packname)
          .child(authenticationCubit.nftData[j].name)
          .get();
      if (mintCheck.value.toString() == "minted") {
        debugPrint('list name: ${authenticationCubit.nftData[j].name}');

        debugPrint('list items1 ${minted[j]}');
        minted[j] = "true";
      } else {
        debugPrint('list items ${minted[j]}');
        minted[j] = "false";
      }
    }

    emit(SettingsScreenRefreshState());

//above code for getting packname from db
  }

  mint(nftname, index, length) async {
    mintingIndex = index;
    emit(SettingsScreenMintRequestedState(index));
    if (authenticationCubit.nftClaimModel == null) {
      await authenticationCubit.getMasterNFTClaim();
    }
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }

    var uid = FirebaseAuth.instance.currentUser?.uid;
    var address = await PreferenceHelper.getToken();
    MintRequest mintRequest = MintRequest(
        packName: authenticationCubit.nftClaimModel.packname,
        userId: uid,
        address: address,
        nftName: nftname);
    var response = await Dio().post(
        authenticationCubit.urlsModel.mintRequestUrl,
        data: mintRequest.toJson(),
        options: Options(
            headers: {"x-api-key": authenticationCubit.nftClaimModel.apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
    mintResponse = MintResponse.fromJson(
        jsonDecode(jsonEncode(response.data as Map<String, dynamic>)));
    debugPrint('the mint response is ${response.toString()}');
    var mintCheck = await FirebaseDatabase.instance
        .ref('Master')
        .child('Address')
        .child(uid)
        .child(authenticationCubit.nftClaimModel.packname)
        .child(nftname)
        .get();
    debugPrint('the mint check is ${mintCheck.value.toString()}');
    if (mintResponse.body.toString() == "NFT minted successfully") {
      debugPrint('hello');
      minted[index] = "true";
    } else {
      debugPrint('hello');
      minted[index] = "false";
    }

    emit(SettingsScreenMintedState());
    //  var response =  Dio().post();
  }
/*
  check() async {
    mintingIndex =
    emit(SettingsScreenMintRequestedState(in));
    if (nftClaimModel == null) {
      await authenticationCubit.getMasterNFTClaim();
    }
    var uid = FirebaseAuth.instance.currentUser?.uid.toString();
    debugPrint('the mintcheck is ${authenticationCubit.nftClaimModel.apikey}');

    var packname = authenticationCubit.nftClaimModel.packname;
    var mintCheck = await FirebaseDatabase.instance
        .ref('Master/Address/$uid/$packname')
        .get();
    debugPrint('the mintcheck is ${mintCheck.value.toString()}');
    emit(SettingsScreenMintedState());
  }

 */
}
