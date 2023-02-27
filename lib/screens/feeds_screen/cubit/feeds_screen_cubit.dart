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
    var postItem1 = PostItem(address: "0x01",
        time: "13:02",
        posttext: "Looking forward to Following sports on wowSports",
        likeCount: 10,
        likedFlag: false,
        img: "https://thumbs.dreamstime.com/b/sport-collage-boxing-soccer-american-football-basketball-baseball-ice-hockey-etc-multi-professional-tennis-l-bascketball-players-93401905.jpg");
    posts.add(postItem1);
    debugPrint("text 1 is ${postItem1.posttext}");
    var postItem2 = PostItem(address: "0x02",
        time: "2 days ago",
        posttext: "Congrats to the Aussie team on the win",
        likeCount: 500,
        likedFlag: true,
        img: "https://img1.hscicdn.com/image/upload/f_auto,t_ds_w_1280,q_80/lsci/db/PICTURES/CMS/355200/355237.jpg");
    posts.add(postItem2);
    debugPrint("text 2 is ${postItem2.posttext}");
    return "Success";
  }


}
