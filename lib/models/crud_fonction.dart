

import '../services/sqllite_service.dart';

class UserService {
  static Future<int> addUser( String genre, String email, String phone) async {
    return await SqliteService.createData( genre, email, phone);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    return await SqliteService.getAllUser();
  }

  static Future<void> updateUser(int id, String genre, String email, String phone) async {
    await SqliteService.updateUser(id, email, phone, genre);
  }

  static Future<void> deleteUser(int id) async {
    await SqliteService.deleteUser(id);
  }
}
