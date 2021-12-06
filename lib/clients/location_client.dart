import 'dart:convert';

import 'package:economize_combustivel/ui/screens/first_screen.dart';
import 'package:http/http.dart' as http;

class LocationClient {
  Future<List<CountryState>> getStates() async {
    const request =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados';
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
    List<City> citiesList =
        jsonArray.map((json) => City.fromJson(json)).toList();

    return citiesList;
  }
}
