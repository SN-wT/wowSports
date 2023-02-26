import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_state.dart';
import 'package:wowsports/screens/pooling_screen/model/poll_detail_model.dart';
import 'package:wowsports/screens/pooling_screen/model/pollcount_request_model.dart';
import 'package:wowsports/screens/pooling_screen/model/polling_model/polling_model/polling_request_model.dart';

class PolingScreenCubit extends Cubit<PolingScreenState> {
  AuthenticationCubitBloc authenticationCubit;
  String email;
  Map<String, PollDetail> pollsDetail = {};
  List<PollDetail> polls = [];
  List<String> questions = [];
  int pollingIndex;
  List polledLists = [];
  Map<String, int> choicesResponseMap = {};
  Map<int, Map<String, int>> crossrefchoicesResponseMap = {};

  PolingScreenCubit(this.authenticationCubit)
      : super(PolingScreenInitialState());

  Future<void> init() async {
    emit(PolingScreenLoadingState());
    await getPollsData();
    emit(PolingScreenLoadedState());
  }

  Future<Map<String, int>> getPollAnswers(int index) async {
    debugPrint(
        'Pollresponse map returning ${crossrefchoicesResponseMap[index]} for $index');
    // return crossrefchoicesResponseMap[index];

    if (polledLists.contains(questions[index])) {
      PollCountRequestModel pollCountRequestModel =
      PollCountRequestModel(pollname: questions[index]);
      var response = (await Dio().post(
          authenticationCubit.urlsModel.pollcountrequest,
          options: Options(
              headers: {
                "x-api-key": authenticationCubit.urlsModel.apikey
              },
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
          data: pollCountRequestModel.toJson()));
      var pollmap = response.data as Map<String, dynamic>;
      choicesResponseMap = {};
      pollmap.forEach((key, value) {
        choicesResponseMap[key] = int.parse(value);
        debugPrint('the choicemap key is ${choicesResponseMap[key]}');
      });
      for (var j = 0; j < polls.length; j++) {
        if (choicesResponseMap.length != 3) {
          if (!choicesResponseMap.keys.contains(polls[j].choiceA)) {
            choicesResponseMap[polls[j].choiceA] = 0;
          }
          if (!choicesResponseMap.keys.contains(polls[j].choiceB)) {
            choicesResponseMap[polls[j].choiceB] = 0;
          }
          if (!choicesResponseMap.keys.contains(polls[j].choiceC)) {
            choicesResponseMap[polls[j].choiceC] = 0;
          }
        }
      }

      debugPrint('result is ${response.data}');
      return choicesResponseMap;
    } else {
      return null;
    }
    /*
    debugPrint('polled lists are 4 ${questions}');

     */
  }

  vottedLists() async {
    //  debugPrint('polled lists are ${questions}');
    var auth = FirebaseAuth.instance.currentUser.uid;
    debugPrint('polled lists are 1 ${questions[0]}');

    final votteditems = await FirebaseDatabase.instance
        .ref("Master/Address/$auth/PollDetail/")
        .get();
    debugPrint('polled lists are 2 ${questions}');
    if (votteditems.value != null) {
      var pollsmap =
      jsonDecode(jsonEncode(votteditems.value)) as Map<String, dynamic>;
      debugPrint('polled lists are 3 $questions');
      pollsmap.forEach((key, value) async {
        for (var i = 0; i < questions.length; i++) {
          debugPrint('polled lists are 5 ${questions[i]}');
          debugPrint('polled lists are 6 $key');

          if (questions[i] == key) {
            polledLists.add(key);
          }
        }
      });
    }
  }

  /*
  vottedLists() async {
    //  debugPrint('polled lists are ${questions}');
    var auth = FirebaseAuth.instance.currentUser.uid;
    debugPrint('polled lists are 1 ${questions[0]}');

    final votteditems = await FirebaseDatabase.instance
        .ref("Master/Address/$auth/PollDetail/")
        .get();
    debugPrint('polled lists are 2 ${questions}');
    if (votteditems.value != null) {
      var pollsmap =
          jsonDecode(jsonEncode(votteditems.value)) as Map<String, dynamic>;
      debugPrint('polled lists are 3 $questions');
      pollsmap.forEach((key, value) async {
        for (var i = 0; i < questions.length; i++) {
          debugPrint('polled lists are 5 ${questions[i]}');
          debugPrint('polled lists are 6 $key');

          if (questions[i] == key) {
            polledLists.add(key);
            debugPrint('polled lists are 4 ${questions}');
            PollCountRequestModel pollCountRequestModel =
                PollCountRequestModel(pollname: key);
            var response = (await Dio().post(
                authenticationCubit.urlsModel.pollcountrequest,
                options: Options(
                    headers: {
                      "x-api-key": authenticationCubit.urlsModel.apikey
                    },
                    followRedirects: false,
                    validateStatus: (status) {
                      return status < 500;
                    }),
                data: pollCountRequestModel.toJson()));
            var pollmap = response.data as Map<String, dynamic>;
            choicesResponseMap = {};
            pollmap.forEach((key, value) {
              choicesResponseMap[key] = int.parse(value);
              debugPrint('the choicemap key is ${choicesResponseMap[key]}');
            });
            for (var j = 0; j < polls.length; j++) {
              if (choicesResponseMap.length != 3) {
                if (!choicesResponseMap.keys.contains(polls[j].choiceA)) {
                  choicesResponseMap[polls[j].choiceA] = 0;
                }
                if (!choicesResponseMap.keys.contains(polls[j].choiceB)) {
                  choicesResponseMap[polls[j].choiceB] = 0;
                }
                if (!choicesResponseMap.keys.contains(polls[j].choiceC)) {
                  choicesResponseMap[polls[j].choiceC] = 0;
                }
              }
            }
            crossrefchoicesResponseMap[i] = choicesResponseMap;
            debugPrint('result is ${response.data}');
            debugPrint(
                'Pollresponse map updated responsed map ${crossrefchoicesResponseMap.keys}');
          }
        }
      });
    }
  }

  */


  Future<Map<String, int>> request(chice, pollname, index) async {




    var auth = FirebaseAuth.instance.currentUser.uid;

    var FBDBref = FirebaseDatabase.instance.ref("Master/Address/$auth/PollDetail");
    var pollnameModified = pollname.toString().replaceAll(" ", "").replaceAll(".", "");
    debugPrint('DB ref is ${FBDBref.toString()}');
    debugPrint('DB ref Poll name is $pollname');
    FBDBref.update({"$pollnameModified": "Polled"});

    /*
    await FirebaseDatabase.instance
        .ref("Master/Address/$auth/PollDetail")
        .update({"$pollname": "Polled"});

     */
    /*
    pollingIndex = index;
    debugPrint('the index $index and $pollname and $chice');
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

    var auth = FirebaseAuth.instance.currentUser.uid;
    debugPrint();
    await FirebaseDatabase.instance
        .ref("Master/Address/$auth/PollDetail")
        .update({"$pollname": "Polled"});
    emit(PolledState());

     */
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
    var responseMap =
    (jsonDecode(response.data.toString().replaceAll("\\", "")))
    as Map<String, dynamic>;
    debugPrint("response map $responseMap");

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
    await vottedLists();

    debugPrint("all replace all ${pollsDetail.length}");
  }
}
