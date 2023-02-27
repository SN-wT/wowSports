import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletutilityplugin/authentication/authentication_cubit.dart';
import 'package:walletutilityplugin/nft_detail/cubit/nft_detail_cubit.dart';
import 'package:walletutilityplugin/nft_detail/nft_detail_screen.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/cubit/feeds_screen_cubit.dart';
import 'package:wowsports/screens/login/cubit/login_screen_cubit.dart';
import 'package:wowsports/screens/login/login_screen.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_cubit.dart';
import 'package:wowsports/screens/settings_screen/cubit/settings_screen_cubit.dart';
import 'package:wowsports/screens/tab/cubit/tab_screen_cubit.dart';
import 'package:wowsports/screens/tab/tab_screen.dart';
 import 'package:wowsports/screens/wallet_screen/cubit/wallet_screen_cubit.dart';
import 'package:wowsports/utils/color_resource.dart';

import 'authentication/authentication_state.dart';

class AppRoutes {
  static const String login = "login";
  static const String home = "home";
  static const String walletHome = "walletHome";
  static const String utility = "utility";
  static const String settings = "settings";
  static const String nftDetail = "nftDetail";
  static const String poling = "poling";
}

Route<dynamic> getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.login:
      return _buildLoginScreen();
    case AppRoutes.home:
      return _buildHomeScreen(settings);
    case AppRoutes.nftDetail:
      return _buildNftDetailScreen(settings);
  /*
    case AppRoutes.walletHome:
      return _buildHomeScreen(settings);
    case AppRoutes.utility:
      return _buildNFTDetailScreen(settings);
    case AppRoutes.settings:
      return _buildOnBoardingScreen();
    */

    default:
      return _buildLoginScreen();
  }
}

MaterialPageRoute _buildHomeScreen(RouteSettings settings) {
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.home),
    builder: (context) =>
        addAuth(context, PageBuilder.buildHomeScreen(settings), "Homescreen"),
  );
}

MaterialPageRoute _buildNftDetailScreen(RouteSettings settings) {
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.home),
    builder: (context) =>
        addAuth(
            context, PageBuilder.buildNFTDetailScreen(settings), "NFT Detail"),
  );
}

MaterialPageRoute _buildLoginScreen() {
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.login),
    builder: (context) =>
        addAuth(context, PageBuilder.buildLoginScreen(), "Login"),
  );
}

Widget addAuth(BuildContext context, Widget widget, String callfrom) {
  debugPrint("memcheck : in addAuth $callfrom");
  final AuthenticationCubitBloc authenticationCubit =
  BlocProvider.of<AuthenticationCubitBloc>(context);

  /*
  return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (snapshot.data != null &&
              snapshot.data != ConnectivityResult.mobile &&
              snapshot.data != ConnectivityResult.wifi) {
            AppUtils.showSnackBar('Oops! No internet ', context);
          }
          // debugPrint("SchedulerBinding");
        });
        */
  debugPrint(' inside Before BlocListener ');
  bool listenerrunflag = false;

  return BlocListener(
    bloc: authenticationCubit,
    listener: (BuildContext context, AuthenticationState state) {
      debugPrint("memcheck : in listener ");
      debugPrint(' inside BlocListener $state');
      debugPrint('came inside the loop $listenerrunflag');
      listenerrunflag = true;

      if (state is AuthenticationUnAuthenticatedState) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }

      if ((state is AuthenticationAddreessReceivedState)) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        TabScreenArgs args = TabScreenArgs(2);
        if (authenticationCubit.auth.currentUser != null) {
          args = TabScreenArgs(0);
        }
        debugPrint('came inside the loop');
        Navigator.pushReplacementNamed(context, AppRoutes.home,
            arguments: args);
      }
    },
    child: BlocBuilder(
      bloc: authenticationCubit,
      builder: (BuildContext context, AuthenticationState state) {
        debugPrint("memcheck : in Blockbuilder ");

        if (state is AuthenticationInitialState ||
            state is AuthenticationLoadingState ||
            state is AuthenticationAddreessRequestedState) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          /*
          if (!listenerrunflag) {
            authenticationCubit.listenerreset(AuthenticationStateReset());
            authenticationCubit.listenerreset(state);
          }

           */
          return widget;
        }
      },
    ),
  );

  // });
}

class PageBuilder {
  static Widget buildLoginScreen() {
    return BlocProvider(
      create: (context) {
        final AuthenticationCubitBloc authenticationCubit =
        BlocProvider.of<AuthenticationCubitBloc>(context);
        return LoginScreenCubit(authenticationCubit)
          ..init();
      },
      child: const LoginScreen(),
    );
  }

  static Widget buildNFTDetailScreen(RouteSettings settings) {
    return BlocProvider(
      create: (context) {
        final AuthenticationCubit authenticationCubit =
        BlocProvider.of(context);
        final args = settings.arguments as NFTDetailArgs;
        return NFTDetailCubit(authenticationCubit, args)
          ..init();
      },
      child: NFTDetailScreen(
          appbarcolor: AppColorResource.Color_0EA,
          buttonbordercolor: AppColorResource.Color_0EA,
          buttontextcolor: AppColorResource.Color_FFF,
          textcolor: AppColorResource.Color_FFF,
          buttoncolor: AppColorResource.Color_0EA,
          pagecolor: AppColorResource.Color_FFF),
    );
  }

  static Widget buildHomeScreen(RouteSettings settings) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final AuthenticationCubitBloc authenticationCubit =
            BlocProvider.of<AuthenticationCubitBloc>(context);
            final args = settings.arguments as TabScreenArgs;
            return TabScreenCubit(authenticationCubit, args)
              ..init();
          },
        ),
        BlocProvider(create: (context) {
          final AuthenticationCubitBloc authenticationCubit =
          BlocProvider.of<AuthenticationCubitBloc>(context);
          return WalletScreenCubit(authenticationCubit)
            ..init();
        }),
        BlocProvider(create: (context) {
          final AuthenticationCubitBloc authenticationCubit =
          BlocProvider.of<AuthenticationCubitBloc>(context);
          return SettingsScreenCubit(authenticationCubit)
            ..init();
        }),
        BlocProvider(create: (context) {
          final AuthenticationCubitBloc authenticationCubit =
          BlocProvider.of<AuthenticationCubitBloc>(context);
          return PolingScreenCubit(authenticationCubit)
            ..init();
        }),

        BlocProvider(create: (context) {
          final AuthenticationCubitBloc authenticationCubit =
          BlocProvider.of<AuthenticationCubitBloc>(context);
          return FeedsScreenCubit(authenticationCubit)
            ..init();
        }),


      ],
      child: const TabScreen(),
    );
  }
}
