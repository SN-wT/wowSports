import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_state.dart';
import 'package:wowsports/screens/pooling_screen/model/poll_detail_model.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_request_model.dart';

class PolingScreenCubit extends Cubit<PolingScreenState> {
  AuthenticationCubitBloc authenticationCubit;
  String email;
  Map<String, PollDetail> pollsDetail = {};
  List<PollDetail> polls = [];
  List<String> questions = [];
  int pollingIndex;
  Map<String, int> choicesResponseMap = {};

  PolingScreenCubit(this.authenticationCubit)
      : super(PolingScreenInitialState());

  Future<void> init() async {
    emit(PolingScreenLoadingState());
    await getPollsData();
    emit(PolingScreenLoadedState());
  }

  Future<Map<String, int>> request(chice, pollname, index) async {
    pollingIndex = index;
    emit(PollingScreenPoleRequestedState());
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

    var reponsejson = response.data as Map<String, dynamic>;
    debugPrint('the mint reesponse is ${reponsejson}');
    if (reponsejson == null) {
      emit(AllreadyPolledState());
    }
    var choicesMap = reponsejson['body'] as Map<String, dynamic>;
    choicesResponseMap = {};
    choicesMap.forEach((key, value) {
      choicesResponseMap[key] = int.parse(value);
      debugPrint('pollresponse was = $key');
      debugPrint('pollresponse was is = $value');
    });
    if (choicesResponseMap.length != 3) {
      if (!choicesResponseMap.keys.contains(polls[index].choiceA)) {
        choicesResponseMap[polls[index].choiceA] = 0;
      }
      if (!choicesResponseMap.keys.contains(polls[index].choiceB)) {
        choicesResponseMap[polls[index].choiceB] = 0;
      }
      if (!choicesResponseMap.keys.contains(polls[index].choiceC)) {
        choicesResponseMap[polls[index].choiceC] = 0;
      }
    }
    emit(PolledState());
    return choicesResponseMap;
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
