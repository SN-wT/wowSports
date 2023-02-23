import 'package:flow_dart_sdk/fcl/fcl.dart';
import 'package:flow_dart_sdk/fcl/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/utility_screen/cubit/utility_screen_state.dart';
import 'package:wowsports/utils/base_cubit.dart';

class UtilityScreenCubit extends BaseCubit<UtilityScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  static const platform = MethodChannel("com.wowt.flowhackathon/aractivity");

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
    ;
    final decoded = flowClient.decodeResponse(response);
    var cadencedecode = CadenceValue.fromJson(decoded);
    debugPrint('cadencedecode ${cadencedecode.toJson()}');
    debugPrint('$decoded');
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
}
