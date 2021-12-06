import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:economize_combustivel/clients/location_client.dart';

part 'location_state.dart';

class LocationCubit extends HydratedCubit<LocationState> {
  final client = LocationClient();

  LocationCubit()
      : super(
          LocationState(
            stateSelected: '',
            citySelected: '',
            states: const [],
            cities: const [],
          ),
        );

  void changeState(String? newValue) {
    if (newValue != null) {
      List<String> localCities = [];
      client.getCities(newValue).then((cities) => {
            for (var city in cities) {localCities.add(city.nome)},
            localCities.sort(),
            changeCities(localCities),
            changeCity(localCities[0]),
            // getAverageFuelPricesByCity(citiesList[0])
          });
    }

    emit(state.copyWith(stateSelected: newValue));
  }

  void changeCity(String? newValue) =>
      emit(state.copyWith(citySelected: newValue));

  void changeCities(List<String>? newValues) =>
      emit(state.copyWith(cities: newValues));

  @override
  LocationState? fromJson(Map<String, dynamic> json) {
    return LocationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LocationState state) {
    return state.toMap();
  }
}
