import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/login/cubit/login_screen_state.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_cubit.dart';
import 'package:wowsports/screens/pooling_screen/cubit/poling_screen_state.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/utils/theme.dart';
import 'package:wowsports/widgets/myappbar.dart';

class PolingScreen extends StatelessWidget {
  const PolingScreen({Key key}) : super(key: key);

  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setEnabledSystemUIOverlays([]);
    // AppUtils.enableFullScreenMode();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>();
    final cubit = context.read<PolingScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return Scaffold(
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
    double option1 = 1.0;
    double option2 = 0.0;
    double option3 = 1.0;
    double option4 = 1.0;
    final cubit = context.read<PolingScreenCubit>();

    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return BlocBuilder<PolingScreenCubit, PolingScreenState>(
      bloc: cubit,
      builder: (context, state) => (cubit.state is PolingScreenLoadingState ||
              cubit.state is PolingScreenPoleRequestedState)
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColorResource.Color_1FFF,
            ))
          : Column(
              children: [
                const MyAppBar(
                  appbartitle: 'Polls',
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: AppColorResource.Color_000,
                                blurRadius: 3, // soften the shadow
                              )
                            ],
                            color: AppColorResource.Color_F3F,
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            border:
                                Border.all(color: AppColorResource.Color_FFF)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => const SizedBox(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColorResource.Color_FFF,
                                          ),
                                        ),
                                      ),
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/pollImages%2FNBA_Finals_(2023).png?alt=media&token=86a2fb99-3510-43d1-8536-23f8b4b16bef"),
                            ),
                            const Text(
                              "If you like this ?",
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                          color: AppColorResource.Color_F3F,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color:
                                                  AppColorResource.Color_0EA)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'choiceA',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColorResource.Color_000,
                                              fontFamily: 'Nunito',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                          color: AppColorResource.Color_F3F,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color:
                                                  AppColorResource.Color_0EA)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'choiceB',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColorResource.Color_000,
                                              fontFamily: 'Nunito',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                          color: AppColorResource.Color_F3F,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color:
                                                  AppColorResource.Color_0EA)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'choiceC',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColorResource.Color_000,
                                              fontFamily: 'Nunito',
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
    );
  }
}
