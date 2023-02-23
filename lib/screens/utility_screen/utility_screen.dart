import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletutilityplugin/nft_detail/cubit/nft_detail_cubit.dart';
import 'package:walletutilityplugin/nft_detail/model/alchemy_nft_response.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/router.dart';
import 'package:wowsports/screens/utility_screen/cubit/utility_screen_cubit.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/widgets/button.dart';
import 'package:wowsports/widgets/myappbar.dart';

import 'cubit/utility_screen_state.dart';

class UtilityScreen extends StatelessWidget {
  const UtilityScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UtilityScreenCubit>();

    return Scaffold(
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is UtilityScreenErrorState) {
            AppUtils.showSnackBar(state.error, context);
          }
        },
        child: const UtilityScreens(),
      ),
    );
  }
}

class UtilityScreens extends StatelessWidget {
  const UtilityScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UtilityScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return BlocBuilder<UtilityScreenCubit, UtilityScreenState>(
      bloc: cubit,
      builder: (context, state) => Column(
        children: [
          const MyAppBar(
            appbartitle: 'Utility',
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      onPressed: () {
                        OwnedNfts ownedNfts = OwnedNfts();

                        ownedNfts = OwnedNfts.fromJson({
                          "metadata": {
                            "image":
                                'https://wowt.mypinata.cloud/ipfs/QmPYQGv6hHcBgNMVXHCmvoWzWo9rMiw1DMZxpPmLVHvX8x',
                            //"animation_url": video,
                            "specific": "coolie.png",
                            "specific1": null,
                            "target": "coolie.jpg",
                            "attributes": [
                              {
                                "value": 'faceswapimage',
                                "_id": "63a3f22287a884872f2eb594",
                                "trait_type": "utility"
                              },
                              {
                                "value": "faceswapimage",
                                "_id": "63a3f22287a884872f2eb595",
                                "trait_type": "utility"
                              }
                            ],
                          },
                        });

                        final args = NFTDetailArgs(ownedNfts);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.nftDetail,
                          arguments: args,
                        );
                      },
                      child: const Text(
                        'Face Swap Image',
                        style: TextStyle(color: AppColorResource.Color_FFF),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      onPressed: () async {
                        cubitAuth.loggedOut();
                      },
                      child: const Text(
                        'Face Swap Gif',
                        style: TextStyle(color: AppColorResource.Color_FFF),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      onPressed: () async {
                        await cubit.flow();
                      },
                      child: const Text(
                        'Face Swap Video',
                        style: TextStyle(color: AppColorResource.Color_FFF),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      onPressed: () async {
                        await cubit.getnfts();
                      },
                      child: const Text(
                        'Face Filter',
                        style: TextStyle(color: AppColorResource.Color_FFF),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      onPressed: () async {
                        if (Platform.isAndroid) {
                          await cubit.getArAvatarActivity();
                          // cubit.nftData?.metadata?.image as String,
                          // cubit.nftData?.metadata?.name as String);
                        }
                      },
                      child: const Text(
                        'Ar Avtar',
                        style: TextStyle(color: AppColorResource.Color_FFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
appBar: AppBar(
leading: Container(),
title: const Text(
'Utility',
style: TextStyle(color: ColorResource.Color_FFF),
),
backgroundColor: ColorResource.Color_0EA,
),

 */
