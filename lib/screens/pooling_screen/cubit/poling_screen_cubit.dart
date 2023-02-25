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
  int pollingIndex;

  PolingScreenCubit(this.authenticationCubit)
      : super(PolingScreenInitialState());

  Future<void> init() async {
    emit(PolingScreenLoadingState());
    await getPollsData();
    emit(PolingScreenLoadedState());
  }

  Future<PollingResponse> request(chice, pollname, index) async {
    pollingIndex = index;
    emit(PollingScreenPoleRequestedState());
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    var uid = FirebaseAuth.instance.currentUser.uid;
    debugPrint('the mint response is ${uid.toString()}');
    debugPrint('the mint response is ${chice.toString()}');
    debugPrint('the mint response is ${pollname.toString()}');
    debugPrint(
        'the mint response is ${authenticationCubit.urlsModel.pollrequest}');
    debugPrint('the mint response is ${authenticationCubit.urlsModel.apikey}');

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
    choicesMap.forEach((key, value) {
      debugPrint('pollresponse was = $key');
      debugPrint('pollresponse was is = $value');
    });
    emit(PolledState());
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
