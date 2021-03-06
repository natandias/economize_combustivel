import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:economize_combustivel/cubit/bottom_nav_cubit.dart';
import 'package:economize_combustivel/ui/screens/first_screen.dart';
import 'package:economize_combustivel/ui/screens/second_screen.dart';
import 'package:economize_combustivel/ui/screens/third_screen.dart';
import 'package:economize_combustivel/ui/screens/fourth_screen.dart';
import 'package:economize_combustivel/ui/widgets/app_bar_gone.dart';
import 'package:economize_combustivel/ui/widgets/bottom_nav_bar.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({Key? key}) : super(key: key);

  final _pageNavigation = const [
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
    FourthScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavCubit>(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (BuildContext context, int state) {
          return Scaffold(
            appBar: const AppBarGone(),

            /// When switching between tabs this will fade the old
            /// layout out and the new layout in.
            body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pageNavigation.elementAt(state)),
            /// Cannot be const, tab status will not update.
            bottomNavigationBar: BottomNavBar(),
          );
        },
      ),
    );
  }
}
