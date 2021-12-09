// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economize_combustivel/clients/gas_stations_client.dart';
import 'package:economize_combustivel/cubit/location_cubit.dart';
import 'package:economize_combustivel/ui/widgets/location_map.dart';
import 'package:flutter/material.dart';
import 'package:economize_combustivel/ui/widgets/header.dart';
import 'package:economize_combustivel/ui/widgets/select.dart';
import 'package:economize_combustivel/ui/widgets/second_screen/gas_station_info_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen> {
  String _selectedFuel = 'Gasolina';
  String _selectedFilter = 'Menor preço';
  double _latitude = 0;
  double _longitude = 0;

  final gasStationsClient = GasStationsClient();

  void openMapWithCoordinates(GeoPoint mapPosition) {
    setState(() {
      _latitude = mapPosition.latitude;
      _longitude = mapPosition.longitude;
    });
  }

  void closeMap() {
    setState(() {
      _latitude = 0;
      _longitude = 0;
    });
  }

  void changeFuel(String? text) {
    if (text != null) {
      setState(() {
        _selectedFuel = text;
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
                      return _latitude != 0 && _longitude != 0
                          ? LocationMap(
                              latitude: _latitude,
                              longitude: _longitude,
                              goBack: closeMap)
                          : Material(
                              color: Theme.of(context).backgroundColor,
                              child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    Header(
                                        text:
                                            'Pesquisar em ${state.citySelected} - ${state.stateSelected}'),
                                    Text(
                                      'Tipo de combustível:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .apply(fontFamily: 'Poppins'),
                                    ),
                                    Select(
                                      items: const [
                                        'Gasolina',
                                        'Etanol',
                                        'Diesel'
                                      ],
                                      selected: _selectedFuel,
                                      onChanged: changeFuel,
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                        children: snapshot.data!
                                            .map<Widget>((gasStation) =>
                                                GasStationInfoCard(
                                                    title: gasStation['name'],
                                                    price: gasStation[
                                                                'average_price']
                                                            [_selectedFuel ==
                                                                    'Gasolina'
                                                                ? 'gasoline'
                                                                : _selectedFuel ==
                                                                        'Etanol'
                                                                    ? 'ethanol'
                                                                    : 'diesel']
                                                        .toString(),
                                                    address:
                                                        gasStation['address']
                                                            as String,
                                                    currentFuelType:
                                                        _selectedFuel,
                                                    isPrimaryColor: false,
                                                    openMap: () =>
                                                        openMapWithCoordinates(
                                                            gasStation[
                                                                    'map_position']
                                                                as GeoPoint)))
                                            .toList())
                                  ]),
                            );
                    }
                }
              }));
    });
  }
}
