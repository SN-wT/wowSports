
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:wowsports/utils/color_resource.dart';

class PostItem extends StatefulWidget {
 // final String dp;
  final String address;
  final String time;
  final String img;
  final String posttext;
  final int likeCount;
  final bool likedFlag;


  PostItem({
    Key key,
   // @required this.dp,
    @required this.address,
    @required this.time,
    @required this.posttext,
    this.img,
    this.likeCount,
    this.likedFlag,
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
    if (widget.img == null) {
      showImage = false;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
              color: AppColorResource
                  .Color_FFF
                  .withOpacity(0.6),
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
                  "${widget.address}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "${widget.time}",
                  style: TextStyle(
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
                  "${widget.posttext}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
             ),),
          Visibility(
              visible: showImage,
              child: CachedNetworkImage(
                  width:
                  MediaQuery
                      .of(context)
                      .size
                      .width,
                  height:
                  MediaQuery
                      .of(context)
                      .size
                      .height /
                      3,
                  placeholder: (context, url) =>
                  const SizedBox(
                    child: Center(
                      child:
                      CircularProgressIndicator(
                        color: AppColorResource
                            .Color_FFF,
                      ),
                    ),
                  ),
                  fit: BoxFit.fill,
                  imageUrl: widget.img ??
                      "")),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LikeButton(likeCount: widget.likeCount, isLiked: widget.likedFlag,onTap: onLikeButtonTapped),
                ),
            ],
          ),

            ],
          ),
        ),

    );
  }
}

Future<bool> onLikeButtonTapped(bool isLiked) async{
  /// send your request here
  // final bool success= await sendRequest();
  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

  return !isLiked;
}