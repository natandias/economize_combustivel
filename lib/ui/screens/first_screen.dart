import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:economize_combustivel/ui/widgets/first_screen/info_card.dart';
import 'package:economize_combustivel/ui/widgets/select.dart';
import 'package:economize_combustivel/cubit/location_cubit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economize_combustivel/clients/location_client.dart';
import 'package:economize_combustivel/clients/price_client.dart';

CollectionReference gasStations =
    FirebaseFirestore.instance.collection('gas_stations');

class CountryState {
  int id;
  String sigla;
  String nome;

  CountryState({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      id: json['id'] as int,
      nome: json['nome'].toString(),
      sigla: json['sigla'].toString(),
    );
  }
}

class City {
  int id;
  String nome;

  City({
    required this.id,
    required this.nome,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.parse(json['id']) as int,
      nome: json['nome'].toString(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  final locationClient = LocationClient();
  final priceClient = PriceClient();

  String? _state;
  String? _city;

  String? _gasPrice;
  String? _ethanolPrice;
  String? _dieselPrice;

  void changeCity(String? text) async {
    if (text != null) {
      Map<String, String> prices =
          await priceClient.getAverageFuelPricesByCity(text);
      setState(() {
        _gasPrice = prices['gasolinePrice'] ?? '';
        _ethanolPrice = prices['ethanolPrice'] ?? '';
        _dieselPrice = prices['dieselPrice'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<CountryState>>(
            future: locationClient.getStates(),
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
                    var states = snapshot.data!
                        .map((countryState) => countryState.sigla)
                        .toList();
                    states.sort();
                    return BlocBuilder<LocationCubit, LocationState>(
                        builder: (locationCubitBuilderContext, state) {
                      if (state.citySelected != '' &&
                          _gasPrice == null &&
                          _ethanolPrice == null &&
                          _dieselPrice == null) {
                        changeCity(state.citySelected);
                      }
                      return Material(
                        color: Theme.of(context).backgroundColor,
                        child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              const Header(text: 'app_name'),
                              Text(
                                'Estado',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(fontFamily: 'Poppins'),
                              ),
                              Select(
                                items: states,
                                selected: state.stateSelected != ''
                                    ? state.stateSelected
                                    : states[0],
                                onChanged: (value) => {
                                  BlocProvider.of<LocationCubit>(context)
                                      .changeState(value),
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Cidade:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .apply(fontFamily: 'Poppins'),
                              ),
                              Select(
                                  items: state.cities,
                                  selected: state.citySelected != ''
                                      ? state.citySelected
                                      : state.cities.isNotEmpty
                                          ? state.cities[0]
                                          : '',
                                  onChanged: (value) => {
                                        BlocProvider.of<LocationCubit>(context)
                                            .changeCity(value),
                                        changeCity(value),
                                      }),
                              Card(
                                child: SizedBox(
                                  width: 300,
                                  height: 30,
                                  child: Align(
                                    alignment: const Alignment(-0.5, 0),
                                    child: Text(
                                      state.citySelected != ''
                                          ? 'Média semanal de preços em ${state.citySelected}'
                                          : 'Escolha seu estado e cidade nos campos acima',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
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
                                children: [
                                  /// Example: it is good practice to put widgets in separate files.
                                  /// This way the screen files won't become too large and
                                  /// the code becomes more clear.
                                  InfoCard(
                                      title: 'Gasolina',
                                      icon: Ionicons.text_outline,
                                      price: _gasPrice ?? '',
                                      isPrimaryColor: false),
                                  InfoCard(
                                      title: 'Etanol',
                                      icon: Ionicons.text_outline,
                                      price: _ethanolPrice ?? '',
                                      isPrimaryColor: false),
                                  InfoCard(
                                      title: 'Diesel',
                                      icon: Ionicons.text_outline,
                                      price: _dieselPrice ?? '',
                                      isPrimaryColor: false),
                                ],
                              ),
                              const SizedBox(height: 36),
                            ]),
                      );
                    });
                  }
              }
            }));
  }
}
