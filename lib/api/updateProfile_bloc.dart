import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _updateProfileUrl =
      'https://api-keyway-app.azurewebsites.net/api/services/app/User/Update';

  Future<void> updateProfile({
    required int id,
    required String name,
    required String email,
    required String biography,
  }) async {
    // Recuperar o token salvo
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final body = json.encode({
      'id': id,
      'name': name,
      'emailAddress': email,
      'biography': biography,
    });

    print(body);

    final response = await http.put(
      Uri.parse(_updateProfileUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['error']['message'];
      throw Exception('Falha ao atualizar o perfil: $errorMessage');
    }
  }
}
