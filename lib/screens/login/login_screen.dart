import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/router.dart';
import 'package:wowsports/screens/login/cubit/login_screen_cubit.dart';
import 'package:wowsports/screens/login/cubit/login_screen_state.dart';
import 'package:wowsports/screens/tab/cubit/tab_screen_cubit.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/utils/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setEnabledSystemUIOverlays([]);
    // AppUtils.enableFullScreenMode();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>();
    final cubit = context.read<LoginScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return Scaffold(
      /*
      appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: AppColorResource.Color_FFF),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
                colors: <Color>[
                  AppColorResource.Color_0EA,
                  AppColorResource.Color_1FFF,
                ],
              ),
            ),
          )
          ),
       */
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is LoginScreenErrorState) {
            AppUtils.showSnackBar(state.error, context);
          }
        },
        child: const _LayOut(),
      ),
    );
  }
}

class _LayOut extends StatelessWidget {
  const _LayOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginScreenCubit>();

    final cubitAuth = context.read<AuthenticationCubitBloc>();
    final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId:
            '965871970667-isvp35ibijbu0879208udhjvgq8gvitk.apps.googleusercontent.com');

    return BlocBuilder<LoginScreenCubit, LoginScreenState>(
        bloc: cubit,
        builder: (context, state) => cubit.state is! LoginScreenLoadingState
            ? StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/playstore.png",
                                height: 85,
                                width: 100,
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 250,
                              child: Center(
                                widthFactor: 200,
                                child: GoogleSignInButton(
                                  clientId:
                                      "965871970667-isvp35ibijbu0879208udhjvgq8gvitk.apps.googleusercontent.com",
                                  onTap: () async {
                                    await cubit.login();
                                  },
                                ),
                              ),
                            ),

/*
                            Center(
                              child: AppButton(
                                onPressed: () async {
                                  await cubit.login();
                                },
                                child: const Text('Login with google'),
                              ),
                            ),

 */
                          ],
                        ),
                      ),
                    );
/*
            InkWell(
                onTap: () async {
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser?.authentication;
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  await cubitAuth.loggedIn();
                },
                child: const Text('fyhgfvjghfc')
                /*
              GoogleSignInButton(
                  action: AuthAction.signIn,
                  onTap: () async {
                    _googleSignIn.signIn();
                    // AuthAction.signIn;
                    await cubitAuth.loggedIn();
                  },
                  clientId:
                      '965871970667-isvp35ibijbu0879208udhjvgq8gvitk.apps.googleusercontent.com'),

               */
                );
            return const SignInScreen(
              providerConfigs: [
                GoogleProviderConfiguration(
                    clientId:
                        '965871970667-isvp35ibijbu0879208udhjvgq8gvitk.apps.googleusercontent.com'),
                AppleProviderConfiguration()
              ],
            );

 */
                  }
                  if (FirebaseAuth.instance.currentUser == null) {
                    debugPrint('came inside the condition');
                    Navigator.pushNamed(context, AppRoutes.home,
                        arguments: TabScreenArgs(2));
                  }

                  return BlocListener(
                      bloc: cubit,
                      listener: (context, state) {
                        if (state is LoginScreenErrorState) {
                          AppUtils.showSnackBar(state.error, context);
                        }
                      },
                      child: Container());

                  // return const ;
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                color: AppColorResource.Color_1FFF,
              )));
  }
}

/*
class _Layout extends StatelessWidget {
  const _Layout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginScreenCubit>();

    return BlocBuilder<LoginScreenCubit, LoginScreenState>(
      bloc: cubit,
      builder: (context, state) => cubit.state is LoginScreenLoadingState
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColorResource.Color_0EA,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: ((MediaQuery.of(context).size.height) / 4)),
                  const Center(
                    child: Text('You are successfully logged in as',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                        cubit.email != null ? cubit.email.toString() : '',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: AppButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home,
                            arguments: TabScreenArgs(0));
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            color: AppColorResource.Color_FFF, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

 */
/*
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

void init() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIOverlays([]);
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final cubit = context.read<LoginScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubit>();

    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(
            appbartitle: 'Login',
          ),
          BlocListener(
            bloc: cubit,
            listener: (context, state) {
              if (state is LoginScreenErrorState) {
                AppUtils.showSnackBar(state.error, context);
              }
            },
            child: const _LayOut(),
          ),
        ],
      ),
    );
  }
}
 */
