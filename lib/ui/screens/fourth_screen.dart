import 'package:economize_combustivel/ui/widgets/fourth_screen/login_form.dart';
import 'package:flutter/material.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';

class FourthScreen extends StatelessWidget {
  const FourthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(physics: const BouncingScrollPhysics(), children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(start: 16, end: 16),
          child: Header(text: 'Perfil'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: SizedBox(height: 400, child: LoginForm()),
        ),
        // SizedBox(height: 13, child: Text('teste')),
      ]),
    );
  }
}
