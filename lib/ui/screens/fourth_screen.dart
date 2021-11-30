import 'package:economize_combustivel/ui/widgets/fourth_screen/text_field.dart';
import 'package:flutter/material.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:ionicons/ionicons.dart';

class FourthScreen extends StatelessWidget {
  const FourthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            Header(text: 'Perfil'),
            SizedBox(height: 256, child: TextFieldGeneral()),
          ]),
    );
  }
}
