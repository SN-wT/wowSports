import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/model/create_post_model.dart';
import 'package:wowsports/screens/feeds_screen/post_item.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/base_cubit.dart';

import 'feeds_screen_state.dart';

class FeedsScreenCubit extends BaseCubit<FeedsScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  List<PostItem> posts = [];
  TextEditingController postTextController = TextEditingController();

  FeedsScreenCubit(this.authenticationCubit) : super(FeedsScreenInitialState());

  Future<void> init() async {
    emit(FeedsScreenLoadingState());
    await loadPosts();
    emit(FeedsScreenRefreshState());
  }

  Future<String> loadPosts() async {

    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    debugPrint('calling getPosts${authenticationCubit.urlsModel.getPosts} and ${ authenticationCubit.urlsModel.apikey} }');
    var getPostsResponse = (await Dio().getUri(
      Uri.parse(
        authenticationCubit.urlsModel.getPosts,
      ),
      options: Options(
          headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    ));

    debugPrint('getPosts response received');
    debugPrint('${getPostsResponse.data.toString()}');

    /*
    var postItem1 = PostItem(
        address: "0x01",
        time: "13:02",
        posttext: "Looking forward to Following sports on wowSports",
        likeCount: 10,
        likedFlag: false,
        img:
            "https://thumbs.dreamstime.com/b/sport-collage-boxing-soccer-american-football-basketball-baseball-ice-hockey-etc-multi-professional-tennis-l-bascketball-players-93401905.jpg");
    posts.add(postItem1);
    debugPrint("text 1 is ${postItem1.posttext}");
    var postItem2 = PostItem(
        address: "0x02",
        time: "2 days ago",
        posttext: "Congrats to the Aussie team on the win",
        likeCount: 500,
        likedFlag: true,
        img:
            "https://img1.hscicdn.com/image/upload/f_auto,t_ds_w_1280,q_80/lsci/db/PICTURES/CMS/355200/355237.jpg");
    posts.add(postItem2);
    debugPrint("text 2 is ${postItem2.posttext}");

     */
    return "Success";
  }

  Future<String> createPost(BuildContext context) async {

    debugPrint('make a post with ${postTextController.value.text}');


    AppUtils.showSnackBar("Saving your post...", context);
    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }
    var createPostResponse = (await Dio().post(authenticationCubit.urlsModel.createPost,
        options: Options(
            headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: CreatePost(userId: FirebaseAuth.instance.currentUser.uid,post: postTextController.value.text, url: "https://img1.hscicdn.com/image/upload/f_auto,t_ds_w_1280,q_80/lsci/db/PICTURES/CMS/355200/355237.jpg").toJson()));

    if (createPostResponse != null && createPostResponse.toString().contains("Post created successfully")) {
        debugPrint('Hooray got your post!');
    } else {
      debugPrint('Something went wrong!');
    }
    /*
   // CreatePostResponse response = CreatePostResponse.fromJson(createPostResponse.data as Map<String, dynamic>);
    var response  = CreatePostResponse.fromJson(
        jsonDecode(jsonEncode(createPostResponse.data as Map<String, dynamic>)));

    debugPrint('${response.body.toString()}');

     debugPrint('created post ${createPostResponse.data}');

    if (response.body == null) {
      debugPrint('body null');
    //  AppUtils.showSnackBar("Something went wrong! Try again later", context);
    } else {

      debugPrint('body not null');
      debugPrint('${response.body}');
      */
    //  AppUtils.showSnackBar("Got your post! It should appear on feeds shortly", context);




  }

  Future<String> uploadFiles() async {




    final storageRef = FirebaseStorage.instance.ref();
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String timeStampString = timeStamp.toString();
    String userid = FirebaseAuth.instance.currentUser.uid;
    storageRef.child("fanposts/"+userid+"/"+timeStampString+".jpg");

  }

}
