import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;

  const Header({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 20.0),
      child: Text(
        tr(text),
        textAlign: TextAlign.start,
        style:
            Theme.of(context).textTheme.headline6!.apply(fontFamily: 'Poppins'),
      ),
    );
  }
}
