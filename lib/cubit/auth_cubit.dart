import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:economize_combustivel/clients/location_client.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit()
      : super(
          AuthState(
            isLogged: false,
            userName: '',
          ),
        );

  void changeIsLogged(bool? newValue) {
    emit(state.copyWith(isLogged: newValue));
  }

  void changeUsername(String? newValue) =>
      emit(state.copyWith(userName: newValue));

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toMap();
  }
}
