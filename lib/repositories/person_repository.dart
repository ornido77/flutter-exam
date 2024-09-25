import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person_model.dart';

class PersonRepository {
  final int _limit = 60;
  bool _hasMoreData = true;

  Future<List<Person>> fetchPersons() async {
    if (!_hasMoreData) return [];
    
    final url = Uri.parse('https://fakerapi.it/api/v1/persons?_locale=en_PH&_quantity=$_limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      if (data.isEmpty) _hasMoreData = false;
      return data.map((person) => Person.fromJson(person)).toList();
    } else {
      throw Exception('Failed to load persons');
    }
  }

  bool hasMoreData() => _hasMoreData;
}
