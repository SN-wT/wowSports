import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/screens/pooling_screen/poling_screen.dart';
import 'package:wowsports/screens/settings_screen/settings_screen.dart';
import 'package:wowsports/screens/tab/cubit/tab_screen_cubit.dart';
import 'package:wowsports/screens/utility_screen/utility_screen.dart';
import 'package:wowsports/screens/wallet_screen/wallet_screen.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/utils/theme.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  void initState() {
    AppUtils.exitFullScreenMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TabScreenCubit>();
    final AppColors appColors = Theme.of(context).extension<AppColors>();

    context.select((TabScreenCubit cubit) => cubit.tabIndex);
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: const _Layout(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColorResource.Color_0EA, AppColorResource.Color_1FFF],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            color: AppColorResource.Color_0EA),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
          unselectedItemColor: AppColorResource.Color_FFF,
          backgroundColor: Colors.transparent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.wallet,
                    size: 25,
                    color: AppColorResource.Color_FFF,
                  )),
              activeIcon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.wallet,
                    size: 35,
                    color: AppColorResource.Color_FFF,
                  )),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.feed_sharp,
                    size: 25,
                    color: AppColorResource.Color_FFF,
                  )),
              activeIcon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.feed_sharp,
                    size: 35,
                    color: AppColorResource.Color_FFF,
                  )),
              label: 'Feeds',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.business_center_outlined,
                    size: 25,
                    color: AppColorResource.Color_FFF,
                  )),
              activeIcon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.business_center_outlined,
                    size: 35,
                    color: AppColorResource.Color_FFF,
                  )),
              label: 'Buy',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.how_to_vote_rounded,
                    size: 25,
                    color: AppColorResource.Color_FFF,
                  )),
              activeIcon: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.how_to_vote_rounded,
                    size: 35,
                    color: AppColorResource.Color_FFF,
                  )),
              label: 'Polls',
            ),
          ],
          currentIndex: cubit.tabIndex,
          selectedItemColor: AppColorResource.Color_FFF,
          iconSize: 20,
          onTap: (int i) {
            cubit.onTabIndexChanged(i);
          },
        ),
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TabScreenCubit>();
    context.select((TabScreenCubit cubit) => cubit.tabIndex);
    switch (cubit.tabIndex) {
      case 0:
        return const LayOut();
      case 1:
        return const UtilityScreen();
      case 2:
        return const SettingsScreen();
      case 3:
        return const PolingScreen();
      default:
        return Container();
    }
  }
}
