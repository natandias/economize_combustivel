import 'package:flutter/material.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:economize_combustivel/ui/widgets/select.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:economize_combustivel/clients/price_client.dart';
import 'package:economize_combustivel/clients/gas_stations_client.dart';
import 'package:economize_combustivel/cubit/location_cubit.dart';
import 'package:economize_combustivel/cubit/bottom_nav_cubit.dart';
import 'package:ionicons/ionicons.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreen();
}

class _ThirdScreen extends State<ThirdScreen> {
  final gasStationsClient = GasStationsClient();
  final priceClient = PriceClient();

  String? _selectedGasStation;
  String? _selectedFuel;
  String errorMsg = '';
  final priceController = TextEditingController();

  void changeGasStation(String? gasStation) {
    if (gasStation != null) {
      setState(() {
        _selectedGasStation = gasStation;
      });
    }
  }

  void changeSelectedFuel(String? fuel) {
    if (fuel != null) {
      setState(() {
        _selectedFuel = fuel;
      });
    }
  }

  void changePrice(String price) {
    priceController.value = priceController.value.copyWith(
      text: price,
      selection: TextSelection.fromPosition(
        TextPosition(offset: price.length),
      ),
    );
  }

  void registerPrice(String city, String state) async {
    if (_selectedGasStation == null) {
      setState(() {
        errorMsg = 'Selecione um posto de gasolina';
      });
    } else if (_selectedFuel == null) {
      setState(() {
        errorMsg = 'Selecione o tipo de combustível';
      });
    } else if (priceController.text.isEmpty) {
      setState(() {
        errorMsg = 'Informe o preço do combustível';
      });
    }

    if (_selectedGasStation != null &&
        _selectedFuel != null &&
        priceController.text.isNotEmpty) {
      await priceClient.registerPrice(
        _selectedGasStation as String,
        city,
        state,
        _selectedFuel == 'Gasolina'
            ? 'gasoline'
            : _selectedFuel == 'Etanol'
                ? 'ethanol'
                : 'diesel',
        double.parse(priceController.text),
      );

      print('Price registered');

      setState(() {
        errorMsg = 'Cadastrado com sucesso!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
        builder: (locationCubitBuilderContext, state) {
      return Scaffold(
          body: FutureBuilder<List<dynamic>>(
              future: gasStationsClient.getGasStations(
                  state.citySelected, "average_price.diesel", false),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                        child: Text(
                      'Carregando dados...',
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                        'Erro ao carregar dados :(',
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ));
                    } else {
                      var gasStations = snapshot.data!
                          .map((gasStation) => gasStation['name'] as String)
                          .toList();
                      gasStations.sort();

                      if (errorMsg == 'Cadastrado com sucesso!') {
                        BlocProvider.of<BottomNavCubit>(context).updateIndex(0);
                      }

                      return Material(
                        color: Theme.of(context).backgroundColor,
                        child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              const Header(text: 'Adicione um preço'),
                              Text(
                                'Selecione o posto:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(fontFamily: 'Poppins'),
                              ),
                              Select(
                                items: gasStations,
                                selected: _selectedGasStation,
                                onChanged: changeGasStation,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecione o combustível:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(fontFamily: 'Poppins'),
                              ),
                              Select(
                                items: const ['Gasolina', 'Etanol', 'Diesel'],
                                selected: _selectedFuel,
                                onChanged: changeSelectedFuel,
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                keyboardType: TextInputType.number,
                                onChanged: changePrice,
                                controller: priceController,
                                decoration: const InputDecoration(
                                    labelText: 'Preço',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.0),
                                    ),
                                    prefixText: 'R\$',
                                    prefixStyle: TextStyle(
                                        color: Colors.white, fontSize: 18.0)),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                                onPressed: () => registerPrice(
                                    state.citySelected, state.stateSelected),
                                child: const Text(
                                  'Cadastrar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                errorMsg,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(fontFamily: 'Poppins'),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                      );
                    }
                }
              }));
    });
  }
}
