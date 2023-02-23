import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wowsports/utils/app_utils.dart';

class EchoCubitDelegate extends BlocObserver {
  @override
  // ignore: avoid_renaming_method_parameters
  void onChange(BlocBase cubit, Change change) {
    super.onChange(cubit, change);
    // ignore: avoid_print
    if (DebugMode.isInDebugMode) print(change);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    // ignore: avoid_print
    if (DebugMode.isInDebugMode) print(error);
  }
}
