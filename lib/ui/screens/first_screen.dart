import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_production_boilerplate/config/theme.dart';
import 'package:flutter_production_boilerplate/cubit/theme_cubit.dart';
import 'package:flutter_production_boilerplate/ui/widgets/header.dart';
import 'package:flutter_production_boilerplate/ui/widgets/first_screen/info_card.dart';
import 'package:ionicons/ionicons.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(text: 'app_name'),
            Card(
              child: const SizedBox(
                width: 300,
                height: 30,
                child: Align(
                  alignment: Alignment(-0.5, 0),
                  child: Text(
                    'Média semanal de preços em Montes Claros',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              color: Theme.of(context).splashColor,
            ),

            /// Example: Good way to add space between items
            const SizedBox(height: 8),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 1,
              children: const [
                /// Example: it is good practice to put widgets in separate files.
                /// This way the screen files won't become too large and
                /// the code becomes more clear.
                InfoCard(
                    title: 'Gasolina',
                    icon: Ionicons.text_outline,
                    price: '7,18',
                    isPrimaryColor: false),
                InfoCard(
                    title: 'Etanol',
                    icon: Ionicons.text_outline,
                    price: '5,00',
                    isPrimaryColor: false),
                InfoCard(
                    title: 'Diesel',
                    icon: Ionicons.text_outline,
                    price: '4,69',
                    isPrimaryColor: false),
              ],
            ),
            const SizedBox(height: 36),
          ]),
    );
  }
}
