import 'package:dio/dio.dart';
import 'package:flow_dart_sdk/fcl/fcl.dart';
import 'package:flow_dart_sdk/fcl/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/post_item.dart';
import 'package:wowsports/screens/pooling_screen/model/poll_detail_model.dart';
 import 'package:wowsports/utils/base_cubit.dart';

import 'feeds_screen_state.dart';

class FeedsScreenCubit extends BaseCubit<FeedsScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  List<PostItem> posts = [];

  FeedsScreenCubit(this.authenticationCubit)
      : super(FeedsScreenInitialState());

  Future<void> init() async {
    emit(FeedsScreenLoadingState());
    await loadPosts();
    emit(FeedsScreenRefreshState());
  }


  Future<String> loadPosts() async {

    var postItem1 = PostItem(address: "0x01",time: "13:02", posttext: "Looking forward to Following sports on wowSports",likeCount: 10, likedFlag: false, img: "https://thumbs.dreamstime.com/b/sport-collage-boxing-soccer-american-football-basketball-baseball-ice-hockey-etc-multi-professional-tennis-l-bascketball-players-93401905.jpg");
    posts.add(postItem1);
    debugPrint("text 1 is ${postItem1.posttext}");
    var postItem2 = PostItem(address: "0x02",time: "2 days ago", posttext: "Congrats to the Aussie team on the win",likeCount: 500, likedFlag: true, img: "https://img1.hscicdn.com/image/upload/f_auto,t_ds_w_1280,q_80/lsci/db/PICTURES/CMS/355200/355237.jpg");
    posts.add(postItem2);
    debugPrint("text 2 is ${postItem2.posttext}");
    return "Success";

  }

  /*
  void getArAvatarActivity() async {
    try {
      await platform.invokeMethod('startNewActivity');
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  void getAr3DAvatarActivity() async {
    try {
      platform.invokeMethod('3DModelActivity', {
        'URL':
        "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2Fsportsman.glb?alt=media&token=35ad0782-3449-4886-8a0e-70aff34f36cb"
      });
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  void getVideoArAvatarActivity() async {
    try {
      platform.invokeMethod('ARVideoActivity', {
        'URL':
        "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2Fnbatospshot1compressed.mp4?alt=media&token=6aaa9283-9091-46d0-8485-7ea285cf64b3"
      });
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
/*
  account() async {
    FlowClient flowClient = FlowClient('access.devnet.nodes.onflow.org', 9000);
    var account = await flowClient.getAccount("a8f07ba02d2b10d5");
    debugPrint('account is ${account}');
    debugPrint('keys ${account.account.keys[0].index0}');
  }

 */

*/
}
