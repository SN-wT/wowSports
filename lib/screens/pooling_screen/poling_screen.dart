import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_chart/d_chart.dart';
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
          if (state is AllreadyPolledState) {
            debugPrint('showing snackbar for link connected ');
            AppUtils.showSnackBar("Already polled", context);
          }
        },
        child: const _LayOut(),
      ),
    );
  }
}

class _LayOut extends StatefulWidget {
  const _LayOut({Key key}) : super(key: key);

  @override
  State<_LayOut> createState() => _LayOutState();
}

class _LayOutState extends State<_LayOut> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PolingScreenCubit>();

    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return BlocBuilder<PolingScreenCubit, PolingScreenState>(
      bloc: cubit,
      builder: (context, state) => Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const MyAppBar(
            appbartitle: 'Polls',
          ),
          (cubit.state is PolingScreenLoadingState)
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColorResource.Color_0EA,
                  ),
                )
              : Expanded(
                  child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: cubit.pollsDetail.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: 2.36 / 3),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                /*
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColorResource.Color_000,
                                    blurRadius: 1, // soften the shadow
                                  )
                                ],

                               */
                                color: AppColorResource.Color_F3F,
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                    color: AppColorResource.Color_FFF)),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
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
                                        imageUrl: cubit.polls[index].pollURL
                                                .toString() ??
                                            "")),
                                Center(
                                  child: Text(
                                    cubit.questions[index].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColorResource.Color_000,
                                      fontFamily: 'Nunito',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                /*
                                AppButton(
                                  onPressed: () {
                                    debugPrint(
                                        'polllists are ${cubit.polledLists}');
                                    debugPrint(
                                        'polllists are ${cubit.questions[index]}');
                                    cubit.polledLists
                                            .contains(cubit.questions[index])
                                        ? debugPrint('contains')
                                        : debugPrint("not contains");
                                  },
                                  child: Text('hello'),
                                )
                              */
                                cubit.polledLists.contains(cubit
                                        .questions[index]
                                        .replaceAll(" ", "")
                                        .replaceAll(".", ""))
                                    ? FutureBuilder(
                                        future: cubit.getPollAnswers(index),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<Map<String, int>>
                                                choicesResponseMapLocal) {
                                          if (choicesResponseMapLocal
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return Column(
                                              children: const [
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColorResource
                                                        .Color_0EA,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: DChartBar(
                                                data: [
                                                  {
                                                    'id': 'Bar',
                                                    'data': [
                                                      {
                                                        'domain':
                                                            choicesResponseMapLocal
                                                                .data.keys
                                                                .toList()[0],
                                                        'measure':
                                                            choicesResponseMapLocal
                                                                .data.values
                                                                .toList()[0]
                                                      },
                                                      {
                                                        'domain':
                                                            choicesResponseMapLocal
                                                                .data.keys
                                                                .toList()[1],
                                                        'measure':
                                                            choicesResponseMapLocal
                                                                .data.values
                                                                .toList()[1]
                                                      },
                                                      {
                                                        'domain':
                                                            choicesResponseMapLocal
                                                                .data.keys
                                                                .toList()[2],
                                                        'measure':
                                                            choicesResponseMapLocal
                                                                .data.values
                                                                .toList()[2]
                                                      }
                                                    ],
                                                  },
                                                ],
                                                domainLabelPaddingToAxisLine:
                                                    16,
                                                axisLineTick: 2,
                                                axisLinePointTick: 2,
                                                axisLinePointWidth: 10,
                                                axisLineColor:
                                                    AppColorResource.Color_0EA,
                                                measureLabelPaddingToAxisLine:
                                                    16,
                                                verticalDirection: false,
                                                barColor: (barData, index,
                                                        id) =>
                                                    AppColorResource.Color_0EA,
                                                showBarValue: true,
                                              ),
                                            ),
                                          );
                                        })
                                    : state is PolledState &&
                                            cubit.pollingIndex == index
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: DChartBar(
                                                data: [
                                                  {
                                                    'id': 'Bar',
                                                    'data': [
                                                      {
                                                        'domain': cubit
                                                            .choicesResponseMap
                                                            .keys
                                                            .toList()[0],
                                                        'measure': cubit
                                                            .choicesResponseMap
                                                            .values
                                                            .toList()[0]
                                                      },
                                                      {
                                                        'domain': cubit
                                                            .choicesResponseMap
                                                            .keys
                                                            .toList()[1],
                                                        'measure': cubit
                                                            .choicesResponseMap
                                                            .values
                                                            .toList()[1]
                                                      },
                                                      {
                                                        'domain': cubit
                                                            .choicesResponseMap
                                                            .keys
                                                            .toList()[2],
                                                        'measure': cubit
                                                            .choicesResponseMap
                                                            .values
                                                            .toList()[2]
                                                      }
                                                    ],
                                                  },
                                                ],
                                                domainLabelPaddingToAxisLine:
                                                    16,
                                                axisLineTick: 2,
                                                axisLinePointTick: 2,
                                                axisLinePointWidth: 10,
                                                axisLineColor:
                                                    AppColorResource.Color_0EA,
                                                measureLabelPaddingToAxisLine:
                                                    16,
                                                verticalDirection: false,
                                                barColor: (barData, index,
                                                        id) =>
                                                    AppColorResource.Color_0EA,
                                                showBarValue: true,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await cubit.request(
                                                          cubit.polls[index]
                                                              .choiceA,
                                                          cubit
                                                              .questions[index],
                                                          index);
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColorResource
                                                                  .Color_F3F,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColorResource
                                                                  .Color_0EA)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            (cubit.state is PollingScreenPoleRequestedState &&
                                                                        cubit.pollingIndex ==
                                                                            index
                                                                    ? "Loading..."
                                                                    : cubit
                                                                        .polls[
                                                                            index]
                                                                        .choiceA) ??
                                                                '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  AppColorResource
                                                                      .Color_000,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await cubit.request(
                                                          cubit.polls[index]
                                                              .choiceB,
                                                          cubit
                                                              .questions[index],
                                                          index);
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColorResource
                                                                  .Color_F3F,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColorResource
                                                                  .Color_0EA)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            (cubit.state is PollingScreenPoleRequestedState &&
                                                                        cubit.pollingIndex ==
                                                                            index
                                                                    ? "Loading..."
                                                                    : cubit
                                                                        .polls[
                                                                            index]
                                                                        .choiceB) ??
                                                                '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  AppColorResource
                                                                      .Color_000,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await cubit.request(
                                                          cubit.polls[index]
                                                              .choiceC,
                                                          cubit.questions[index]
                                                              .toString(),
                                                          index);
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColorResource
                                                                  .Color_F3F,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColorResource
                                                                  .Color_0EA)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            (cubit.state is PollingScreenPoleRequestedState &&
                                                                        cubit.pollingIndex ==
                                                                            index
                                                                    ? "Loading..."
                                                                    : cubit
                                                                        .polls[
                                                                            index]
                                                                        .choiceC) ??
                                                                '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  AppColorResource
                                                                      .Color_000,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
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
