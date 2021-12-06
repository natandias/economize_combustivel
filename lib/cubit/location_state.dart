import 'package:hydrated_bloc/hydrated_bloc.dart';

part of 'location_cubit.dart';

// ignore: must_be_immutable
class LocationState extends Equatable {
  String stateSelected = '';
  String citySelected = '';
  List<String> states;
  List<String> cities;

  LocationState({
    required this.stateSelected,
    required this.citySelected,
    required this.states,
    required this.cities,
  });

  LocationState copyWith({
    String? stateSelected,
    String? citySelected,
    List<String>? states,
    List<String>? cities,
  }) {
    return LocationState(
      stateSelected: stateSelected ?? this.stateSelected,
      citySelected: citySelected ?? this.citySelected,
      states: states ?? this.states,
      cities: cities ?? this.cities,
    );
  }

  @override
  List<Object> get props => [
        stateSelected,
        citySelected,
        states,
        cities
      ];

  Map<String, dynamic> toMap() {
    return {
      'stateSelected': stateSelected,
      'citySelected': citySelected,
      'states': states,
      'cities': cities,
    };
  }

  factory LocationState.fromMap(Map<String, dynamic> map) {
    return LocationState(
      stateSelected: map['stateSelected'] ?? '',
      citySelected: map['citySelected'] ?? '',
      states: map['states'] ?? [],
      cities: map['cities'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationState.fromJson(String source) =>
      LocationState.fromMap(json.decode(source));
}
