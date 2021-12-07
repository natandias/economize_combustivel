import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:economize_combustivel/clients/user.dart';
import 'package:economize_combustivel/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:economize_combustivel/cubit/location_cubit.dart';
import 'package:economize_combustivel/cubit/theme_cubit.dart';
import 'package:economize_combustivel/ui/screens/skeleton_screen.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  final tmpDir = await getApplicationDocumentsDirectory();
  Hive.init(tmpDir.toString());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: tmpDir,
  );

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                  create: (themeCubitContext) => ThemeCubit(),
                ),
                BlocProvider<LocationCubit>(
                  create: (themeCubitContext) => LocationCubit(),
                ),
              ],
              child: MaterialApp(
                title: 'Carregando...',
                theme: ThemeData(),
                home: const SkeletonScreen(),
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                  create: (themeCubitContext) => ThemeCubit(),
                ),
                BlocProvider<LocationCubit>(
                  create: (locationCubitContext) => LocationCubit(),
                ),
                BlocProvider<AuthCubit>(
                  create: (authCubitContext) => AuthCubit(),
                ),
              ],
              child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                final userClient = UserClient();

                FirebaseAuth auth = FirebaseAuth.instance;
                auth.authStateChanges().listen((User? user) async {
                  if (user != null) {
                    print('User is signed in: ${user.uid}');
                    Map<String, dynamic> userOnDB =
                        await userClient.getUser(user.uid);

                    var userName = userOnDB['userName'] as String;

                    BlocProvider.of<AuthCubit>(context).changeIsLogged(true);

                    BlocProvider.of<AuthCubit>(context)
                        .changeUsername(userName);
                  } else {
                    print('User is not signed in');
                  }
                });
                return MaterialApp(
                  title: 'Economize combustível',
                  theme: state.themeData,
                  home: const SkeletonScreen(),
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                );
              }));
        }

        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
          title: const Text('Carregando...'),
        )));
      },
    );
  }
}
