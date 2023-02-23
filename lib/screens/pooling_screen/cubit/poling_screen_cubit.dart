import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_state.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_request_model.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_response_model.dart';

class PolingScreenCubit extends Cubit<PolingScreenState> {
  AuthenticationCubitBloc authenticationCubit;
  var email;

  PolingScreenCubit(this.authenticationCubit)
      : super(PolingScreenInitialState());

  Future<void> init() async {
    emit(PolingScreenLoadingState());

    emit(PolingScreenLoadedState());
  }

  Future<PollingResponse> request() async {
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    var uid = FirebaseAuth.instance.currentUser.uid;

    PollingRequest pollingRequest =
        PollingRequest(userId: uid, pollname: "", choice: "");
    var response = (await Dio().post(
      authenticationCubit.urlsModel.pollrequest,
      options: Options(
          headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
      data: pollingRequest.toJson(),
    ));
    PollingResponse pollingResponse = PollingResponse.fromJson(
        jsonDecode(jsonEncode(response.data as Map<String, dynamic>)));
    // if(pollingResponse.body.toString() == )
  }
}
