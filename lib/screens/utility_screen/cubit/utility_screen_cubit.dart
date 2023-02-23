import 'package:dio/dio.dart';
import 'package:flow_dart_sdk/fcl/fcl.dart';
import 'package:flow_dart_sdk/fcl/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/pooling_screen/model/poll_detail_model.dart';
import 'package:wowsports/screens/utility_screen/cubit/utility_screen_state.dart';
import 'package:wowsports/utils/base_cubit.dart';

class UtilityScreenCubit extends BaseCubit<UtilityScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  static const platform = MethodChannel("com.wowt.flowhackathon/aractivity");
  var getnft;

  UtilityScreenCubit(this.authenticationCubit)
      : super(UtilityScreenInitialState());

  Future<void> init() async {
    emit(UtilityScreenLoadingState());
  }

  void getArAvatarActivity() async {
    try {
      await platform.invokeMethod('startNewActivity');
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  flow() async {
    //var address = await PreferenceHelper.getToken();

    FlowClient flowClient = FlowClient('access.devnet.nodes.onflow.org', 9000);
    var code = '''import wowSportsPoll from 0x59b297f21e60da9d

  pub fun main(): {String: wowSportsPoll.Choices} {
     return wowSportsPoll.getPollDetails()
   }''';
    //var arguments = [CadenceValue(value: address, type: CadenceType.String)];
    var response = await flowClient.executeScript(code);

    flowClient.decodeResponse(response);

    final decoded = flowClient.decodeResponse(response);
    var cadencedecode = CadenceValue.fromJson(decoded).toJsonString();

    debugPrint('cadencedecode ${cadencedecode}');
    // debugPrint('$decoded');
    debugPrint('${decoded["value"][0]}');

    /*
    final result = jsonDecode((response.value.toString()));
    //  debugPrint("the json result is is${result.toString()}");
    if (kDebugMode) {
      print(' the [parsed data ${result.runtimeType} : $result');
    }
    var abc = decoded.values.toList();
    debugPrint("the decoded response is${decoded.values.toList()}");

    debugPrint("✅ Done${abc}");
    */
  }

  getnfts() async {
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

    Map<String, PollDetail> pollsDetail = {};

    responseMap.forEach((key, value) {
      pollsDetail[key] = PollDetail.fromJson(value);
    });

    for (var element in pollsDetail.keys) {
      debugPrint('key is $element');
      debugPrint('choice A is  is ${pollsDetail[element].choiceA}');
    }

    debugPrint("all replace all ${pollsDetail.length}");
  }
}
