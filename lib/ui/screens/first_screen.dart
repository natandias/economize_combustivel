import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:economize_combustivel/ui/widgets/first_screen/info_card.dart';
import 'package:economize_combustivel/ui/widgets/select.dart';
import 'package:ionicons/ionicons.dart';

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
      id: json['id'] as int,
      nome: json['nome'].toString(),
    );
  }
}

Future<List<CountryState>> getStates() async {
  const request = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';
  http.Response response = await http.get(Uri.parse(request));

  List<dynamic> jsonArray = json.decode(response.body) as List<dynamic>;
  List<CountryState> countryStatesList =
      jsonArray.map((json) => CountryState.fromJson(json)).toList();

  return countryStatesList;
}

Future<List<City>> getCities(String state) async {
  var request =
      'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$state/distritos';
  http.Response response = await http.get(Uri.parse(request));

  List<dynamic> jsonArray = json.decode(response.body) as List<dynamic>;
  List<City> citiesList = jsonArray.map((json) => City.fromJson(json)).toList();

  return citiesList;
}

void getGasPrices(String city, String state) async {
  // var request = '';
  // http.Response response = await http.get(Uri.parse(request));

  // List<dynamic> jsonArray = json.decode(response.body) as List<dynamic>;
  // List<GasPrice> gasPricesList =
  //     jsonArray.map((json) => GasPrice.fromJson(json)).toList();
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  String? _state;
  String? _city;

  String _gasPrice = '';
  String _ethanolPrice = '';
  String _dieselPrice = '';

  List<String> _cities = [];

  void changeState(String? text) {
    if (text != null) {
      setState(() {
        _state = text;
      });

      List<String> citiesList = [];

      getCities(text).then((cities) => {
            for (var city in cities) {citiesList.add(city.nome)},
            setState(() {
              _cities = citiesList;
            }),
            _cities.sort(),
            setState(() {
              _city = citiesList[0];
              _gasPrice = '7,19';
              _ethanolPrice = '6,00';
              _dieselPrice = '5,00';
            })
          });
    }
  }

  void changeCity(String? text) {
    if (text != null) {
      setState(() {
        _city = text;
        _gasPrice = '6,40';
        _ethanolPrice = '5,20';
        _dieselPrice = '4,40';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<CountryState>>(
            future: getStates(),
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
                    return Material(
                      color: Theme.of(context).backgroundColor,
                      child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const Header(text: 'app_name'),
                            Text(
                              'Estado:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(fontFamily: 'Poppins'),
                            ),
                            Select(
                              items: states,
                              selected: _state,
                              onChanged: changeState,
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
                              items: _cities,
                              selected: _city,
                              onChanged: changeCity,
                            ),
                            Card(
                              child: SizedBox(
                                width: 300,
                                height: 30,
                                child: Align(
                                  alignment: const Alignment(-0.5, 0),
                                  child: Text(
                                    _city != null
                                        ? 'Média semanal de preços em $_city'
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
                                    price: _gasPrice,
                                    isPrimaryColor: false),
                                InfoCard(
                                    title: 'Etanol',
                                    icon: Ionicons.text_outline,
                                    price: _ethanolPrice,
                                    isPrimaryColor: false),
                                InfoCard(
                                    title: 'Diesel',
                                    icon: Ionicons.text_outline,
                                    price: _dieselPrice,
                                    isPrimaryColor: false),
                              ],
                            ),
                            const SizedBox(height: 36),
                          ]),
                    );
                  }
              }
            }));
  }
}
