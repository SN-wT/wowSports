import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_state.dart';
import 'package:wowsports/screens/pooling_screen/model/poll_detail_model.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_request_model.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_response_model.dart';

class PolingScreenCubit extends Cubit<PolingScreenState> {
  AuthenticationCubitBloc authenticationCubit;
  String email;
  Map<String, PollDetail> pollsDetail = {};
  List<PollDetail> polls = [];
  List<String> questions = [];

  PolingScreenCubit(this.authenticationCubit)
      : super(PolingScreenInitialState());

  Future<void> init() async {
    emit(PolingScreenLoadingState());
    await getPollsData();
    emit(PolingScreenLoadedState());
  }

  Future<PollingResponse> request(chice, pollname) async {
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    var uid = FirebaseAuth.instance.currentUser.uid;

    PollingRequest pollingRequest =
        PollingRequest(userId: uid, pollname: pollname, choice: chice);
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
    PollingResponse pollingResponse =
        PollingResponse.fromJson(((response.data as Map<String, dynamic>)));
    debugPrint('pollresponse is = ${pollingResponse}');
    // if(pollingResponse.body.toString() == )
  }

  getPollsData() async {
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    var response = (await Dio().getUri(
      Uri.parse(
        authenticationCubit.urlsModel.getpollsdata,
      ),
      options: Options(
          headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    ));
    var responseMap = response.data as Map<String, dynamic>;

    responseMap.forEach((key, value) {
      pollsDetail[key] = PollDetail.fromJson(value);
    });

    for (var element in pollsDetail.keys) {
      questions.add(element);
      debugPrint('key is $element');
      polls.add(pollsDetail[element]);
      debugPrint('choice A iwas ${polls[0].pollURL}');

      debugPrint('choice A is  is ${pollsDetail[element].pollURL}');

      debugPrint('choice A is  is ${pollsDetail[element].choiceA}');
    }

    debugPrint("all replace all ${pollsDetail.length}");
  }
}
