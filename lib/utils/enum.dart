import 'package:json_annotation/json_annotation.dart';

enum MediaType { image, video }

enum FilterType {
  @JsonValue('faceswapimage')
  swapImage,
  @JsonValue('faceswap')
  swapVideo,
  @JsonValue('faceswapgif')
  faceswapgif,
  @JsonValue('facefilter')
  filter,
  @JsonValue('ARAvatar')
  aravatar,
  @JsonValue('faceswapvideo')
  faceswapvideo,
  @JsonValue('ARfilter')
  ARfilter,
  @JsonValue('Genesis')
  Genesis,
  @JsonValue('others')
  others,
}
