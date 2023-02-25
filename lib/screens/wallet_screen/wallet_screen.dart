import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletutilityplugin/nft_detail/cubit/nft_detail_cubit.dart';
import 'package:walletutilityplugin/nft_detail/model/alchemy_nft_response.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/router.dart';
import 'package:wowsports/screens/wallet_screen/model/getnfts/get_bft_response_model.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/widgets/button.dart';
import 'package:wowsports/widgets/myappbar.dart';

import 'cubit/wallet_screen_cubit.dart';
import 'cubit/wallet_screen_state.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletScreenCubit>();

    return BlocListener(
      bloc: cubit,
      listener: (context, state) {

        if (state is WalletScreenErrorState) {
          AppUtils.showSnackBar(state.error, context);
        }
        if(state is WalletScreenLinkrefreshState){
          debugPrint('showing snackbar for link connected ');
          AppUtils.showSnackBar("Public key linked", context);
        }
        debugPrint('listener state is ${state}');
      },
      child: const LayOut(),
    );
  }
}

class LayOut extends StatelessWidget {
  const LayOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();
    var abcd;
    return Scaffold(
        body: Column(
      children: [
        const MyAppBar(
          appbartitle: 'Wallet',
        ),
        BlocBuilder<WalletScreenCubit, WalletScreenState>(
            builder: (context, state) => (cubit.state
                        is WalletScreenInitialState ||
                    cubit.state is WalletScreenLoadingState)
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColorResource.Color_1FFF,
                  ))
                : Expanded(
                    child: ListView(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 2.0),
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColorResource.Color_000),
                                color: AppColorResource.Color_FFF),
                            child: ListTile(
                              title: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Account details',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColorResource.Color_000,
                                        fontFamily: 'Nunito',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Address : ${cubit.address}",
                                      style: const TextStyle(
                                          color: AppColorResource.Color_000,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  //  FutureBuilder( future:  cubitAuth.balanceQuery() ,builder: );
                                  FutureBuilder(
                                      future: cubit.balanceQuery(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> balance) {
                                        String showBalance = "Loading...";
                                        if (balance.connectionState ==
                                            ConnectionState.done) {
                                          showBalance = balance.data;
                                        }
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          child: balance != null
                                              ? Text(
                                                  "Flow : ${showBalance}",
                                                  style: const TextStyle(
                                                      color: AppColorResource
                                                          .Color_000,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                )
                                              : const Text(
                                                  "Loading",
                                                  style: TextStyle(
                                                      color: AppColorResource
                                                          .Color_000,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ),
                                        );
                                      }),

                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: IconButton(
                                          color: AppColorResource.Color_0EA,
                                          onPressed: () async {
                                            showBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              AppColorResource
                                                                  .Color_000),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: AppColorResource
                                                          .Color_FFF),
                                                  height:
                                                      ((MediaQuery.of(context)
                                                              .size
                                                              .height) /
                                                          2.5),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ListView(
                                                          children: [
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    size: 23,
                                                                    color: AppColorResource
                                                                        .Color_000,
                                                                  ),
                                                                )),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Link account',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColorResource
                                                                          .Color_000,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Stubbing with public key as use couldn't find a non-custodial mobile wallet sdk to integrate with",
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColorResource
                                                                          .Color_000,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                height: 50,
                                                                width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    (1.2)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: AppColorResource
                                                                        .Color_FFF,
                                                                    border: Border.all(
                                                                        color: AppColorResource
                                                                            .Color_000)),
                                                                child:
                                                                    TextField(
                                                                  decoration: const InputDecoration(
                                                                      hintText:
                                                                          "Enter public key",
                                                                      hintStyle: TextStyle(
                                                                          color: AppColorResource
                                                                              .Color_000),
                                                                      prefixIcon:
                                                                          Icon(Icons
                                                                              .key_rounded)),
                                                                  style: const TextStyle(
                                                                      color: AppColorResource
                                                                          .Color_000),
                                                                  controller: cubit
                                                                      .puplickeytextcontroller,
                                                                  onTap: () {},
                                                                  obscureText:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Center(
                                                              child: SizedBox(
                                                                width: 200,
                                                                child: InkWell(
                                                                  child:
                                                                      AppButton(
                                                                    onPressed:
                                                                        () async {
                                                                          Navigator.pop(context);
                                                                      cubit.pkey = cubit
                                                                          .puplickeytextcontroller
                                                                          .text;
                                                                      debugPrint(
                                                                          'the pkey is ${cubit.pkey}');
                                                                      await cubit
                                                                          .linkkey(
                                                                              cubit.pkey, context);

                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Link account",
                                                                      style:
                                                                          TextStyle(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.link_sharp,
                                              //          weight: 123,
                                              color: AppColorResource.Color_0EA,
                                              size: 25),
                                        ),
                                      ),
                                      /*
                                      Center(
                                        child: IconButton(
                                          onPressed: () async {
                                            showBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              AppColorResource
                                                                  .Color_000),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: AppColorResource
                                                          .Color_FFF),
                                                  height:
                                                      ((MediaQuery.of(context)
                                                              .size
                                                              .height) /
                                                          3),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ListView(
                                                          children: [
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    size: 23,
                                                                    color: AppColorResource
                                                                        .Color_000,
                                                                  ),
                                                                )),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Unlink account form wowSports',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColorResource
                                                                          .Color_000,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    "You want to unlink your account from wowSports please authenticate to  unlink",
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColorResource
                                                                          .Color_000,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            IconButton(
                                                              highlightColor:
                                                                  AppColorResource
                                                                      .Color_000,
                                                              onPressed: () {
                                                                CustomBottomSheet();
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .fingerprint_sharp,
                                                                weight: 20,
                                                                color: AppColorResource
                                                                    .Color_0EA,
                                                                size: 90,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.link_off_outlined,
                                              color: AppColorResource.Color_0EA,
                                              size: 25),
                                        ),
                                      ),
                                      \
                                       */
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // NFTs for the Wallet
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Your NFTs',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColorResource.Color_000,
                              fontFamily: 'Nunito',
                              fontStyle: FontStyle.normal,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                        height: 5,
                        color: AppColorResource.Color_1FFF,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: cubitAuth.getYourNFTs(),
                          builder: (BuildContext context,
                              AsyncSnapshot<NFTResponse> nftResponse) {
                            List<Body> nftData = [];

                            if (nftResponse.data != null &&
                                nftResponse.data != null &&
                                nftResponse.data.body.isNotEmpty) {
                              nftData = nftResponse.data.body.reversed.toList();
                            }
                            if (nftResponse.connectionState ==
                                ConnectionState.waiting) {
                              debugPrint('nftdata waiting');
                              return const SizedBox(
                                height: 255,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              debugPrint('nftdata length is ${nftData.length}');
                              return RefreshIndicator(
                                onRefresh: cubit.init,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: nftData.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 2.3 / 3),
                                  itemBuilder: (context, index) => Stack(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              debugPrint(
                                                  'length is ${nftData.length}');
                                              debugPrint(
                                                  'length is ${nftData[index].specific}');
                                              debugPrint(
                                                  'length is ${nftData[index].target}');
                                              debugPrint(
                                                  'length is ${nftData[index].specific1}');
                                              OwnedNfts ownedNfts = OwnedNfts();

                                              // debugPrint('target image is ${nftData[index].target}');
                                              ownedNfts = OwnedNfts.fromJson({
                                                "metadata": {
                                                  "image":
                                                      nftData[index].url ?? '',
                                                  //"animation_url": video,
                                                  "specific": nftData[index]
                                                              .specific ==
                                                          "NA"
                                                      ? null
                                                      : nftData[index].specific,
                                                  "specific1": nftData[index]
                                                              .specific1 ==
                                                          "NA"
                                                      ? null
                                                      : nftData[index]
                                                          .specific1,
                                                  "target":
                                                      nftData[index].target ??
                                                          "",
                                                  "attributes": [
                                                    {
                                                      "value":
                                                          nftData[index].type,
                                                      "_id":
                                                          "63a3f22287a884872f2eb594",
                                                      "trait_type": "utility"
                                                    },
                                                    {
                                                      "value": "faceswapimage",
                                                      "_id":
                                                          "63a3f22287a884872f2eb595",
                                                      "trait_type": "utility"
                                                    }
                                                  ],
                                                },
                                              });
                                              final args =
                                                  NFTDetailArgs(ownedNfts);
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.nftDetail,
                                                arguments: args,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColorResource
                                                      .Color_F3F,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                      color: AppColorResource
                                                          .Color_000)),
                                              height: 300,
                                              width: ((MediaQuery.of(context)
                                                      .size
                                                      .width) /
                                                  1.8),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const SizedBox(
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              AppColorResource
                                                                  .Color_FFF,
                                                        ),
                                                      ),
                                                    ),
                                                    fit: BoxFit.fill,
                                                    imageUrl: nftData[index]
                                                            .url
                                                            .toString() ??
                                                        "",
                                                  )
                                                  // 'https://firebasestorage.googleapis.com/v0/b/flowhackathon.appspot.com/o/nftImages%2FMsDhoni.png?alt=media&token=87fa8ebe-fbd5-44b9-9db8-656ade5a7163'),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                          top: null,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 60,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.8,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColorResource.Color_000
                                                          .withOpacity(0.6),
                                                  border: Border.all(
                                                      color: AppColorResource
                                                          .Color_000),
                                                  // shape: BoxShape.rectangle,
                                                  // borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8, 3, 0, 3),
                                                            child: Text(
                                                              'Name : ${nftData[index].name.toString() ?? ""}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColorResource
                                                                    .Color_FFF,
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
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8, 3, 0, 3),
                                                            child: Text(
                                                              'Utility : ${nftData[index].utility == 'faceswap' ? 'Face swap' : 'AR Avatar'}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColorResource
                                                                    .Color_FFF,
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        /*
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: const Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          8, 3, 0, 3),
                                                      child: Text(
                                                        'Type : Image',
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: AppColorResource
                                                              .Color_000,
                                                          fontFamily: 'Nunito',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                   */
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }
                          })
                    ],
                  )))
      ],
    ));
  }
}
