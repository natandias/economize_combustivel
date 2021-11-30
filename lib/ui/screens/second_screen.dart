import 'package:flutter/material.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:economize_combustivel/ui/widgets/select.dart';
import 'package:economize_combustivel/ui/widgets/second_screen/fuel_info_card.dart';
import 'package:ionicons/ionicons.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen> {
  String _selectedFuel = 'Gasolina';
  String _selectedFilter = 'Menor preço';

  void changeFuel(String? text) {
    if (text != null) {
      setState(() {
        _selectedFuel = text;
      });
    }
  }

  void changeFilter(String? text) {
    if (text != null) {
      setState(() {
        _selectedFilter = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(text: 'Pesquisar'),
            Text(
              'Tipo de combustível:',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .apply(fontFamily: 'Poppins'),
            ),
            Select(
              items: const ['Gasolina', 'Etanol', 'Diesel'],
              selected: _selectedFuel,
              onChanged: changeFuel,
            ),
            const SizedBox(height: 8),
            Text(
              'Filtar por:',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .apply(fontFamily: 'Poppins'),
            ),
            Select(
              items: const ['Menor preço', 'Mais próximo'],
              selected: _selectedFilter,
              onChanged: changeFilter,
            ),
            const FuelInfoCard(
                title: 'Posto Turmalina II',
                price: '7,15',
                address: 'Rua dos Bobos, 0',
                user: 'Adriano',
                postDate: '23/10/2021',
                isPrimaryColor: false)
          ]),
    );
  }
}
