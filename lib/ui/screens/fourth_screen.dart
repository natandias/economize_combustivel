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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: const [
            Header(text: 'Perfil'),
          ]),
    );
  }
}