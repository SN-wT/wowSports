import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:walletutilityplugin/wallet/appcolors.dart';
import 'package:wowsports/utils/color_resource.dart';

class MyAppBar extends StatelessWidget {
  final AppBar appbar;
  final String appbartitle;
  final Icon icon;
  final TabBar tabbar;
  final List<Widget> action;
  final Color color;
  const MyAppBar(
      {Key key,
      this.appbar,
      this.tabbar,
      this.appbartitle,
      this.icon,
      this.color,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>();

    return AppBar(
      elevation: 5,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      flexibleSpace: Container(
        height: 50,
      ),
      title: Center(
        child: Text(
          appbartitle ?? '',
          style: const TextStyle(
            color: AppColorResource.Color_000,
            fontSize: 24,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColorResource.Color_FFF,
    );

    NewGradientAppBar(
      actions: action ?? Container(),
      elevation: 10,
      bottom: tabbar,
      leading: icon ?? Container(),
      title: Text(
        appbartitle ?? '',
        style: TextStyle(color: color, fontSize: 22),
      ),
      gradient: const LinearGradient(
          colors: <Color>[
            AppColorResource.Color_1FFF,
            AppColorResource.Color_0EA,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.mirror),
    );
  }
}
/*
AppBar(
        automaticallyImplyLeading: false,
        leading: icon!,
        title: Text(appbartitle!),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.deepPurple, Colors.red]),
          ),
        ),
      ),
 */
