import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/screens/feeds_screen/cubit/feeds_screen_cubit.dart';
import 'package:wowsports/utils/color_resource.dart';

class PostItem extends StatefulWidget {
  // final String dp;
  final String postid;
  final String address;
  final String time;
  final String img;
  final String posttext;
  final FeedsScreenCubit feedsCubit;
  int likeCount;
  bool likedFlag;

  PostItem({
    Key key,
    // @required this.dp,
    this.postid,
    @required this.address,
    @required this.time,
    @required this.posttext,
    this.img,
    this.likeCount,
    this.likedFlag,
    this.feedsCubit,
  }) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    bool showPost = true;
    bool showImage = true;
    debugPrint("postText is ${widget.posttext}");
    if (widget.posttext == null) {
      showPost = false;
    }
    if (widget.img == null || widget.img == "") {
      showImage = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          color: AppColorResource.Color_F3F.withOpacity(0.6),
          /*
              border: Border.all(
                  color:
                  AppColorResource
                      .Color_000),
              */
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              /*
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    "${widget.dp}",
                  ),
                ),
                 */
              contentPadding: EdgeInsets.all(0),
              title: Text(
                widget.address,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                widget.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Visibility(
              visible: showPost,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                child: Text(
                  widget.posttext,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Visibility(
                visible: showImage,
                child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    placeholder: (context, url) => const SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColorResource.Color_FFF,
                            ),
                          ),
                        ),
                    fit: BoxFit.fill,
                    imageUrl: widget.img ?? "")),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [],
                ),
                /*
                LikeButton(
                    likeCount: widget.likeCount,
                    isLiked: widget.likedFlag,
                    onTap: onLikeButtonTapped),

                 */
/*
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LikeButton(
                      likeCount: widget.likeCount,
                      isLiked: widget.likedFlag,
                      onTap: check()),
                  */

                Row(
                  children: [
                    IconButton(
                      onPressed: widget.likedFlag == true
                          ? null
                          : () async {
                              widget.feedsCubit.updatePostReactions(widget.postid);
                              setState(() {
                                debugPrint(" the count is ${widget.likeCount}");
                                widget.likeCount += 1;
                                debugPrint(
                                    "the count is 3 ${widget.likeCount}");
                                widget.likedFlag = true;
                              });
                            },
                      icon: Icon(Icons.favorite_sharp,
                          color: widget.likedFlag == false
                              ? Colors.grey
                              : Colors.red),
                    ),
                    Text("${widget.likeCount.toInt()}")
                  ],
                )

/*
                LikeButton(
                  likeBuilder: (bool isLiked) {
                    return check();
                  },
                  likeCount: widget.likeCount,
                  isLiked: widget.likedFlag,
                  onTap: (isLiked) {
                    onLikeButtonTapped;
                    check();
                  },
                ),

 */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
