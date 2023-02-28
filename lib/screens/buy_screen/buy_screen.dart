import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletutilityplugin/nft_detail/cubit/nft_detail_cubit.dart';
import 'package:walletutilityplugin/nft_detail/model/alchemy_nft_response.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/router.dart';
import 'package:wowsports/screens/buy_screen/cubit/buy_screen_state.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/widgets/button.dart';
import 'package:wowsports/widgets/myappbar.dart';

import 'cubit/buy_screen_cubit.dart';
import 'model/marketplace_model/nftresponse.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuyScreenCubit>();

    return BlocListener(
      bloc: cubit,
      listener: (context, state) {
        if (state is BuyScreenErrorState) {
          AppUtils.showSnackBar(state.error, context);
        }
      },
      child: const SettingsScreenLayOut(),
    );
  }
}

class SettingsScreenLayOut extends StatelessWidget {
  const SettingsScreenLayOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BuyScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return BlocBuilder<BuyScreenCubit, BuyScreenState>(
      bloc: cubit,
      builder: (context, state) => Column(
        children: [
          const MyAppBar(
            appbartitle: 'Marketplace',
          ),
          (cubit.state is BuyScreenLoadingState)
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColorResource.Color_0EA,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: [
                      FutureBuilder(
                          future: cubitAuth.getMarketPlaceNFTs(),
                          builder: (BuildContext context,
                              AsyncSnapshot<NFTDataResponse> nftResponse) {
                            List<NFTS> nftData = [];
                            if (nftResponse.data != null &&
                                nftResponse.data?.items != null &&
                                nftResponse.data.items.isNotEmpty) {
                              nftData = nftResponse.data.items[0].nFTS.reversed
                                  .toList();
                            }
                            if (nftResponse.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 255,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                onRefresh: cubit.init,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: nftData.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 3 / 3),
                                  itemBuilder: (context, index) => Stack(
                                    alignment: Alignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 350,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        decoration: BoxDecoration(
                                            color: AppColorResource.Color_F3F,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: AppColorResource
                                                    .Color_000)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
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
                                              imageUrl: (nftData[index]
                                                      .fbImageUrl
                                                      .toString()) ??
                                                  ''),
                                        ),
                                      ),
                                      Positioned.fill(
                                          bottom: 6,
                                          top: null,
                                          child: Center(
                                            child: Container(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              decoration: BoxDecoration(
                                                color: AppColorResource
                                                    .Color_000.withOpacity(0.8),
                                                border: Border.all(
                                                    color: AppColorResource
                                                        .Color_000),
                                                // shape: BoxShape.rectangle,
                                                // borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Name : ${nftData[index].name ?? ''}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color:
                                                              AppColorResource
                                                                  .Color_FFF,
                                                          fontFamily: 'Nunito',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Text(
                                                          'Utility : ${nftData[index].utility == 'faceswap' ? 'Face swap' : 'AR Avatar'}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                AppColorResource
                                                                    .Color_FFF,
                                                            fontFamily:
                                                                'Nunito',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: cubit.minted[
                                                                    index] ==
                                                                "false"
                                                            ? Center(
                                                                child: SizedBox(
                                                                    height: 30,
                                                                    width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        (4)),
                                                                    child:
                                                                        AppButton(
                                                                      onPressed:
                                                                          () async {
                                                                        //await cubitAuth.loggedOut();
                                                                        showBottomSheet(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Container(
                                                                              decoration: BoxDecoration(border: Border.all(color: AppColorResource.Color_000), borderRadius: BorderRadius.circular(5), color: AppColorResource.Color_FFF),
                                                                              height: ((MediaQuery.of(context).size.height) / 2.4),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: ListView(
                                                                                      children: [
                                                                                        Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: InkWell(
                                                                                              onTap: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Padding(
                                                                                                padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                                                                                                child: Icon(
                                                                                                  Icons.close,
                                                                                                  size: 30,
                                                                                                  color: AppColorResource.Color_000,
                                                                                                ),
                                                                                              ),
                                                                                            )),
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: const Padding(
                                                                                            padding: EdgeInsets.all(8.0),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                'Buy NFT',
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
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: const Padding(
                                                                                            padding: EdgeInsets.all(8.0),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "Mock payment details for testnet",
                                                                                                style: TextStyle(
                                                                                                  color: AppColorResource.Color_000,
                                                                                                  fontFamily: 'Nunito',
                                                                                                  fontStyle: FontStyle.normal,
                                                                                                  fontSize: 16,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Container(
                                                                                            height: 50,
                                                                                            width: (MediaQuery.of(context).size.width / (1.2)),
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColorResource.Color_FFF, border: Border.all(color: AppColorResource.Color_000)),
                                                                                            child: TextField(
                                                                                              decoration: const InputDecoration(hintText: "Enter credit/debit card number", hintStyle: TextStyle(color: AppColorResource.Color_000), prefixIcon: Icon(Icons.credit_card_sharp)),
                                                                                              style: const TextStyle(color: AppColorResource.Color_000),
                                                                                              controller: cubit.creditcardcontroller,
                                                                                              onTap: () {},
                                                                                              obscureText: true,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Container(
                                                                                            height: 50,
                                                                                            width: (MediaQuery.of(context).size.width / (1.2)),
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColorResource.Color_FFF, border: Border.all(color: AppColorResource.Color_000)),
                                                                                            child: TextField(
                                                                                              decoration: const InputDecoration(hintText: "Enter cvv", hintStyle: TextStyle(color: AppColorResource.Color_000), prefixIcon: Icon(Icons.numbers_sharp)),
                                                                                              style: const TextStyle(color: AppColorResource.Color_000),
                                                                                              controller: cubit.cvvcontroller,
                                                                                              onTap: () {},
                                                                                              obscureText: true,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Center(
                                                                                              child: SizedBox(
                                                                                                width: (MediaQuery.of(context).size.width / (2.6)),
                                                                                                child: AppButton(
                                                                                                  onPressed: () async {
                                                                                                    Navigator.pop(context);
                                                                                                    await cubit.mint(nftData[index].name ?? '', index, nftData.length);
                                                                                                    debugPrint('list items ${cubit.minted[index]}');
                                                                                                  },
                                                                                                  child: const Text('Buy NFT'),
                                                                                                ),
                                                                                              ),
                                                                                            )),
                                                                                        const SizedBox(
                                                                                          height: 30,
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
                                                                      child:
                                                                          Text(
                                                                        cubit.state is BuyScreenMintRequestedState &&
                                                                                cubit.mintingIndex == index
                                                                            ? "Loading"
                                                                            : 'Buy',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              AppColorResource.Color_FFF,
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          fontStyle:
                                                                              FontStyle.normal,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    )),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 30,
                                                                    width: (MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        (3)),
                                                                    child:
                                                                        AppButton(
                                                                      onPressed:
                                                                          () async {
                                                                        OwnedNfts
                                                                            ownedNfts =
                                                                            OwnedNfts();

                                                                        // debugPrint('target image is ${nftData[index].target}');
                                                                        ownedNfts =
                                                                            OwnedNfts.fromJson({
                                                                          "metadata":
                                                                              {
                                                                            "image":
                                                                                nftData[index].fbImageUrl.toString() ?? '',
                                                                            //"animation_url": video,
                                                                            "specific": nftData[index].specific != "NA"
                                                                                ? nftData[index].specific
                                                                                : null,
                                                                            "specific1": nftData[index].aRUrl != "NA"
                                                                                ? nftData[index].aRUrl
                                                                                : nftData[index].specific1 != "NA"
                                                                                    ? nftData[index].specific1
                                                                                    : null,
                                                                            "target":
                                                                                nftData[index].target ?? "",
                                                                            "attributes":
                                                                                [
                                                                              {
                                                                                "value": nftData[index].type,
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
                                                                        final args =
                                                                            NFTDetailArgs(ownedNfts);
                                                                        Navigator
                                                                            .pushNamed(
                                                                          context,
                                                                          AppRoutes
                                                                              .nftDetail,
                                                                          arguments:
                                                                              args,
                                                                        );
                                                                        //   await  cubit.mint(nftData[index].name ?? '');
                                                                        //await cubit.check();
                                                                      },
                                                                      child: Text(nftData[index].utility ==
                                                                              'faceswap'
                                                                          ? 'Face swap'
                                                                          : 'AR Avatar'),
                                                                    ),
                                                                  ),
                                                                )),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Text(
                                                      'Price : ${nftData[index].price.toString()}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: AppColorResource
                                                            .Color_FFF,
                                                        fontFamily: 'Nunito',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
        ],
      ),

      /*
                          Center(
                            child: AppButton(
                              onPressed: () async {
                                await cubitAuth.loggedOut();
                              },
                              child: const Text('Log out'),
                            ),
                          )
                          */
    );
  }
}
