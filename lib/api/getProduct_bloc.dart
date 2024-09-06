import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<dynamic> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductFailure extends ProductState {
  final String error;

  const ProductFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse(
            'https://api-keyway-app.azurewebsites.net/api/services/app/Produto/GetAll'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final products = responseBody['result']['items'];
        print(products.length);
        emit(ProductLoaded(products));
      } else {
        emit(ProductFailure('Falha ao carregar produtos: ${response.body}'));
      }
    } catch (e) {
      emit(ProductFailure('Erro: ${e.toString()}'));
    }
  }
}
