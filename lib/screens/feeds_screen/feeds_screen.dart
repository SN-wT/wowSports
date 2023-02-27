import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/feeds_screen/cubit/feeds_screen_cubit.dart';
import 'package:wowsports/screens/feeds_screen/post_item.dart';
import 'package:wowsports/utils/app_utils.dart';
import 'package:wowsports/utils/color_resource.dart';
import 'package:wowsports/widgets/myappbar.dart';

import 'cubit/feeds_screen_state.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedsScreenCubit>();

    return Scaffold(
      body: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          if (state is FeedsScreenErrorState) {
            AppUtils.showSnackBar(state.error, context);
          }
        },
        child: const FeedsScreens(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColorResource.Color_0EA,
        elevation: 5,
        onPressed: () {},
        child:
            const Icon(Icons.edit, color: AppColorResource.Color_F3F, size: 30),
      ),
    );
  }
}

class FeedsScreens extends StatelessWidget {
  const FeedsScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FeedsScreenCubit>();
    final cubitAuth = context.read<AuthenticationCubitBloc>();

    return BlocBuilder<FeedsScreenCubit, FeedsScreenState>(
      bloc: cubit,
      builder: (context, state) => Container(
        child: Column(
          children: [
            const MyAppBar(
              appbartitle: 'Feeds',
            ),
            state is FeedsScreenLoadingState
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColorResource.Color_1FFF,
                  ))
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cubit.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        PostItem postItem = cubit.posts[index];
                        return postItem;
                        /*
                  return PostItem(
                    img: post.img,
                    address: post.address,
                    //dp: post.dp,
                    time: post.time,
                  );

                   */
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
