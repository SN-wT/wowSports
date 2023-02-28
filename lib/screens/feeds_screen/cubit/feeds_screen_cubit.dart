import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/model/create_post_model.dart';
import 'package:wowsports/screens/feeds_screen/model/feeds_list_model.dart';
import 'package:wowsports/screens/feeds_screen/model/reactions_update_model.dart';
import 'package:wowsports/screens/feeds_screen/post_item.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/base_cubit.dart';
import 'package:wowsports/utils/shared_preference.dart';

import 'feeds_screen_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedsScreenCubit extends BaseCubit<FeedsScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  List<PostItem> posts = [];
  TextEditingController postTextController = TextEditingController();
  String pickedpath = null;

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
    debugPrint(
        'calling getPosts${authenticationCubit.urlsModel.getPosts} and ${authenticationCubit.urlsModel.apikey} }');
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

    posts = [];
    var listofResponses = getPostsResponse.data as List<dynamic>;

    for(var i = 0; i < listofResponses.length; i++)  {

      var getPostsResponseJson  = FeedsModel.fromJson(
          jsonDecode(jsonEncode(listofResponses[i] as Map<String, dynamic>)));
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(int.parse(getPostsResponseJson.timestamp)*1000);
      bool likedFlag = await PreferenceHelper.checkLikedPost(getPostsResponseJson.id);

      posts.add(PostItem(postid: getPostsResponseJson.id,address: getPostsResponseJson.acct, time: timeago.format(tsdate), posttext: getPostsResponseJson.post, img: getPostsResponseJson.url, likeCount: int.parse(getPostsResponseJson.reactionCount), likedFlag: likedFlag, feedsCubit: this));

    }

    debugPrint('after serialization ');

    return "Success";
  }

  updatePostReactions(String postid) async {

        debugPrint('liked for $postid');
        await PreferenceHelper.saveLike(postid);
        debugPrint('added to preference helper');
        var reactionsUpdate = ReactionsUpdateModel(postid: postid);
        var reactionsUpdateResponse = (await Dio().post(authenticationCubit.urlsModel.postReaction,
            options: Options(
                headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }),
            data: reactionsUpdate.toJson()));

        debugPrint('update response from request ${reactionsUpdateResponse.data}');


    }

  Future<String> createPost(BuildContext context) async {

    AppUtils.showSnackBar("Processing...", context);
    debugPrint('make a post with ${postTextController.value.text}');

    var postCreator = CreatePost(userId: FirebaseAuth.instance.currentUser.uid,post: postTextController.value.text, url: "");
    if (pickedpath != null) {

      emit(FeedsScreenUploadImageState());

      String uploadedFile = await uploadFiles(pickedpath);
      if (uploadedFile != null && uploadedFile != "Error") {
        postCreator.url = uploadedFile;
        pickedpath = null;
      } else {
        emit(FeedsScreenErrorState("Error with file upload! Please check connectivity & try again later"));
        return null;
      }
    }

    if (authenticationCubit.urlsModel == null) {
      await authenticationCubit.getMasterUrlsandtokens();
    }

    emit(FeedsScreenSavingPostState());

    var createPostResponse = (await Dio().post(authenticationCubit.urlsModel.createPost,
        options: Options(
            headers: {"x-api-key": authenticationCubit.urlsModel.apikey},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: postCreator.toJson()));



    debugPrint("respones is ${createPostResponse.data.toString()}");
    if (createPostResponse != null && createPostResponse.toString().contains("Post created successfully")) {
        debugPrint('Hooray got your post!');
        this.init();
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

  Future<String> uploadFiles(String filepath) async {

    final storageRef = FirebaseStorage.instance.ref();
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String timeStampString = timeStamp.toString();
    String userid = FirebaseAuth.instance.currentUser.uid;
    var childref = storageRef.child("fanposts/"+userid+"/"+timeStampString+".jpg");
    try {
      File file = File(filepath);

      await childref.putFile(file);
      return childref.getDownloadURL();

    }  catch (e) {
      debugPrint('Something went wrong! $e');
      return "Error";
    }

  }

  /*
  String readTimestamp(int timestamp) {


    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
  */

}
