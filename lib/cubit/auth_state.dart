import 'package:hydrated_bloc/hydrated_bloc.dart';

part of 'auth_cubit.dart';

// ignore: must_be_immutable
class AuthState extends Equatable {
  bool isLogged = false;
  String userName = '';

  AuthState({
    required this.isLogged,
    required this.userName,
  });

  AuthState copyWith({
    bool? isLogged,
    String? userName,
  }) {
    return AuthState(
      isLogged: isLogged ?? this.isLogged,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object> get props => [
        isLogged,
        userName,
      ];

  Map<String, dynamic> toMap() {
    return {
      'isLogged': isLogged,
      'userName': userName,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      isLogged: map['isLogged'],
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));
}
