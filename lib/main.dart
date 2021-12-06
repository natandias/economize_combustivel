import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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

void main() async {
  /// Initialize packages
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
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
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
                /// Localization is not available for the title.
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
                  create: (themeCubitContext) => LocationCubit(),
                ),
              ],
              child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                return MaterialApp(
                  /// Localization is not available for the title.
                  title: 'Economize combustível',
                  theme: state.themeData,
                  home: const SkeletonScreen(),
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                );
              }));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
          title: const Text('Carregando...'),
        )));
      },
    );
  }
}
