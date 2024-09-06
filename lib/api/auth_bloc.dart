import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Chamada da API para autenticação

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthRequested>(_onAuthRequested);
  }

  Future<void> _onAuthRequested(
      AuthRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse(
            'https://api-keyway-app.azurewebsites.net/api/TokenAuth/Authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserNameOrEmailAddress': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['result']['accessToken'];

        // Salvar o token usando shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Falha ao autenticar: ${response.body}'));
      }
    } catch (e) {
      emit(AuthFailure('Erro: ${e.toString()}'));
    }
  }
}
