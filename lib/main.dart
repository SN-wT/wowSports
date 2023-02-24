import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletutilityplugin/authentication/authentication_cubit.dart';
import 'package:wowsports/cubit.dart';
import 'package:wowsports/router.dart';

import 'authentication/authentication_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseDatabase.instance.setPersistenceEnabled(true);
  BlocOverrides.runZoned(
    () {
      runApp(MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubitBloc>(
            create: (BuildContext context) => AuthenticationCubitBloc()..init(),
          ),
          BlocProvider<AuthenticationCubit>(
            create: (BuildContext context) => AuthenticationCubit()..init(),
          ),
        ],
        child: const MyApp(),
      ));
    },
    blocObserver: EchoCubitDelegate(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData appTheme =
        context.select<AuthenticationCubitBloc, ThemeData>(
      (testCubit) => testCubit.appTheme,
    );
    debugPrint("memcheck : main Material app ");
    return MaterialApp(
      // initialRoute: AppRoutes.login,
      onGenerateRoute: getRoutes,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: addAuth(context, Container(), "Main"),
    );
  }
}

/*
  runApp(BlocProvider<AuthenticationCubitBloc>(
        create: (BuildContext context) {
          return AuthenticationCubitBloc()..init();
        },
        child: const MyApp(),
      ));
 */
