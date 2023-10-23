import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/models/user.dart';

class UserApi {
  static Future<List<User>> fetchUsers() async {
    try {
      print('Calling API...');
      const url = "https://randomuser.me/api/?results=100";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] as List<dynamic>;

        final List<User> users = results.map((e) {
         
          return User(
            gender: e['gender'],
            email: e['email'],
            phone: e['phone'],
          );
        }).toList();

        print('appel api');
        print(users);

        print('Users fetched successfully');
        return users;
      } else {
        // Gérer les réponses d'erreur HTTP ici.
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      // Gérer les erreurs ici.
      print("Error during API call: $e");
      throw e;
    }
  }
}
