import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/cubit/feeds_screen_cubit.dart';
import 'package:wowsports/screens/feeds_screen/post_item.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/widgets/button.dart';
import 'package:wowsports/widgets/myappbar.dart';

import 'cubit/feeds_screen_state.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedsScreenCubit>();

    return Scaffold(
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is FeedsScreenErrorState) {
            AppUtils.showSnackBar(state.error, context);
          }
        },
        child: const FeedsScreens(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColorResource.Color_0EA,
        elevation: 5,
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return PostCreatorWidget();
            },
          );
        },
        child:
            const Icon(Icons.edit, color: AppColorResource.Color_F3F, size: 30),
      ),
    );
  }
}

class FeedsScreens extends StatelessWidget {
  const FeedsScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedsScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return BlocBuilder<FeedsScreenCubit, FeedsScreenState>(
      bloc: cubit,
      builder: (context, state) => Container(
        child: Column(
          children: [
            const MyAppBar(
              appbartitle: 'Feeds',
            ),
            state is FeedsScreenLoadingState
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColorResource.Color_1FFF,
                  ))
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cubit.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        PostItem postItem = cubit.posts[index];
                        return postItem;
                        /*
                  return PostItem(
                    img: post.img,
                    address: post.address,
                    //dp: post.dp,
                    time: post.time,
                  );

                   */
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


class PostCreatorWidget extends StatefulWidget {
  const PostCreatorWidget({Key key}) : super(key: key);

  @override
  State<PostCreatorWidget> createState() => _PostCreatorWidgetState();
}

class _PostCreatorWidgetState extends State<PostCreatorWidget> {
  String _pickedPath = null;
  File _image = null;
  bool showImage = false;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedsScreenCubit>();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColorResource.Color_000),
          borderRadius: BorderRadius.circular(5),
          color: AppColorResource.Color_FFF),
      height: ((MediaQuery.of(context).size.height) / 1.9),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 23,
                        color: AppColorResource.Color_000,
                      ),
                    )), //icon for close button
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Create Post',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColorResource.Color_000,
                          fontFamily: 'Nunito',
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ), //text for heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            height: 35,
                            width:
                            (MediaQuery.of(context).size.width /
                                (4)),
                            child: AppButton(
                              onPressed: () async {
                                if (cubit.postTextController.value.text != null && cubit.postTextController.value.text.length > 0) {
                                  Navigator.pop(context);
                                  cubit.createPost(context);
                                } else {
                                  AppUtils.showSnackBar("Oops... Enter something to post!", context);
                                }
                              },
                              child: const Text('Post'),
                            ),
                          ),
                        )),
                  ],
                ), //this is for app button

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height:
                    ((MediaQuery.of(context).size.height) / 5),
                    width:
                    (MediaQuery.of(context).size.width / (1.3)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorResource.Color_FFF,
                        border: Border.all(
                            color: AppColorResource.Color_000)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        cursorColor: AppColorResource.Color_FFF,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "What's your take on the latest in sport?",
                          hintStyle: TextStyle(
                              color: AppColorResource.Color_000),
                        ),
                        style: const TextStyle(
                            color: AppColorResource.Color_000),
                        controller: cubit.postTextController,
                        onTap: () {
                        },
                        obscureText: false,
                      ),
                    ),
                  ),
                ), // this is for textfield
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: IconButton(
                          onPressed: () async {

                            var imagePicker = new ImagePicker();
                         //   var _image;
                            var source = ImageSource.gallery;
                            XFile image = await imagePicker.pickImage(
                                source: source,
                                imageQuality: 50,
                                preferredCameraDevice: CameraDevice.front);

                            _image = File(image.path);

                            debugPrint('the image path is ${_image.path}');
                            setState(() {
                              if (_image.toString() != null) {
                                _pickedPath = _image.path;
                                cubit.pickedpath = _pickedPath;
                                showImage = true;
                              }
                            });


                          },
                          icon: const Icon(
                            Icons.photo,
                            color: AppColorResource.Color_000,
                            size: 35,
                          )),
                    )
                  ],
                ),
                _image == null ? Container() : Visibility(
                visible: showImage,
                child: Center(
                  child: Image.file(
                    _image,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.fill,
                  ),
                )),// this is for camera icon button
                // this is for camera icon button
              SizedBox(height: 10,)],
            ),
          ),
        ],
      ),
    );
  }
}

