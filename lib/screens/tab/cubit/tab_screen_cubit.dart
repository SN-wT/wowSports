

import 'package:wowsports/authentication/authentication_cubit.dart';
import 'package:wowsports/screens/tab/cubit/tab_screen_state.dart';
import 'package:wowsports/utils/base_cubit.dart';

class TabScreenCubit extends BaseCubit<TabScreenState> {
  final AuthenticationCubitBloc authenticationCubit;
  int tabIndex = 0;
  TabScreenCubit(this.authenticationCubit, TabScreenArgs args)
      : super(TabScreenInitialState()) {
    if (args != null) {
      tabIndex = args.tabIndex;
    }
  }
  Future<void> init() async {}

  void onTabIndexChanged(int index) {
    tabIndex = index;

    emit(TabScreenRefreshState());
  }
}

class TabScreenArgs {
  final int tabIndex;
  TabScreenArgs(this.tabIndex);
}
