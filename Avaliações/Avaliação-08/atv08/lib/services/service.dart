import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personagem.dart';

class ApiService {
  final String baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<List<Personagem>> fetchPersonagens(int page) async {
    final url = '$baseUrl?page=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Personagem.fromJson(json)).toList();
    } else {
      throw Exception('Erro na API: ${response.statusCode}');
    }
  }
}
